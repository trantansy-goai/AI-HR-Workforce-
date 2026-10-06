import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/quota_providers.dart';

class QuotaUsageCard extends ConsumerWidget {
  const QuotaUsageCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotaAsync = ref.watch(userQuotaProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: quotaAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Error loading quota: $err'),
          data: (quota) {
            final color = quota.isExceeded
                ? Colors.red
                : quota.isWarning
                ? Colors.orange
                : Colors.green;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Model Quota',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(
                        quota.periodName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: quota.usagePercentage,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Used: ${quota.usedTokens} / ${quota.limitTokens} tokens',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(quota.usagePercentage * 100).toInt()}%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
