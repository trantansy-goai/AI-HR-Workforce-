import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/approval_providers.dart';
import '../domain/approval_item.dart';

class ApprovalListPage extends ConsumerWidget {
  const ApprovalListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvalsAsync = ref.watch(approvalListProvider);
    final actionState = ref.watch(approvalActionControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pending Approvals')),
      body: ResponsiveCenter(
        child: approvalsAsync.when(
          loading: () => const LoadingView(label: 'Loading approvals...'),
          error: (err, stack) => ErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(approvalListProvider),
          ),
          data: (approvals) {
            if (approvals.isEmpty) {
              return const EmptyView(
                title: 'No Pending Approvals',
                message: 'You have zero pending requests waiting for approval.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: approvals.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = approvals[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Chip(
                                label: Text(
                                  item.requestType,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.status.name.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: item.status == ApprovalStatus.pending
                                    ? Colors.orange
                                    : item.status == ApprovalStatus.approved
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('Requester: ${item.requesterName}'),
                        const SizedBox(height: 4),
                        Text(item.detail),
                        const SizedBox(height: 16),
                        if (item.status == ApprovalStatus.pending)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: actionState.isSubmitting
                                    ? null
                                    : () {
                                        ref
                                            .read(
                                              approvalActionControllerProvider
                                                  .notifier,
                                            )
                                            .submit(item.id, 'reject');
                                      },
                                child: const Text('Reject'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: actionState.isSubmitting
                                    ? null
                                    : () {
                                        ref
                                            .read(
                                              approvalActionControllerProvider
                                                  .notifier,
                                            )
                                            .submit(item.id, 'approve');
                                      },
                                child: const Text('Approve'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
