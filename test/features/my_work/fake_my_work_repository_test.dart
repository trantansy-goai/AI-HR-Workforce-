import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/features/my_work/data/fake_my_work_repository.dart';
import 'package:goai_mobile/features/my_work/domain/my_work_item.dart';

void main() {
  test('submitRequest opens a received case and lists it first', () async {
    final repo = FakeMyWorkRepository();

    final created = await repo.submitRequest(
      const HrRequestDraft(
        type: HrRequestType.leave,
        description: '  Xin nghỉ phép 2 ngày  ',
      ),
    );

    expect(created.id, '#HR-1043');
    expect(created.title, 'Xin nghỉ phép 2 ngày');
    expect(created.currentStep, 1);
    final cases = await repo.getCases();
    expect(cases.first, created);
    expect(cases, hasLength(2));
  });

  test('long descriptions are shortened for the case title', () async {
    final created = await FakeMyWorkRepository().submitRequest(
      HrRequestDraft(type: HrRequestType.policy, description: 'a' * 100),
    );

    expect(created.title.length, 60);
    expect(created.title, endsWith('...'));
  });
}
