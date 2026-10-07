import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/shared_workspace_header.dart';
import '../application/chat_providers.dart';

/// Tab 2: Hỏi HR (Ask HR / Enterprise AI Assistant discovery)
/// Allows employees to select an HR/AI assistant, review past conversations,
/// or start a new inquiry.
class AskHrPage extends ConsumerWidget {
  const AskHrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final agents = ref.watch(agentsProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SharedWorkspaceHeader(),
              Expanded(
                child: ListView(
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
                                color: theme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant,
                                ),
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
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
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
                              children: [
                                ActionChip(
                                  label: Text(l10n.askHrPolicyChip),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    // Default to HR Assistant
                                    context.push(
                                      AppRoutes.agentHistory('hr-assistant'),
                                    );
                                  },
                                ),
                                ActionChip(
                                  label: Text(l10n.askHrFormChip),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    context.push(
                                      AppRoutes.agentHistory('hr-assistant'),
                                    );
                                  },
                                ),
                                ActionChip(
                                  label: Text(l10n.askHrMyRequestsChip),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    context.go(AppRoutes.myWork);
                                  },
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () =>
                              context.push(AppRoutes.agentHistory(agent.id)),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  foregroundColor:
                                      theme.colorScheme.onPrimaryContainer,
                                  child: Icon(_agentIcon(agent.id)),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _agentIcon(String id) => switch (id) {
    'hr-assistant' => Icons.badge_outlined,
    'legal-assistant' => Icons.gavel_outlined,
    _ => Icons.smart_toy_outlined,
  };
}
