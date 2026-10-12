import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/auth_user.dart';
import '../data/fake_my_work_repository.dart';
import '../data/open_webui_schedule_repository.dart';
import '../domain/my_work_item.dart';
import '../domain/scheduled_item.dart';

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

/// Role used to pick the HR or employee layout of the Việc and Hỏi HR tabs.
/// With a real backend it follows the signed-in user ([workRoleOf]); demo
/// builds start as employee and expose a switcher.
class WorkRoleController extends Notifier<WorkRole> {
  @override
  WorkRole build() {
    final config = ref.watch(appConfigProvider);
    if (config.useFakeBackend) return WorkRole.employee;
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    return workRoleOf(user, employeeGroups: config.employeeGroups);
  }

  void select(WorkRole role) => state = role;
}

final workRoleProvider = NotifierProvider<WorkRoleController, WorkRole>(
  WorkRoleController.new,
);

/// Admins and members of any group outside [employeeGroups] (names compared
/// case-insensitively) work as HR; everyone else, including users without
/// groups, as employees.
WorkRole workRoleOf(AuthUser? user, {required Set<String> employeeGroups}) {
  if (user == null) return WorkRole.employee;
  if (user.role == 'admin') return WorkRole.hrAdmin;
  final employee = {for (final g in employeeGroups) g.trim().toLowerCase()};
  final isHr = (user.groups ?? const <String>{}).any(
    (group) => !employee.contains(group.trim().toLowerCase()),
  );
  return isHr ? WorkRole.hrAdmin : WorkRole.employee;
}

/// The user's calendar (Open WebUI). Null with the fake backend, and when
/// the server does not let the user use calendars.
final scheduleRepositoryProvider = Provider<ScheduleRepository?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) return null;
  final user = ref.watch(authControllerProvider.select((s) => s.user));
  if (user == null ||
      (user.role != 'admin' && !user.allows('features.calendar'))) {
    return null;
  }
  return OpenWebUiScheduleRepository(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: config.openWebUiBaseUrl,
  );
});

/// Calendar items of the next 30 days, soonest first; null when there is no
/// calendar (demo builds keep their sample texts).
final upcomingScheduleProvider =
    FutureProvider.autoDispose<List<ScheduledItem>?>((ref) async {
      final repository = ref.watch(scheduleRepositoryProvider);
      if (repository == null) return null;
      final now = DateTime.now();
      return repository.between(now, now.add(const Duration(days: 30)));
    });
