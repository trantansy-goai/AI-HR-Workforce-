import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/failure_messages.dart';
import '../../../core/error/result.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../application/auth_providers.dart';

/// Current + new password form. On success the session ends (the server
/// revokes old tokens) and the router returns to sign-in.
Future<void> showChangePasswordDialog(BuildContext context) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (_) => const ChangePasswordDialog(),
);

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.maybeOf(context);
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final result = await ref
        .read(authControllerProvider.notifier)
        .changePassword(
          currentPassword: _current.text,
          newPassword: _next.text,
        );
    if (!mounted) return;
    switch (result) {
      case Ok():
        Navigator.of(context).pop();
        if (messenger != null) {
          showAppSnackBarOn(
            messenger,
            colors,
            l10n.authPasswordChanged,
            type: AppSnackType.success,
          );
        }
      case Err(:final failure):
        setState(() {
          _busy = false;
          _error = failure is ValidationFailure
              ? l10n.authPasswordRejected
              : failure.localizedMessage(l10n);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.authChangePassword),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _current,
              hint: l10n.authCurrentPassword,
              obscure: true,
              enabled: !_busy,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v?.isNotEmpty ?? false) ? null : l10n.authPasswordRequired,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _next,
              hint: l10n.authNewPassword,
              obscure: true,
              enabled: !_busy,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v?.isNotEmpty ?? false) ? null : l10n.authPasswordRequired,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _confirm,
              hint: l10n.authConfirmPassword,
              obscure: true,
              enabled: !_busy,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              validator: (v) =>
                  v == _next.text ? null : l10n.authPasswordMismatch,
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(l10n.authChangePassword),
        ),
      ],
    );
  }
}
