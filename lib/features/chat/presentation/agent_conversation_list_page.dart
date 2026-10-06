import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/chat_providers.dart';
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
    final agents = ref.watch(agentsProvider);
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
                      final newId =
                          'agent-$agentId-${DateTime.now().millisecondsSinceEpoch}';
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
                  final agentHistory = items.where((c) {
                    if (c.kind != ConversationKind.assistant) return false;
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
                  }).toList();

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
                      final preview = last?.content.isNotEmpty == true
                          ? last!.content
                          : 'No messages yet';

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            child: const Icon(Icons.forum_outlined),
                          ),
                          title: Text(
                            conv.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            preview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right),
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
