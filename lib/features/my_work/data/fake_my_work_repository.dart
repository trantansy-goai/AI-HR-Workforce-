import '../domain/my_work_item.dart';

class FakeMyWorkRepository implements MyWorkRepository {
  static final _checklistItems = [
    const OnboardingChecklistItem(
      id: 'chk-1',
      title: 'Xác minh hồ sơ cá nhân',
      isCompleted: true,
      owner: 'A3',
    ),
    const OnboardingChecklistItem(
      id: 'chk-2',
      title: 'Nhận lịch làm việc ngày đầu',
      isCompleted: true,
      owner: 'A3',
    ),
    const OnboardingChecklistItem(
      id: 'chk-3',
      title: 'Hoàn thành khóa an toàn',
      isCompleted: false,
      owner: 'A7',
    ),
    const OnboardingChecklistItem(
      id: 'chk-4',
      title: 'Xác nhận thiết bị được bàn giao',
      isCompleted: false,
      owner: 'IT',
    ),
    const OnboardingChecklistItem(
      id: 'chk-5',
      title: 'Đăng ký tuyến xe đưa đón',
      isCompleted: false,
      owner: 'Hành chính',
    ),
  ];

  final _caseItems = <CaseTrackingItem>[
    const CaseTrackingItem(
      id: '#HR-1042',
      title: 'Xác nhận thông tin cá nhân',
      status: 'Đang xử lý',
      updatedDate: '07/10',
      expectedResponseDate: '09/10',
      assignee: 'HR được phân công',
      currentStep: 3,
      totalSteps: 4,
      stepLabel: 'Đang chờ HR xác minh',
    ),
  ];

  @override
  Future<List<OnboardingChecklistItem>> getChecklist() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_checklistItems);
  }

  @override
  Future<List<CaseTrackingItem>> getCases() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_caseItems);
  }

  @override
  Future<CaseTrackingItem> submitRequest(HrRequestDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    String dayMonth(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
    final description = draft.description.trim();
    final created = CaseTrackingItem(
      id: '#HR-${1042 + _caseItems.length}',
      title: description.length > 60
          ? '${description.substring(0, 57)}...'
          : description,
      status: 'Đã nhận',
      updatedDate: dayMonth(now),
      expectedResponseDate: dayMonth(now.add(const Duration(days: 2))),
      assignee: 'HR được phân công',
      currentStep: 1,
      totalSteps: 4,
      stepLabel: 'Đã tiếp nhận yêu cầu',
    );
    _caseItems.insert(0, created);
    return created;
  }
}
