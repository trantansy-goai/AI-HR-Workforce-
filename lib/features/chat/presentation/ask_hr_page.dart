import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/shared_workspace_header.dart';
import '../application/chat_providers.dart';
import '../domain/entities/agent_item.dart';
import '../domain/entities/conversation.dart';

import 'conversation_page.dart';

/// Tab 2: Hỏi HR (Ask HR / Enterprise AI Assistant discovery)
/// Allows employees to select an HR/AI assistant, review past conversations,
/// or start a new inquiry. On wide tablets, provides a master-detail split layout.
class AskHrPage extends ConsumerStatefulWidget {
  const AskHrPage({super.key});

  @override
  ConsumerState<AskHrPage> createState() => _AskHrPageState();
}

class _AskHrPageState extends ConsumerState<AskHrPage> {
  String? _selectedConversationId;
  String? _selectedAgentId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final agents = ref.watch(agentsProvider);
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideTablet =
                constraints.maxWidth >= ResponsiveBreakpoints.wideTablet;

            if (isWideTablet) {
              return Row(
                children: [
                  // Master Pane: Agent discovery & history
                  SizedBox(
                    width: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SharedWorkspaceHeader(),
                        Expanded(
                          child: _buildDiscoveryList(
                            context,
                            ref,
                            theme,
                            l10n,
                            agents,
                            conversationsAsync,
                            isMasterDetail: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  // Detail Pane: Active conversation or empty state
                  Expanded(
                    child: _selectedConversationId != null
                        ? ConversationPage(
                            key: ValueKey(_selectedConversationId),
                            conversationId: _selectedConversationId!,
                          )
                        : _buildEmptyDetailState(theme, l10n),
                  ),
                ],
              );
            }

            // Compact / phone / medium portrait layout
            return ResponsiveCenter(
              maxWidth: ContentConstraints.reading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SharedWorkspaceHeader(),
                  Expanded(
                    child: _buildDiscoveryList(
                      context,
                      ref,
                      theme,
                      l10n,
                      agents,
                      conversationsAsync,
                      isMasterDetail: false,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyDetailState(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Chọn trợ lý AI để bắt đầu',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Trao đổi chính sách nhân sự, biểu mẫu, quy trình công việc',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Bắt đầu với HR Assistant'),
              onPressed: () {
                setState(() {
                  _selectedAgentId = 'hr-assistant';
                  _selectedConversationId =
                      'agent-hr-assistant-${DateTime.now().millisecondsSinceEpoch}';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryList(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AppLocalizations l10n,
    List<AgentItem> agents,
    AsyncValue<List<Conversation>> conversationsAsync, {
    required bool isMasterDetail,
  }) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Search prompt banner
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn cần HR hỗ trợ gì?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.askHrSearchPrompt,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    ActionChip(
                      label: Text(l10n.askHrPolicyChip),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        if (isMasterDetail) {
                          setState(() {
                            _selectedAgentId = 'hr-assistant';
                            _selectedConversationId =
                                'agent-hr-assistant-${DateTime.now().millisecondsSinceEpoch}';
                          });
                        } else {
                          context.push(AppRoutes.agentHistory('hr-assistant'));
                        }
                      },
                    ),
                    ActionChip(
                      label: Text(l10n.askHrFormChip),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        if (isMasterDetail) {
                          setState(() {
                            _selectedAgentId = 'hr-assistant';
                            _selectedConversationId =
                                'agent-hr-assistant-${DateTime.now().millisecondsSinceEpoch}';
                          });
                        } else {
                          context.push(AppRoutes.agentHistory('hr-assistant'));
                        }
                      },
                    ),
                    ActionChip(
                      label: Text(l10n.askHrMyRequestsChip),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => context.go(AppRoutes.myWork),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // AI AGENTS
        Text(
          l10n.chatAiAgents,
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 1.1,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        for (final agent in agents)
          Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isMasterDetail && _selectedAgentId == agent.id
                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            color: isMasterDetail && _selectedAgentId == agent.id
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
                : null,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (isMasterDetail) {
                  setState(() {
                    _selectedAgentId = agent.id;
                    _selectedConversationId =
                        'agent-${agent.id}-${DateTime.now().millisecondsSinceEpoch}';
                  });
                } else {
                  context.push(AppRoutes.agentHistory(agent.id));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: Icon(_agentIcon(agent.id)),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agent.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            agent.description,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: AppSpacing.lg),

        // OTHER (human chat placeholder)
        Row(
          children: [
            Text(
              l10n.chatOther,
              style: theme.textTheme.labelLarge?.copyWith(
                letterSpacing: 1.1,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Chip(
              label: const Text('BLOCKED'),
              visualDensity: VisualDensity.compact,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.chatHumanBlockedHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  IconData _agentIcon(String id) => switch (id) {
    'hr-assistant' => Icons.badge_outlined,
    'legal-assistant' => Icons.gavel_outlined,
    _ => Icons.smart_toy_outlined,
  };
}
