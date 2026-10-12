import '../../../core/error/app_failure.dart';
import '../domain/approval_item.dart';

/// Used against the real backend until an approval API exists: no requests,
/// so the screen shows its empty state instead of an error.
class NoopApprovalRepository implements ApprovalRepository {
  const NoopApprovalRepository();

  @override
  Future<List<ApprovalItem>> getApprovals() async => const [];

  @override
  Future<ApprovalItem> getApprovalDetail(String id) async =>
      throw NotFoundFailure('Approval $id not found');

  @override
  Future<void> submitAction(String approvalId, String action) async =>
      throw NotFoundFailure('Approval $approvalId not found');
}
