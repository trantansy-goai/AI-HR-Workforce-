import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../../../core/error/failure_messages.dart';
import '../../../core/error/result.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/hr_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../application/auth_providers.dart';

const _boxRadius = hrBoxRadius;

/// GO AI HR sign-in & activation entry screen (M01 · A0).
///
/// Phones get the single-column mockup; portrait tablets keep the same column
/// centered at a readable width; landscape tablets split the welcome copy and
/// guidance (left) from the verification form (right).
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _submitting = false;
  bool _guestSubmitting = false;

  bool get _busy => _submitting || _guestSubmitting;

  @override
  void dispose() {
    _accountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _run(
    Future<Result<void>> Function() action,
    void Function(bool) setBusy,
  ) async {
    setState(() => setBusy(true));
    final result = await action();
    if (!mounted) return;
    setState(() => setBusy(false));
    if (result case Err(:final failure)) {
      context.showAppSnackBar(
        failure.localizedMessage(context.l10n),
        type: AppSnackType.error,
      );
    }
  }

  void _submitVerificationCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final account = _accountController.text.trim();
    final isFake = ref.read(appConfigProvider).useFakeBackend;

    if (isFake) {
      // In development / demo mode, map entered account to demo session
      final email = account.contains('@') ? account : '$account@goai.vn';
      _run(
        () => ref
            .read(authControllerProvider.notifier)
            .signInWithEmail(email, 'demo123456'),
        (v) => _submitting = v,
      );
    } else {
      context.showComingSoon();
    }
  }

  void _guest() => _run(
    () => ref.read(authControllerProvider.notifier).continueAsGuest(),
    (v) => _guestSubmitting = v,
  );

  void _handleSso() => context.showComingSoon();

  void _showSecurityInfo() {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.shield_outlined,
          color: AppHrPalette.accent,
          size: 32,
        ),
        title: Text(l10n.authSecurityDialogTitle),
        content: Text(l10n.authSecurityDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: hrScopedTheme(Theme.of(context)),
      child: Scaffold(
        backgroundColor: AppHrPalette.background,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isTablet = width >= ResponsiveBreakpoints.tablet;
              return Column(
                children: [
                  _buildHeader(isTablet: isTablet),
                  Expanded(
                    child: width >= ResponsiveBreakpoints.wideTablet
                        ? _buildWideLayout()
                        : _buildSingleColumnLayout(isTablet: isTablet),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Top bar: "GO AI HR" (left) and the "BẢO MẬT" action (right).
  Widget _buildHeader({required bool isTablet}) {
    final l10n = context.l10n;

    return Container(
      height: isTablet ? 64 : 56,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? AppSpacing.xl : AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppHrPalette.surface,
        border: Border(bottom: BorderSide(color: AppHrPalette.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                l10n.authHeaderTitle,
                style: TextStyle(
                  color: AppHrPalette.ink,
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _showSecurityInfo,
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 40),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
            child: Text(l10n.authSecurityBadge),
          ),
        ],
      ),
    );
  }

  /// Phone (<600dp) and portrait tablet (600–840dp): the mockup's single
  /// column, capped at a readable width on tablets.
  Widget _buildSingleColumnLayout({required bool isTablet}) {
    final gutter = isTablet ? AppSpacing.xl : AppSpacing.lg;
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        gutter,
        isTablet ? AppSpacing.xxxl : AppSpacing.xl,
        gutter,
        AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ..._buildIntro(),
                const SizedBox(height: AppSpacing.lg),
                ..._buildFormFields(),
                const SizedBox(height: AppSpacing.md),
                ..._buildGuidance(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Landscape tablet (>=840dp): welcome copy and guidance on the left,
  /// verification form in a card on the right.
  Widget _buildWideLayout() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.xxl,
        AppSpacing.xxl,
        AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._buildIntro(large: true),
                      const SizedBox(height: AppSpacing.xl),
                      ..._buildGuidance(),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xxl),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppHrPalette.surface,
                      borderRadius: AppRadius.lgAll,
                      border: Border.all(color: AppHrPalette.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildFormFields(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Eyebrow, title and subtitle.
  List<Widget> _buildIntro({bool large = false}) {
    final l10n = context.l10n;
    return [
      Text(
        l10n.authBrandEyebrow,
        style: TextStyle(
          color: AppHrPalette.accent,
          fontSize: large ? 14 : 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        l10n.authSignInTitle,
        style: TextStyle(
          color: AppHrPalette.ink,
          fontSize: large ? 32 : 26,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Text(
        l10n.authSignInSubtitle,
        style: TextStyle(
          color: AppHrPalette.inkMuted,
          fontSize: large ? 15 : 14,
          height: 1.45,
        ),
      ),
    ];
  }

  /// Account + phone inputs, primary CTA and the enterprise SSO entry.
  List<Widget> _buildFormFields() {
    final l10n = context.l10n;
    final isFake = ref.watch(appConfigProvider).useFakeBackend;

    return [
      AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _accountController,
              hint: l10n.authEmployeeAccountLabel,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              enabled: !_busy,
              validator: (v) => (v?.trim().isNotEmpty ?? false)
                  ? null
                  : l10n.authAccountRequired,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _phoneController,
              hint: l10n.authPhoneNumberLabel,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              enabled: !_busy,
              onSubmitted: (_) => _submitVerificationCode(),
              validator: (v) => (v?.trim().isNotEmpty ?? false)
                  ? null
                  : l10n.authPhoneRequired,
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      AppButton(
        label: l10n.authSendVerificationCode,
        onPressed: _busy ? null : _submitVerificationCode,
        isLoading: _submitting,
        expand: true,
      ),
      const SizedBox(height: AppSpacing.md),
      _NoticeBox(
        background: AppHrPalette.accentSoft,
        child: Text(
          l10n.authSsoPrompt,
          style: const TextStyle(
            color: AppHrPalette.ink,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      AppButton(
        label: l10n.authSsoButton,
        variant: AppButtonVariant.tonal,
        onPressed: _busy ? null : _handleSso,
        expand: true,
      ),
      // Demo shortcut, only when running against the fake backend.
      if (isFake) ...[
        const SizedBox(height: AppSpacing.xs),
        AppButton(
          label: l10n.authContinueAsGuest,
          variant: AppButtonVariant.text,
          onPressed: _busy ? null : _guest,
          isLoading: _guestSubmitting,
          expand: true,
        ),
      ],
    ];
  }

  /// First-time card and shared-device notice.
  List<Widget> _buildGuidance() {
    final l10n = context.l10n;
    return [
      Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppHrPalette.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: AppHrPalette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.authFirstTimeTitle,
              style: const TextStyle(
                color: AppHrPalette.ink,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.authFirstTimeBody,
              style: const TextStyle(
                color: AppHrPalette.inkMuted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      _NoticeBox(
        background: AppHrPalette.warningSoft,
        borderColor: AppHrPalette.warningBorder,
        child: Text(
          l10n.authSharedDeviceNotice,
          style: const TextStyle(
            color: AppHrPalette.warningInk,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ),
    ];
  }
}

/// Rounded tinted box used for the SSO hint and the shared-device warning.
class _NoticeBox extends StatelessWidget {
  const _NoticeBox({
    required this.background,
    required this.child,
    this.borderColor,
  });

  final Color background;
  final Color? borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: _boxRadius,
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: child,
    );
  }
}
