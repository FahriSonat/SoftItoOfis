import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_chat_repository_impl.dart';
import '../domain/ai_chat_repository.dart';
import '../domain/entities/ai_action.dart';
import '../domain/entities/ai_message.dart';
import 'ai_chat_state.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepositoryImpl();
});

final aiChatControllerProvider =
    NotifierProvider<AiChatNotifier, AiChatState>(AiChatNotifier.new);

class AiChatNotifier extends Notifier<AiChatState> {
  @override
  AiChatState build() {
    // Initial async load
    Future.microtask(() => loadInitialData());
    return const AiChatState(status: AiChatStatus.initial);
  }

  Future<void> loadInitialData([String? habitContext]) async {
    final repo = ref.read(aiChatRepositoryProvider);
    final history = await repo.getHistory();
    final isSessionOnly = await repo.getIsSessionOnly();

    if (history.isEmpty) {
      final welcomeMessage = ChatMessage(
        id: 'welcome_1',
        role: MessageRole.assistant,
        content: habitContext != null && habitContext.isNotEmpty
            ? 'Merhaba! "$habitContext" alışkanlığına özel Denge Koçun buradayım. Bugün nasıl gidiyor? Zorlandığın ya da kutlamak istediğin bir an var mı?'
            : 'Merhaba! Ben Denge Koçun. Alışkanlıklarını küçük, sürdürülebilir adımlara dönüştürmek ve zorlandığın anlarda şefkatle yanında olmak için buradayım. Bugün nereden başlayalım?',
        timestamp: DateTime.now(),
      );

      state = AiChatState(
        status: AiChatStatus.ready,
        messages: [welcomeMessage],
        isSessionOnly: isSessionOnly,
        habitContext: habitContext,
      );
      if (!isSessionOnly) {
        await repo.saveHistory([welcomeMessage]);
      }
    } else {
      state = state.copyWith(
        status: AiChatStatus.ready,
        messages: history,
        isSessionOnly: isSessionOnly,
        habitContext: habitContext ?? state.habitContext,
      );
    }
  }

  void setHabitContext(String? habitContext) {
    state = state.copyWith(habitContext: habitContext);
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMessage = ChatMessage(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      role: MessageRole.user,
      content: trimmed,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMessage);

    state = state.copyWith(
      status: AiChatStatus.sending,
      messages: updatedMessages,
      errorMessage: null,
    );

    try {
      final repo = ref.read(aiChatRepositoryProvider);
      final response = await repo.sendMessage(
        prompt: trimmed,
        history: updatedMessages,
        habitContext: state.habitContext,
      );

      final finalMessages = List<ChatMessage>.from(updatedMessages)..add(response);

      AiChatStatus nextStatus = AiChatStatus.ready;
      if (response.safetyRoute != null && response.safetyRoute!.isCritical) {
        nextStatus = AiChatStatus.safetyRouted;
      } else if (response.isOfflineFallback) {
        nextStatus = AiChatStatus.offline;
      }

      state = state.copyWith(
        status: nextStatus,
        messages: finalMessages,
        activeSafetyRoute: response.safetyRoute,
      );

      if (!state.isSessionOnly) {
        await repo.saveHistory(finalMessages);
      }
    } catch (e) {
      state = state.copyWith(
        status: AiChatStatus.error,
        errorMessage: 'Mesaj iletilemedi: $e',
      );
    }
  }

  Future<void> toggleSessionOnly(bool value) async {
    final repo = ref.read(aiChatRepositoryProvider);
    await repo.setIsSessionOnly(value);
    state = state.copyWith(isSessionOnly: value);
  }

  Future<void> clearHistory() async {
    final repo = ref.read(aiChatRepositoryProvider);
    await repo.clearHistory();

    final welcomeMessage = ChatMessage(
      id: 'welcome_new',
      role: MessageRole.assistant,
      content: 'Sohbet geçmişi temizlendi. Sıfırdan başlamaya hazırım!',
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      status: AiChatStatus.ready,
      messages: [welcomeMessage],
      activeSafetyRoute: null,
    );

    if (!state.isSessionOnly) {
      await repo.saveHistory([welcomeMessage]);
    }
  }

  void requestExecuteAction(SuggestedAction action) {
    state = state.copyWith(pendingAction: action);
  }

  SuggestedAction? confirmPendingAction() {
    final action = state.pendingAction;
    if (action == null) return null;

    final updatedMessages = state.messages.map((msg) {
      final updatedActions = msg.suggestedActions.map((act) {
        if (act.id == action.id) {
          return act.copyWith(isExecuted: true);
        }
        return act;
      }).toList();
      return msg.copyWith(suggestedActions: updatedActions);
    }).toList();

    state = state.copyWith(
      messages: updatedMessages,
      clearPendingAction: true,
    );

    if (!state.isSessionOnly) {
      ref.read(aiChatRepositoryProvider).saveHistory(updatedMessages);
    }

    return action;
  }

  void cancelPendingAction() {
    state = state.copyWith(clearPendingAction: true);
  }
}
