import 'package:equatable/equatable.dart';

enum ApprovalStatus { pending, approved, rejected }

class ApprovalItem extends Equatable {
  const ApprovalItem({
    required this.id,
    required this.title,
    required this.requesterName,
    required this.requestType,
    required this.status,
    required this.availableActions, // e.g. ['approve', 'reject']
    required this.createdAt,
    required this.detail,
  });

  final String id;
  final String title;
  final String requesterName;
  final String requestType;
  final ApprovalStatus status;
  final List<String> availableActions;
  final DateTime createdAt;
  final String detail;

  @override
  List<Object?> get props => [
    id,
    title,
    requesterName,
    requestType,
    status,
    availableActions,
    createdAt,
    detail,
  ];
}

abstract interface class ApprovalRepository {
  Future<List<ApprovalItem>> getApprovals();
  Future<ApprovalItem> getApprovalDetail(String id);
  Future<void> submitAction(String approvalId, String action);
}
