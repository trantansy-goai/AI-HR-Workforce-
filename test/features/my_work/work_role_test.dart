import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/features/auth/domain/auth_user.dart';
import 'package:goai_mobile/features/my_work/application/my_work_providers.dart';
import 'package:goai_mobile/features/my_work/domain/my_work_item.dart';

void main() {
  const employees = {'Nhân viên'};

  WorkRole roleOf(AuthUser? user) =>
      workRoleOf(user, employeeGroups: employees);

  test('employees are users only in employee groups, or in none', () {
    expect(roleOf(null), WorkRole.employee);
    expect(roleOf(const AuthUser(id: 'u')), WorkRole.employee);
    expect(
      roleOf(const AuthUser(id: 'u', groups: {'nhân viên '})),
      WorkRole.employee,
    );
  });

  test('any other group, or the admin role, means HR', () {
    expect(
      roleOf(const AuthUser(id: 'u', groups: {'Nhân viên', 'HR'})),
      WorkRole.hrAdmin,
    );
    expect(roleOf(const AuthUser(id: 'u', role: 'admin')), WorkRole.hrAdmin);
  });
}
