import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/fake_approval_repository.dart';
import '../data/noop_approval_repository.dart';
import '../domain/approval_item.dart';

final approvalRepositoryProvider = Provider<ApprovalRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeApprovalRepository();
  }
  return const NoopApprovalRepository();
});

final approvalListProvider = FutureProvider.autoDispose<List<ApprovalItem>>((
  ref,
) async {
  final repo = ref.watch(approvalRepositoryProvider);
  return repo.getApprovals();
});

/// Permission-aware check for Manager/HR approval actions.
/// Overridable in ProviderScope for testing permission-gated UI.
final hasApprovalPermissionProvider = Provider<bool>((ref) {
  return true;
});

class ApprovalActionState {
  const ApprovalActionState({this.isSubmitting = false, this.error});
  final bool isSubmitting;
  final String? error;
}

class ApprovalActionController extends Notifier<ApprovalActionState> {
  @override
  ApprovalActionState build() => const ApprovalActionState();

  Future<bool> submit(String approvalId, String action) async {
    if (state.isSubmitting) return false;
    state = const ApprovalActionState(isSubmitting: true);
    try {
      final repo = ref.read(approvalRepositoryProvider);
      await repo.submitAction(approvalId, action);
      state = const ApprovalActionState();
      ref.invalidate(approvalListProvider);
      return true;
    } catch (e) {
      state = ApprovalActionState(error: e.toString());
      return false;
    }
  }
}

final approvalActionControllerProvider =
    NotifierProvider.autoDispose<ApprovalActionController, ApprovalActionState>(
      () {
        return ApprovalActionController();
      },
    );
