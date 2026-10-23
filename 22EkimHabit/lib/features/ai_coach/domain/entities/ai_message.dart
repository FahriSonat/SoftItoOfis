import 'ai_action.dart';
import 'ai_safety_route.dart';

enum MessageRole {
  user,
  assistant,
  system;

  String toJson() => name;

  static MessageRole fromJson(String value) {
    switch (value) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
      default:
        return MessageRole.system;
    }
  }
}

class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final List<SuggestedAction> suggestedActions;
  final SafetyRoute? safetyRoute;
  final bool isOfflineFallback;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.suggestedActions = const [],
    this.safetyRoute,
    this.isOfflineFallback = false,
    this.isStreaming = false,
  });

  ChatMessage copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    List<SuggestedAction>? suggestedActions,
    SafetyRoute? safetyRoute,
    bool? isOfflineFallback,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      suggestedActions: suggestedActions ?? this.suggestedActions,
      safetyRoute: safetyRoute ?? this.safetyRoute,
      isOfflineFallback: isOfflineFallback ?? this.isOfflineFallback,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.toJson(),
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'suggestedActions': suggestedActions.map((a) => a.toJson()).toList(),
        'safetyRoute': safetyRoute?.name,
        'isOfflineFallback': isOfflineFallback,
        'isStreaming': isStreaming,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? '',
      role: MessageRole.fromJson(json['role'] as String? ?? 'user'),
      content: json['content'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      suggestedActions: (json['suggestedActions'] as List<dynamic>?)
              ?.map((e) => SuggestedAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      safetyRoute: json['safetyRoute'] != null
          ? SafetyRoute.values.firstWhere(
              (r) => r.name == json['safetyRoute'],
              orElse: () => SafetyRoute.normalCoaching,
            )
          : null,
      isOfflineFallback: json['isOfflineFallback'] as bool? ?? false,
      isStreaming: json['isStreaming'] as bool? ?? false,
    );
  }
}
