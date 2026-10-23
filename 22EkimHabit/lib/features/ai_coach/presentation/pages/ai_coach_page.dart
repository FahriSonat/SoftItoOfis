import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../habits/domain/habit.dart';
import '../../../habits/presentation/providers/habit_providers.dart';
import '../../application/ai_chat_controller.dart';
import '../../application/ai_chat_state.dart';
import '../../domain/entities/ai_action.dart';
import '../../domain/entities/ai_message.dart';
import '../../domain/entities/ai_safety_route.dart';

class AiCoachPage extends ConsumerStatefulWidget {
  final String? initialHabitContext;

  const AiCoachPage({
    super.key,
    this.initialHabitContext,
  });

  @override
  ConsumerState<AiCoachPage> createState() => _AiCoachPageState();
}

class _AiCoachPageState extends ConsumerState<AiCoachPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    'Dürtü anındayım, yardım et',
    'Hedefimi nasıl kolaylaştırabilirim?',
    'Motivasyonum çok düşük',
    'Yeni bir alışkanlığa nasıl başlamalıyım?',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialHabitContext != null) {
        ref
            .read(aiChatControllerProvider.notifier)
            .loadInitialData(widget.initialHabitContext);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? presetText]) {
    final text = presetText ?? _textController.text;
    if (text.trim().isEmpty) return;

    ref.read(aiChatControllerProvider.notifier).sendMessage(text);
    if (presetText == null) {
      _textController.clear();
    }
    _scrollToBottom();
  }

  Future<void> _handleActionTap(SuggestedAction action) async {
    if (action.isExecuted) return;

    // Strict requirement: all actions require explicit user confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
        title: const Row(
          children: [
            Icon(Icons.verified_outlined, color: AppColors.info, size: 24),
            SizedBox(width: 8),
            Text('Eylemi Onayla', style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Denge Koçu şu eylemi gerçekleştirmeyi öneriyor:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                action.label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Denge, senin açık onayın olmadan alışkanlıklarında hiçbir değişiklik yapmaz.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Onayla ve Uygula'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(aiChatControllerProvider.notifier).requestExecuteAction(action);
      final executed = ref.read(aiChatControllerProvider.notifier).confirmPendingAction();

      if (executed != null) {
        _dispatchAction(executed);
      }
    }
  }

  void _dispatchAction(SuggestedAction action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Eylem uygulandı: ${action.label}'),
        backgroundColor: AppColors.surfaceHigh,
      ),
    );

    switch (action.type) {
      case 'start_support_timer':
      case 'open_support':
        final habitsAsync = ref.read(habitsListProvider);
        habitsAsync.whenData((habits) {
          final negHabit = habits.cast<Habit?>().firstWhere(
                (h) => h?.kind == HabitKind.negative,
                orElse: () => habits.isNotEmpty ? habits.first : null,
              );
          if (negHabit != null) {
            context.push('/habit/${negHabit.id}/urge-support');
          } else {
            context.push('/habit/new?kind=negative');
          }
        });
        break;

      case 'complete_positive_habit':
        final habitName = action.payload['habit'] as String?;
        if (habitName != null) {
          final habitsAsync = ref.read(habitsListProvider);
          habitsAsync.whenData((habits) {
            final habit = habits.firstWhere(
              (h) => h.name.toLowerCase() == habitName.toLowerCase(),
              orElse: () => habits.first,
            );
            ref.read(habitsListProvider.notifier).addEntry(
                  habitId: habit.id,
                  value: 1.0,
                  note: 'Denge Koçu önerisiyle tamamlandı',
                );
          });
        }
        break;

      case 'simplify_habit':
        // Contextual guidance
        _handleSend('Bu alışkanlığı nasıl daha küçük adımlara bölebilirim?');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiChatControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Denge Koçu',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: state.status == AiChatStatus.offline
                        ? AppColors.warning
                        : AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  state.status == AiChatStatus.offline
                      ? 'Çevrimdışı Rehberlik'
                      : 'Qwen3 AI Asistanı',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            color: AppColors.surfaceHigh,
            onSelected: (val) {
              if (val == 'session_toggle') {
                ref
                    .read(aiChatControllerProvider.notifier)
                    .toggleSessionOnly(!state.isSessionOnly);
              } else if (val == 'clear') {
                ref.read(aiChatControllerProvider.notifier).clearHistory();
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'session_toggle',
                child: Row(
                  children: [
                    Icon(
                      state.isSessionOnly
                          ? Icons.lock_clock
                          : Icons.lock_open,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.isSessionOnly
                          ? 'Geçici Mod (Aktif)'
                          : 'Kalıcı Geçmiş Modu',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                    SizedBox(width: 8),
                    Text('Sohbeti Temizle', style: TextStyle(color: AppColors.danger)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Safety emergency banner
            if (state.activeSafetyRoute != null &&
                state.activeSafetyRoute!.isCritical)
              _buildCriticalSafetyBanner(state.activeSafetyRoute!),

            // Offline resilience banner
            if (state.status == AiChatStatus.offline)
              _buildOfflineNoticeBanner(),

            // Habit context header if present
            if (state.habitContext != null && state.habitContext!.isNotEmpty)
              _buildHabitContextHeader(state.habitContext!),

            // Message list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                itemCount: state.messages.length +
                    (state.status == AiChatStatus.sending ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.messages.length) {
                    return _buildSendingIndicator();
                  }
                  final msg = state.messages[index];
                  return _buildMessageItem(msg);
                },
              ),
            ),

            // Quick suggestion chips
            if (state.messages.length <= 2) _buildQuickPromptsBar(),

            // Input Bar
            _buildInputBar(state),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalSafetyBanner(SafetyRoute route) {
    return Container(
      width: double.infinity,
      color: AppColors.danger.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.emergency_outlined, color: AppColors.danger, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Acil Durum & Destek Hattı',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (route.emergencyHelpline != null)
                  Text(
                    route.emergencyHelpline!,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineNoticeBanner() {
    return Container(
      width: double.infinity,
      color: AppColors.warning.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, color: AppColors.warning, size: 16),
          SizedBox(width: 8),
          Text(
            'Çevrimdışı Mod — Yerel Denge Koçu Rehberliği Aktif',
            style: TextStyle(
              color: AppColors.warning,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitContextHeader(String habitName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.canvasElevated,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: AppColors.info, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bağlam: "$habitName"',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              ref.read(aiChatControllerProvider.notifier).setHabitContext(null);
            },
            child: const Icon(Icons.close, color: AppColors.textMuted, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage msg) {
    final isUser = msg.role == MessageRole.user;
    final timeStr = DateFormat('HH:mm').format(msg.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceHigh,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome, color: AppColors.info, size: 16),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.info : AppColors.surfaceHigh,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: Border.all(
                      color: isUser
                          ? Colors.transparent
                          : AppColors.borderSubtle,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.content,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white70
                                  : AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Render suggested action buttons
          if (!isUser && msg.suggestedActions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: msg.suggestedActions.map((action) {
                  return ActionChip(
                    avatar: Icon(
                      action.isExecuted
                          ? Icons.check_circle
                          : Icons.touch_app_outlined,
                      size: 16,
                      color: action.isExecuted
                          ? AppColors.success
                          : AppColors.info,
                    ),
                    label: Text(
                      action.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: action.isExecuted
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        decoration: action.isExecuted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    backgroundColor: action.isExecuted
                        ? AppColors.surface
                        : AppColors.canvasElevated,
                    side: BorderSide(
                      color: action.isExecuted
                          ? AppColors.borderSubtle
                          : AppColors.info.withValues(alpha: 0.5),
                    ),
                    onPressed:
                        action.isExecuted ? null : () => _handleActionTap(action),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSendingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.surfaceHigh,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, color: AppColors.info, size: 16),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.info),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Denge Koçu düşünüyor...',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPromptsBar() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _quickPrompts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final prompt = _quickPrompts[i];
          return ActionChip(
            label: Text(
              prompt,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            backgroundColor: AppColors.surfaceHigh,
            side: const BorderSide(color: AppColors.borderSubtle),
            onPressed: () => _handleSend(prompt),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(AiChatState state) {
    final isSending = state.status == AiChatStatus.sending;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !isSending,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: state.isSessionOnly
                    ? 'Geçici sohbet (kaydedilmez)...'
                    : 'Koçuna bir şey sor veya hislerini paylaş...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                filled: true,
                fillColor: AppColors.surfaceHigh,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: isSending ? null : (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.send,
              color: isSending ? AppColors.textDisabled : AppColors.info,
            ),
            onPressed: isSending ? null : () => _handleSend(),
          ),
        ],
      ),
    );
  }
}
