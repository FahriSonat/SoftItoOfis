import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/ai_chat_repository.dart';
import '../domain/entities/ai_action.dart';
import '../domain/entities/ai_message.dart';
import '../domain/entities/ai_safety_route.dart';
import 'local_qwen3_coach_engine.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  static const String _historyKey = 'denge_ai_chat_history_v1';
  static const String _sessionOnlyKey = 'denge_ai_is_session_only_v1';

  final String? backendBaseUrl;
  List<ChatMessage> _memoryHistory = [];
  bool _isSessionOnly = false;
  bool _isInitialized = false;

  AiChatRepositoryImpl({this.backendBaseUrl});

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSessionOnly = prefs.getBool(_sessionOnlyKey) ?? false;
      if (!_isSessionOnly) {
        final rawJson = prefs.getString(_historyKey);
        if (rawJson != null && rawJson.isNotEmpty) {
          final list = jsonDecode(rawJson) as List<dynamic>;
          _memoryHistory = list
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (_) {
      // Fallback to memory
    }
    _isInitialized = true;
  }

  @override
  Future<List<ChatMessage>> getHistory() async {
    await _ensureInitialized();
    return List.unmodifiable(_memoryHistory);
  }

  @override
  Future<void> saveHistory(List<ChatMessage> messages) async {
    await _ensureInitialized();
    _memoryHistory = List.from(messages);
    if (!_isSessionOnly) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = jsonEncode(messages.map((m) => m.toJson()).toList());
        await prefs.setString(_historyKey, raw);
      } catch (_) {}
    }
  }

  @override
  Future<void> clearHistory() async {
    await _ensureInitialized();
    _memoryHistory.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (_) {}
  }

  @override
  Future<bool> getIsSessionOnly() async {
    await _ensureInitialized();
    return _isSessionOnly;
  }

  @override
  Future<void> setIsSessionOnly(bool value) async {
    await _ensureInitialized();
    _isSessionOnly = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_sessionOnlyKey, value);
      if (value) {
        // If switched to session-only, clear disk storage for privacy
        await prefs.remove(_historyKey);
      } else {
        // Save current history to disk
        final raw = jsonEncode(_memoryHistory.map((m) => m.toJson()).toList());
        await prefs.setString(_historyKey, raw);
      }
    } catch (_) {}
  }

  @override
  Future<ChatMessage> sendMessage({
    required String prompt,
    required List<ChatMessage> history,
    String? habitContext,
  }) async {
    // 1. Safety triage check locally first
    final localSafety = LocalQwen3CoachEngine.classifySafety(prompt);
    if (localSafety.isCritical ||
        localSafety == SafetyRoute.promptInjection ||
        localSafety == SafetyRoute.gamblingFinancialCrisis) {
      return LocalQwen3CoachEngine.generateResponse(
        prompt: prompt,
        history: history,
        habitContext: habitContext,
        isOffline: false,
      );
    }

    // 2. Try backend if configured
    final baseUrl = backendBaseUrl;
    if (baseUrl != null && baseUrl.isNotEmpty) {
      try {
        final uri = Uri.parse('$baseUrl/api/v1/ai/chat');
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 4);
        final request = await client.postUrl(uri);
        request.headers.set('Content-Type', 'application/json');

        final payload = jsonEncode({
          'prompt': prompt,
          'habitContext': habitContext,
          'history': history.map((m) => m.toJson()).toList(),
          'noThink': true, // enforce non-thinking mode for Qwen3
        });
        request.write(payload);
        final response = await request.close();

        if (response.statusCode == 200) {
          final responseBody = await response.transform(utf8.decoder).join();
          final data = jsonDecode(responseBody) as Map<String, dynamic>;
          final rawContent = data['content'] as String? ?? '';
          final cleanedContent =
              LocalQwen3CoachEngine.stripThinkingTags(rawContent);

          final actionsRaw = data['suggestedActions'] as List<dynamic>? ?? [];
          final actions = actionsRaw
              .map((e) => SuggestedAction.fromJson(e as Map<String, dynamic>))
              .toList();

          return ChatMessage(
            id: data['id'] as String? ??
                'ai_${DateTime.now().millisecondsSinceEpoch}',
            role: MessageRole.assistant,
            content: cleanedContent,
            timestamp: DateTime.now(),
            suggestedActions: actions,
            safetyRoute: localSafety,
            isOfflineFallback: false,
          );
        }
      } catch (_) {
        // Fallback to local on network or connection errors
      }
    }

    // 3. Fallback to Local Qwen3 Coach Engine
    return LocalQwen3CoachEngine.generateResponse(
      prompt: prompt,
      history: history,
      habitContext: habitContext,
      isOffline: true,
    );
  }

  @override
  Stream<String> sendMessageStream({
    required String prompt,
    required List<ChatMessage> history,
    String? habitContext,
  }) async* {
    final response = await sendMessage(
      prompt: prompt,
      history: history,
      habitContext: habitContext,
    );

    // Stream out words with micro delays to simulate natural typing
    final words = response.content.split(' ');
    for (int i = 0; i < words.length; i++) {
      yield words[i] + (i < words.length - 1 ? ' ' : '');
      await Future.delayed(const Duration(milliseconds: 15));
    }
  }
}
