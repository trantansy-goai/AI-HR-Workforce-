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

  static final _caseItems = [
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
}
