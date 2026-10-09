import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/error/result.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/application/auth_providers.dart';
import '../application/chat_providers.dart';
import '../domain/chat_provider.dart';
import '../domain/entities/agent_item.dart';
import '../domain/entities/conversation.dart';

/// Page displaying conversation history for a specific AI Agent, with action to start a new chat.
class AgentConversationListPage extends ConsumerWidget {
  const AgentConversationListPage({required this.agentId, super.key});

  final String agentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final agents = ref.watch(agentsProvider).value ?? const <AgentItem>[];
    final agent = agents.firstWhere(
      (a) => a.id == agentId,
      orElse: () => AgentItem(
        id: agentId,
        name: agentId,
        description: 'AI Assistant',
        role: 'Assistant',
      ),
    );

    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatAgentHistory(agent.name))),
      body: ResponsiveCenter(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                        child: const Icon(Icons.smart_toy_outlined),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agent.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              agent.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: l10n.chatStartNew,
                    icon: Icons.add_comment_outlined,
                    onPressed: () {
                      final newId = AgentItem.newConversationId(agentId);
                      context.push(AppRoutes.conversation(newId));
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: conversationsAsync.when(
                loading: () => const LoadingView(label: 'Loading history...'),
                error: (err, _) => ErrorView(
                  message: err.toString(),
                  onRetry: () => ref.refresh(conversationsProvider),
                ),
                data: (items) {
                  final modelId = agentModelId(agentId);
                  final agentHistory =
                      items.where((c) {
                          if (c.kind != ConversationKind.assistant) {
                            return false;
                          }
                          // Server chats name the model that answers in them.
                          if (c.participants.any((p) => p.id == modelId) ||
                              c.id.startsWith('agent-$agentId-')) {
                            return true;
                          }
                          if (agentId == 'mock-assistant') {
                            return c.id == 'assistant' ||
                                c.title.contains('Mock Assistant') ||
                                c.id.startsWith('agent-mock-assistant');
                          } else if (agentId == 'hr-assistant') {
                            return c.id.contains('hr') ||
                                c.title.contains('HR') ||
                                c.id.startsWith('agent-hr-assistant') ||
                                c.participants.any((p) => p.id == 'mock-hr');
                          } else if (agentId == 'legal-assistant') {
                            return c.id.contains('legal') ||
                                c.title.contains('Legal') ||
                                c.id.startsWith('agent-legal-assistant') ||
                                c.participants.any((p) => p.id == 'mock-legal');
                          }
                          return c.id.contains(agentId) ||
                              c.title.contains(agent.name);
                        }).toList()
                        // Pinned first; the cache keeps newest first otherwise.
                        ..sort(
                          (a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0),
                        );
                  final manage = ref
                      .watch(chatRepositoryProvider)
                      .providerInfo
                      .supports(ChatCapability.manageConversations);
                  final user = ref.watch(authControllerProvider).user;
                  // Without this permission the server answers 401, which
                  // would end the session.
                  final canDelete =
                      user?.role == 'admin' ||
                      (user?.allows('chat.delete') ?? false);

                  if (agentHistory.isEmpty) {
                    return EmptyView(
                      title: 'No conversation history',
                      message:
                          'Start your first conversation with ${agent.name} above.',
                      icon: Icons.chat_bubble_outline,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: agentHistory.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final conv = agentHistory[index];
                      final last = conv.lastMessage;
                      // Server chats list without messages: show the date.
                      final preview = last?.content.isNotEmpty == true
                          ? last!.content
                          : MaterialLocalizations.of(context)
                                .formatMediumDate(conv.updatedAt);

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            child: const Icon(Icons.forum_outlined),
                          ),
                          title: Row(
                            children: [
                              if (conv.isPinned) ...[
                                Icon(
                                  Icons.push_pin,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                  semanticLabel: l10n.chatPinned,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                              ],
                              Expanded(
                                child: Text(
                                  conv.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            preview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: manage
                              ? _ConversationMenu(
                                  conversation: conv,
                                  canDelete: canDelete,
                                )
                              : const Icon(Icons.chevron_right),
                          onTap: () =>
                              context.push(AppRoutes.conversation(conv.id)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ConversationAction { rename, pin, delete }

/// Rename, pin/unpin and delete a conversation (on the server too).
class _ConversationMenu extends ConsumerWidget {
  const _ConversationMenu({
    required this.conversation,
    required this.canDelete,
  });

  final Conversation conversation;
  final bool canDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return PopupMenuButton<_ConversationAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => _run(context, ref, action),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _ConversationAction.rename,
          child: ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.chatRename),
          ),
        ),
        PopupMenuItem(
          value: _ConversationAction.pin,
          child: ListTile(
            leading: Icon(
              conversation.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
            ),
            title: Text(conversation.isPinned ? l10n.chatUnpin : l10n.chatPin),
          ),
        ),
        if (canDelete)
          PopupMenuItem(
            value: _ConversationAction.delete,
            child: ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(l10n.chatDelete),
            ),
          ),
      ],
    );
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    _ConversationAction action,
  ) async {
    final l10n = context.l10n;
    final repository = ref.read(chatRepositoryProvider);
    final Result<void> result;
    switch (action) {
      case _ConversationAction.rename:
        final title = await _askTitle(context, conversation.title);
        if (title == null) return;
        result = await repository.renameConversation(conversation.id, title);
      case _ConversationAction.pin:
        result = await repository.setPinned(
          conversation.id,
          pinned: !conversation.isPinned,
        );
      case _ConversationAction.delete:
        final confirmed = await context.showConfirmDialog(
          title: l10n.chatDeleteConfirmTitle,
          message: l10n.chatDeleteConfirmMessage,
          confirmLabel: l10n.chatDelete,
          destructive: true,
        );
        if (!confirmed) return;
        result = await repository.deleteConversation(conversation.id);
    }
    if (!result.isOk && context.mounted) {
      context.showAppSnackBar(l10n.chatActionFailed, type: AppSnackType.error);
    }
  }

  Future<String?> _askTitle(BuildContext context, String current) =>
      showDialog<String>(
        context: context,
        builder: (_) => _RenameDialog(current: current),
      ).then(
        (title) =>
            title == null || title.isEmpty || title == current ? null : title,
      );
}

/// Owns its text controller, so it is disposed only after the dialog's
/// closing animation (disposing it when the dialog pops crashes).
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.current});

  final String current;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  // Selected, so typing replaces the old title.
  late final _controller = TextEditingController(text: widget.current)
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.current.length,
    );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.chatRenameTitle),
      content: AppTextField(
        controller: _controller,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.chatRename)),
      ],
    );
  }
}
