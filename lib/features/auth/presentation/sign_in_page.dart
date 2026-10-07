import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../../../core/error/failure_messages.dart';
import '../../../core/error/result.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/responsive.dart';
import '../application/auth_providers.dart';

/// Redesigned GO AI HR Workforce authentication entry screen.
/// Adheres to approved information hierarchy, GoAI visual branding, and
/// responsive requirements for phones and tablets.
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
      context.showAppSnackBar(
        context.l10n.authSendVerificationCode,
        type: AppSnackType.info,
      );
    }
  }

  void _guest() => _run(
    () => ref.read(authControllerProvider.notifier).continueAsGuest(),
    (v) => _guestSubmitting = v,
  );

  void _handleSso(BuildContext context) {
    context.showAppSnackBar(
      context.l10n.authSsoBlockedMessage,
      type: AppSnackType.info,
    );
  }

  void _showSecurityInfo(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.shield_outlined,
          color: AppBrandColors.primaryBlue,
          size: 32,
        ),
        title: Text(l10n.authSecurityDialogTitle),
        content: Text(
          l10n.authSecurityDialogMessage,
          style: theme.textTheme.bodyMedium,
        ),
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
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isWideTablet = size.width >= ResponsiveBreakpoints.wideTablet;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: isWideTablet
            ? _buildWideTabletLayout(context)
            : _buildCompactOrTabletLayout(context),
      ),
    );
  }

  /// Single-column layout for mobile phones (<600dp) and portrait tablets (600–840dp).
  Widget _buildCompactOrTabletLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: ResponsiveCenter(maxWidth: 480, child: _buildLoginForm(context)),
      ),
    );
  }

  /// Two-pane layout for wide tablets in landscape (>=840dp).
  Widget _buildWideTabletLayout(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xl,
        ),
        child: ResponsiveCenter(
          maxWidth: 1040,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left branding and enterprise identity panel
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/goai_logo.png',
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.authBrandEyebrow,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppBrandColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Nền tảng Trợ lý AI & Không gian làm việc Nhân sự',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Xác thực an toàn, tra cứu chính sách chuẩn hóa và quản lý quy trình công việc tập trung.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _buildEnterpriseSecurityCard(context),
                    ],
                  ),
                ),
              ),

              // Right constrained login form
              Expanded(
                flex: 5,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: _buildLoginForm(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Core login form following approved information hierarchy.
  Widget _buildLoginForm(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final busy = _submitting || _guestSubmitting;
    final isFake = ref.watch(appConfigProvider).useFakeBackend;

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Top Brand Area: Official GoAI logo (left) + BẢO MẬT (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/goai_logo.png',
                  height: 34,
                  fit: BoxFit.contain,
                ),
                _buildSecurityBadge(context),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 2. Brand Eyebrow & Welcome Headings
            Text(
              l10n.authBrandEyebrow,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppBrandColors.primaryBlue,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.authSignInTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.authSignInSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 3. Input 1: Employee ID or Company Account
            AppTextField(
              controller: _accountController,
              label: l10n.authEmployeeAccountLabel,
              hint: l10n.authEmployeeAccountHint,
              prefixIcon: Icons.badge_outlined,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              enabled: !busy,
              validator: (v) => (v?.trim().isNotEmpty ?? false)
                  ? null
                  : l10n.authAccountRequired,
            ),
            const SizedBox(height: AppSpacing.md),

            // 4. Input 2: Registered Phone Number
            AppTextField(
              controller: _phoneController,
              label: l10n.authPhoneNumberLabel,
              hint: l10n.authPhoneNumberHint,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              enabled: !busy,
              onSubmitted: (_) => _submitVerificationCode(),
              validator: (v) => (v?.trim().isNotEmpty ?? false)
                  ? null
                  : l10n.authPhoneRequired,
            ),
            // 5. Primary Action CTA: "Gửi mã xác thực" (#0E3CAF)
            AppButton(
              label: l10n.authSendVerificationCode,
              onPressed: busy ? null : _submitVerificationCode,
              isLoading: _submitting,
              expand: true,
            ),

            // Development / Demo Login Shortcut (only active in development when useFakeBackend is true)
            if (isFake) ...[
              const SizedBox(height: AppSpacing.xs),
              AppButton(
                label: l10n.authContinueAsGuest,
                variant: AppButtonVariant.text,
                onPressed: busy ? null : _guest,
                isLoading: _guestSubmitting,
                expand: true,
              ),
            ],
            const SizedBox(height: AppSpacing.md),

            // 6. Enterprise SSO Entry
            Center(
              child: Text(
                l10n.authSsoPrompt,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: l10n.authSsoButton,
              variant: AppButtonVariant.secondary,
              onPressed: busy ? null : () => _handleSso(context),
              expand: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // 7. First-time User Informational Card
            _buildFirstTimeCard(context),
            const SizedBox(height: AppSpacing.sm),

            // 8. Shared Device / Security Notice
            _buildSharedDeviceNotice(context),
          ],
        ),
      ),
    );
  }

  /// Subtle security action pill on the top-right.
  Widget _buildSecurityBadge(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Semantics(
      button: true,
      label: l10n.authSecurityBadge,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: () => _showSecurityInfo(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppBrandColors.primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: AppBrandColors.primaryBlue.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 13,
                color: AppBrandColors.primaryBlue,
              ),
              const SizedBox(width: 4),
              Text(
                l10n.authSecurityBadge,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppBrandColors.primaryBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Informational card for first-time users.
  Widget _buildFirstTimeCard(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppBrandColors.primaryBlue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppBrandColors.primaryBlue.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: AppBrandColors.primaryBlue,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.authFirstTimeTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.authFirstTimeBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Security notice for shared devices with restrained gold accent.
  Widget _buildSharedDeviceNotice(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppBrandColors.secondaryGold.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppBrandColors.secondaryGold.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_clock_outlined,
            size: 18,
            color: Color(0xFF9E6E16),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.authSharedDeviceNotice,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6B4B10),
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Enterprise feature highlights shown on the left panel of wide tablet layout.
  Widget _buildEnterpriseSecurityCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: AppBrandColors.primaryBlue,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Tiêu chuẩn bảo mật doanh nghiệp',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '• Xác thực 2 lớp qua mã kích hoạt HR và số điện thoại\n'
            '• Mã hóa dữ liệu đường truyền và lưu trữ bảo mật trên thiết bị\n'
            '• Cơ chế tự động khóa phiên khi không sử dụng',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
