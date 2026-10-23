import '../domain/entities/ai_action.dart';
import '../domain/entities/ai_message.dart';
import '../domain/entities/ai_safety_route.dart';

enum AiChatStatus {
  initial,
  ready,
  sending,
  streaming,
  safetyRouted,
  offline,
  error,
}

class AiChatState {
  final AiChatStatus status;
  final List<ChatMessage> messages;
  final bool isSessionOnly;
  final SafetyRoute? activeSafetyRoute;
  final String? habitContext;
  final String? errorMessage;
  final SuggestedAction? pendingAction;

  const AiChatState({
    this.status = AiChatStatus.initial,
    this.messages = const [],
    this.isSessionOnly = false,
    this.activeSafetyRoute,
    this.habitContext,
    this.errorMessage,
    this.pendingAction,
  });

  AiChatState copyWith({
    AiChatStatus? status,
    List<ChatMessage>? messages,
    bool? isSessionOnly,
    SafetyRoute? activeSafetyRoute,
    String? habitContext,
    String? errorMessage,
    SuggestedAction? pendingAction,
    bool clearPendingAction = false,
  }) {
    return AiChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isSessionOnly: isSessionOnly ?? this.isSessionOnly,
      activeSafetyRoute: activeSafetyRoute ?? this.activeSafetyRoute,
      habitContext: habitContext ?? this.habitContext,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingAction: clearPendingAction ? null : (pendingAction ?? this.pendingAction),
    );
  }
}
