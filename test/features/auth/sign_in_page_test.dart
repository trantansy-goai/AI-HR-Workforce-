import 'package:flutter/material.dart';
import 'package:flutter_project_base/features/auth/application/auth_providers.dart';
import 'package:flutter_project_base/features/auth/domain/auth_state.dart';
import 'package:flutter_project_base/features/auth/presentation/sign_in_page.dart';
import 'package:flutter_project_base/shared/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helpers.dart';

void main() {
  Widget buildSubject({
    Locale locale = const Locale('vi'),
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      retry: noRetry,
      overrides: [...baseTestOverrides(), ...overrides],
      child: testApp(const SignInPage(), locale: locale),
    );
  }

  testWidgets(
    'renders all approved components and GoAI branding in Vietnamese',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400); // 360 x 800 @ 3x
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
      await tester.pumpAndSettle();

      // 1. Official GoAI logo renders
      final logoFinder = find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName == 'assets/images/goai_logo.png',
      );
      expect(logoFinder, findsOneWidget);

      // 2. BẢO MẬT badge
      expect(find.text('BẢO MẬT'), findsOneWidget);

      // 3. Eyebrow, Title & Subtitle
      expect(find.text('GO AI · HR WORKFORCE'), findsOneWidget);
      expect(find.text('Chào mừng trở lại'), findsOneWidget);
      expect(
        find.text('Vui lòng xác nhận tài khoản để xem thông tin của mình.'),
        findsOneWidget,
      );

      // 4. Input Fields
      expect(find.text('Mã nhân viên hoặc tài khoản công ty'), findsWidgets);
      expect(find.text('Số điện thoại đã đăng ký'), findsWidgets);

      // 5. Primary CTA
      expect(find.text('Gửi mã xác thực'), findsOneWidget);

      // 6. Enterprise SSO
      expect(find.text('Doanh nghiệp có SSO?'), findsOneWidget);
      expect(find.text('Đăng nhập công ty'), findsOneWidget);

      // 7. First-time user informational card
      expect(find.text('Lần đầu sử dụng'), findsOneWidget);
      expect(
        find.text(
          'HR cấp mã kích hoạt; xác minh số điện thoại rồi đặt PIN trên thiết bị.',
        ),
        findsOneWidget,
      );

      // 8. Security / shared-device notice
      expect(
        find.text('Dùng chung điện thoại? Đăng xuất hoàn toàn sau mỗi phiên.'),
        findsOneWidget,
      );

      // 9. Demo shortcut in fake backend mode
      expect(find.text('Tiếp tục với tư cách khách'), findsOneWidget);
    },
  );

  testWidgets('renders properly in English locale', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildSubject(locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('SECURITY'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(
      find.text('Please verify your account to view your information.'),
      findsOneWidget,
    );
    expect(find.text('Employee ID or company account'), findsWidgets);
    expect(find.text('Registered phone number'), findsWidgets);
    expect(find.text('Send verification code'), findsOneWidget);
    expect(find.text('Company sign-in'), findsOneWidget);
  });

  testWidgets('tapping BẢO MẬT opens security dialog', (tester) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('BẢO MẬT'));
    await tester.pumpAndSettle();

    expect(find.text('Bảo mật doanh nghiệp'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('tapping SSO button shows blocked feedback', (tester) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đăng nhập công ty'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('BLOCKED'), findsOneWidget);
  });

  testWidgets('submitting empty inputs triggers validation errors', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gửi mã xác thực'));
    await tester.pumpAndSettle();

    expect(
      find.text('Vui lòng nhập mã nhân viên hoặc tài khoản'),
      findsOneWidget,
    );
    expect(find.text('Vui lòng nhập số điện thoại đã đăng ký'), findsOneWidget);
  });

  testWidgets('submitting valid credentials establishes session in demo mode', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    final textFields = find.byType(AppTextField);
    await tester.enterText(textFields.at(0), 'NV1042');
    await tester.enterText(textFields.at(1), '0901234567');
    await tester.pump();

    await tester.tap(find.text('Gửi mã xác thực'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SignInPage)),
    );
    final authState = container.read(authControllerProvider);
    expect(authState, isA<Authenticated>());
    expect(authState.user?.email, 'NV1042@goai.vn');
  });

  testWidgets('guest sign-in shortcut works in demo mode', (tester) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tiếp tục với tư cách khách'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SignInPage)),
    );
    final authState = container.read(authControllerProvider);
    expect(authState, isA<Authenticated>());
    expect(authState.session?.isGuest, isTrue);
  });

  testWidgets(
    'renders cleanly on tablet landscape (wide screen >=840dp) with two-pane composition',
    (tester) async {
      tester.view.physicalSize = const Size(2560, 1600); // 1280 x 800 @ 2x
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
      await tester.pumpAndSettle();

      // In wide tablet layout, left branding panel appears
      expect(
        find.text('Nền tảng Trợ lý AI & Không gian làm việc Nhân sự'),
        findsOneWidget,
      );
      expect(find.text('Tiêu chuẩn bảo mật doanh nghiệp'), findsOneWidget);

      // Right login form remains active
      expect(find.text('Gửi mã xác thực'), findsOneWidget);
    },
  );

  testWidgets('scroll-safe on compact phone (360x800) without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400); // 360 x 800 @ 3x
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
