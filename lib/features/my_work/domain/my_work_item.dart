import 'package:equatable/equatable.dart';

class OnboardingChecklistItem extends Equatable {
  const OnboardingChecklistItem({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.owner = 'A3',
  });

  final String id;
  final String title;
  final bool isCompleted;
  final String owner;

  @override
  List<Object?> get props => [id, title, isCompleted, owner];
}

class CaseTrackingItem extends Equatable {
  const CaseTrackingItem({
    required this.id,
    required this.title,
    required this.status,
    required this.updatedDate,
    required this.expectedResponseDate,
    required this.assignee,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabel,
  });

  final String id;
  final String title;
  final String status;
  final String updatedDate;
  final String expectedResponseDate;
  final String assignee;
  final int currentStep;
  final int totalSteps;
  final String stepLabel;

  @override
  List<Object?> get props => [
    id,
    title,
    status,
    updatedDate,
    expectedResponseDate,
    assignee,
    currentStep,
    totalSteps,
    stepLabel,
  ];
}

/// Which Việc tab the user sees: their own work, or the HR/Admin desk
/// (approvals, probation reviews, coordination queue).
enum WorkRole { employee, hrAdmin }

/// Kinds of HR request an employee can open from the Việc tab.
enum HrRequestType { personalInfo, leave, policy, complaint }

/// Minimal request an employee submits; HR turns it into a case.
class HrRequestDraft extends Equatable {
  const HrRequestDraft({
    required this.type,
    required this.description,
    this.attachmentNames = const [],
  });

  final HrRequestType type;
  final String description;
  final List<String> attachmentNames;

  @override
  List<Object?> get props => [type, description, attachmentNames];
}

abstract interface class MyWorkRepository {
  Future<List<OnboardingChecklistItem>> getChecklist();

  /// Newest case first.
  Future<List<CaseTrackingItem>> getCases();

  /// Opens a case for [draft] and returns it (step 1, "received").
  Future<CaseTrackingItem> submitRequest(HrRequestDraft draft);
}
