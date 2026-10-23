import 'entities/ai_message.dart';

abstract class AiChatRepository {
  Future<List<ChatMessage>> getHistory();
  Future<void> saveHistory(List<ChatMessage> messages);
  Future<void> clearHistory();

  Future<bool> getIsSessionOnly();
  Future<void> setIsSessionOnly(bool value);

  Future<ChatMessage> sendMessage({
    required String prompt,
    required List<ChatMessage> history,
    String? habitContext,
  });

  Stream<String> sendMessageStream({
    required String prompt,
    required List<ChatMessage> history,
    String? habitContext,
  });
}
