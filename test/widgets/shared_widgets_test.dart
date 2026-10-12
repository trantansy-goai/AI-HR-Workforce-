import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/shared/widgets/app_button.dart';
import 'package:goai_mobile/shared/widgets/app_feedback.dart';
import 'package:goai_mobile/shared/widgets/app_text_field.dart';
import 'package:goai_mobile/shared/widgets/hr_top_bar.dart';
import 'package:goai_mobile/shared/widgets/state_views.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AppButton', () {
    testWidgets('calls onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        testApp(AppButton(label: 'Go', onPressed: () => taps++)),
      );
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });

    testWidgets('loading state shows spinner and blocks taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        testApp(
          AppButton(label: 'Go', onPressed: () => taps++, isLoading: true),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Go'), findsNothing);
      await tester.tap(find.byType(FilledButton));
      expect(taps, 0);
    });

    testWidgets('tonal variant renders a tappable filled button', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        testApp(
          AppButton(
            label: 'Go',
            variant: AppButtonVariant.tonal,
            onPressed: () => taps++,
          ),
        ),
      );
      expect(find.byType(FilledButton), findsOneWidget);
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });
  });

  testWidgets('HrTopBar shows title and back button only when wired', (
    tester,
  ) async {
    var backs = 0;
    await tester.pumpWidget(
      testApp(const Column(children: [HrTopBar(title: 'GO AI · HR')])),
    );
    expect(find.text('GO AI · HR'), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);

    await tester.pumpWidget(
      testApp(
        Column(
          children: [HrTopBar(title: 'GO AI · HR', onBack: () => backs++)],
        ),
      ),
    );
    await tester.tap(find.byType(BackButton));
    expect(backs, 1);
  });

  testWidgets('showConfirmDialog ignores taps outside; Cancel returns false', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async =>
                result = await context.showConfirmDialog(title: 'Sure?'),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('Sure?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Sure?'), findsNothing);
    expect(result, isFalse);
  });

  testWidgets('AppTextField toggles password visibility', (tester) async {
    await tester.pumpWidget(
      testApp(const AppTextField(label: 'Pw', obscure: true)),
    );
    TextField field() => tester.widget<TextField>(find.byType(TextField));
    expect(field().obscureText, isTrue);
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    expect(field().obscureText, isFalse);
  });

  group('state views', () {
    testWidgets('LoadingView shows label', (tester) async {
      await tester.pumpWidget(testApp(const LoadingView(label: 'Wait')));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Wait'), findsOneWidget);
    });

    testWidgets('EmptyView uses localized default title', (tester) async {
      await tester.pumpWidget(testApp(const EmptyView()));
      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('ErrorView localizes failure and retries', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        testApp(
          ErrorView(
            failure: const NetworkFailure(),
            onRetry: () => retried = true,
          ),
        ),
      );
      expect(find.textContaining('No internet connection'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });

    testWidgets('ErrorView never shows a raw exception', (tester) async {
      await tester.pumpWidget(
        testApp(ErrorView(error: UnimplementedError('stack trace here'))),
      );
      expect(find.text('An unexpected error occurred.'), findsOneWidget);
      expect(find.textContaining('stack trace here'), findsNothing);
    });

    testWidgets('ErrorView is translated to Vietnamese', (tester) async {
      await tester.pumpWidget(
        testApp(
          const ErrorView(failure: ServerFailure()),
          locale: const Locale('vi'),
        ),
      );
      expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
    });
  });
}
