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

abstract interface class MyWorkRepository {
  Future<List<OnboardingChecklistItem>> getChecklist();
  Future<List<CaseTrackingItem>> getCases();
}
