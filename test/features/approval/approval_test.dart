import 'package:flutter_project_base/features/approval/data/fake_approval_repository.dart';
import 'package:flutter_project_base/features/approval/domain/approval_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeApprovalRepository', () {
    late FakeApprovalRepository repo;

    setUp(() {
      repo = FakeApprovalRepository();
    });

    test('fetches pending approvals', () async {
      final approvals = await repo.getApprovals();
      expect(approvals.length, greaterThanOrEqualTo(2));
      expect(approvals.first.status, equals(ApprovalStatus.pending));
    });

    test('submits approve action', () async {
      await repo.submitAction('appr-1', 'approve');
      final detail = await repo.getApprovalDetail('appr-1');
      expect(detail.status, equals(ApprovalStatus.approved));
      expect(detail.availableActions, isEmpty);
    });

    test('submits reject action', () async {
      await repo.submitAction('appr-2', 'reject');
      final detail = await repo.getApprovalDetail('appr-2');
      expect(detail.status, equals(ApprovalStatus.rejected));
    });
  });
}
