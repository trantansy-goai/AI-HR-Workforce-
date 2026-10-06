import '../domain/approval_item.dart';

class FakeApprovalRepository implements ApprovalRepository {
  static final List<ApprovalItem> _items = [
    ApprovalItem(
      id: 'appr-1',
      title: 'Quota Expansion Request (100k Tokens)',
      requesterName: 'Sarah Connor (Senior Analyst)',
      requestType: 'AI Model Quota',
      status: ApprovalStatus.pending,
      availableActions: const ['approve', 'reject'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      detail: 'Requires additional model quota for running batch market analysis report.',
    ),
    ApprovalItem(
      id: 'appr-2',
      title: 'Knowledge Document Upload Approval',
      requesterName: 'John Doe (DevOps Lead)',
      requestType: 'RAG Document Publishing',
      status: ApprovalStatus.pending,
      availableActions: const ['approve', 'reject'],
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      detail: 'Requesting permission to publish Internal Architecture Guide to vector database.',
    ),
  ];

  @override
  Future<List<ApprovalItem>> getApprovals() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.from(_items);
  }

  @override
  Future<ApprovalItem> getApprovalDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _items.firstWhere(
      (item) => item.id == id,
      orElse: () => _items.first,
    );
  }

  @override
  Future<void> submitAction(String approvalId, String action) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final index = _items.indexWhere((i) => i.id == approvalId);
    if (index != -1) {
      final current = _items[index];
      final newStatus = action == 'approve'
          ? ApprovalStatus.approved
          : ApprovalStatus.rejected;
      _items[index] = ApprovalItem(
        id: current.id,
        title: current.title,
        requesterName: current.requesterName,
        requestType: current.requestType,
        status: newStatus,
        availableActions: const [],
        createdAt: current.createdAt,
        detail: current.detail,
      );
    }
  }
}
