import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fake_my_work_repository.dart';
import '../domain/my_work_item.dart';

final myWorkRepositoryProvider = Provider<MyWorkRepository>((ref) {
  return FakeMyWorkRepository();
});

final onboardingChecklistProvider =
    FutureProvider.autoDispose<List<OnboardingChecklistItem>>((ref) async {
      final repo = ref.watch(myWorkRepositoryProvider);
      return repo.getChecklist();
    });

final caseTrackingListProvider =
    FutureProvider.autoDispose<List<CaseTrackingItem>>((ref) async {
      final repo = ref.watch(myWorkRepositoryProvider);
      return repo.getCases();
    });

/// Role used to pick the Việc tab layout. Defaults to employee; apps wire it
/// to the signed-in user's role (demo builds expose a switcher).
class WorkRoleController extends Notifier<WorkRole> {
  @override
  WorkRole build() => WorkRole.employee;

  void select(WorkRole role) => state = role;
}

final workRoleProvider = NotifierProvider<WorkRoleController, WorkRole>(
  WorkRoleController.new,
);
