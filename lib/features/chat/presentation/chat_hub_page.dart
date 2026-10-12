import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/hr_theme.dart';
import '../../../shared/widgets/hr_top_bar.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/chat_providers.dart';
import '../domain/entities/agent_item.dart';
import '../domain/entities/conversation.dart';

import 'conversation_page.dart';

/// Chat list (AI/HR assistant discovery + history), parked under the Account
/// tab while the Hỏi HR tab follows the M03 mockup. Lets employees pick an
/// assistant, review past conversations or start a new one. On wide tablets,
/// provides a master-detail split layout.
class ChatHubPage extends ConsumerStatefulWidget {
  const ChatHubPage({this.asTab = false, super.key});

  /// Shown as the Hỏi HR tab (HR users): workspace top bar instead of a
  /// back-navigable app bar.
  final bool asTab;

  @override
  ConsumerState<ChatHubPage> createState() => _ChatHubPageState();
}

class _ChatHubPageState extends ConsumerState<ChatHubPage> {
  String? _selectedConversationId;
  String? _selectedAgentId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final agents = ref.watch(agentsProvider);
    final conversationsAsync = ref.watch(conversationsProvider);

    final body = SafeArea(
      top: false,
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
            child: _buildDiscoveryList(
              context,
              ref,
              theme,
              l10n,
              agents,
              conversationsAsync,
              isMasterDetail: false,
            ),
          );
        },
      ),
    );

    if (!widget.asTab) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.chatHubTitle)),
        body: body,
      );
    }
    return Theme(
      data: hrScopedTheme(theme),
      child: Scaffold(
        backgroundColor: AppHrPalette.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HrTopBar(
                title: l10n.homeAppBarTitle,
                actions: const [HrNotificationButton()],
              ),
              Expanded(child: body),
            ],
          ),
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
                  _selectedConversationId = AgentItem.newConversationId(
                    AgentItem.hrAssistantId,
                  );
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
    AsyncValue<List<AgentItem>> agents,
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
                                AgentItem.newConversationId(
                                  AgentItem.hrAssistantId,
                                );
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
                                AgentItem.newConversationId(
                                  AgentItem.hrAssistantId,
                                );
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

        if (agents case AsyncError(:final error) when !agents.hasValue)
          ErrorView(
            failure: error is AppFailure ? error : null,
            onRetry: () => ref.invalidate(agentsProvider),
          )
        else if (!agents.hasValue)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
        for (final agent in agents.value ?? const <AgentItem>[])
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
                    _selectedConversationId = AgentItem.newConversationId(
                      agent.id,
                    );
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
              backgroundColor: AppHrPalette.divider,
              labelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppHrPalette.inkMuted,
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
