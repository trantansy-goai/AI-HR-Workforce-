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
