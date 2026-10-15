import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/config/app_config.dart';
import 'package:goai_mobile/features/auth/application/auth_providers.dart';
import 'package:goai_mobile/features/auth/domain/auth_state.dart';
import 'package:goai_mobile/features/auth/presentation/sign_in_page.dart';
import 'package:goai_mobile/shared/widgets/app_text_field.dart';

import '../../helpers/test_helpers.dart';

void main() {
  Widget buildSubject({
    Locale locale = const Locale('vi'),
    List<Override> overrides = const [],
    AppConfig config = testConfig,
  }) {
    return ProviderScope(
      retry: noRetry,
      overrides: [
        ...baseTestOverrides(config: config),
        ...overrides,
      ],
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

      // 1. Header title
      expect(find.text('GO AI HR'), findsOneWidget);

      // 2. BẢO MẬT badge
      expect(find.text('BẢO MẬT'), findsOneWidget);

      // 3. Eyebrow, Title & Subtitle
      expect(find.text('GO AI · HR WORKFORCE'), findsOneWidget);
      expect(find.text('Chào mừng trở lại'), findsOneWidget);
      expect(
        find.text('Vui lòng xác thực tài khoản để xem thông tin của bạn.'),
        findsOneWidget,
      );

      // 4. Input Fields
      expect(find.text('Mã nhân viên hoặc tài khoản công ty'), findsWidgets);
      expect(find.text('Số điện thoại đã đăng ký'), findsWidgets);

      // 5. Primary CTA
      expect(find.text('Gửi mã xác thực'), findsOneWidget);

      // 6. Enterprise SSO
      expect(
        find.text(
          'Công ty có đăng nhập một lần (SSO)? Chọn “Đăng nhập công ty”.',
        ),
        findsOneWidget,
      );
      expect(find.text('Đăng nhập công ty'), findsOneWidget);

      // 7. First-time user informational card
      expect(find.text('Lần đầu sử dụng'), findsOneWidget);
      expect(
        find.text(
          'HR cấp mã kích hoạt. Hãy xác minh số điện thoại rồi đặt mã PIN trên thiết bị.',
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

  testWidgets('tapping SSO button shows coming soon toast', (tester) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đăng nhập công ty'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Tính năng sắp ra mắt'), findsOneWidget);
  });

  testWidgets('submitting empty inputs triggers validation errors', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gửi mã xác thực'));
    await tester.pumpAndSettle();

    expect(
      find.text('Vui lòng nhập mã nhân viên hoặc tài khoản công ty'),
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

      expect(tester.takeException(), isNull);

      // Welcome copy sits left of the verification form.
      final titleX = tester.getCenter(find.text('Chào mừng trở lại')).dx;
      final ctaX = tester.getCenter(find.text('Gửi mã xác thực')).dx;
      expect(titleX, lessThan(640));
      expect(ctaX, greaterThan(640));
      expect(find.text('Lần đầu sử dụng'), findsOneWidget);
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

  testWidgets('portrait tablet (800x1280) keeps a centered capped column', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 2560);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildSubject(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final cta = tester.getRect(find.byType(FilledButton).first);
    expect(cta.width, lessThanOrEqualTo(480));
    expect(cta.center.dx, closeTo(400, 1));
  });

  group('real backend (Open WebUI)', () {
    const realConfig = AppConfig(
      environment: AppEnvironment.staging,
      appName: 'Test App',
      apiBaseUrl: 'https://api.test',
      useFakeNativeAdapters: true,
    );

    testWidgets('asks for email and password instead of phone', (tester) async {
      await tester.pumpWidget(
        buildSubject(locale: const Locale('en'), config: realConfig),
      );
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Registered phone number'), findsNothing);
      expect(find.text('Continue as guest'), findsNothing);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('signs in with the entered credentials', (tester) async {
      await tester.pumpWidget(
        buildSubject(locale: const Locale('en'), config: realConfig),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(AppTextField);
      await tester.enterText(fields.at(0), ' hr@company.test ');
      await tester.enterText(fields.at(1), 'secret1');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(SignInPage)),
      );
      expect(
        container.read(authControllerProvider).user?.email,
        'hr@company.test',
      );
    });

    testWidgets('shows an error when the server rejects the password', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(locale: const Locale('en'), config: realConfig),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(AppTextField);
      await tester.enterText(fields.at(0), 'hr@company.test');
      // The fake backend rejects passwords shorter than 6 characters.
      await tester.enterText(fields.at(1), '123');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
