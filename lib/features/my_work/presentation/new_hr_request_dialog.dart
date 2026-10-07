import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/hr_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/hr_widgets.dart';
import '../../file/application/file_providers.dart';
import '../../file/domain/attachment.dart';
import '../application/my_work_providers.dart';
import '../domain/my_work_item.dart';

/// Opens the M05 "Gửi yêu cầu HR" dialog. Resolves to the created case, or
/// null when the employee closes it without submitting.
Future<CaseTrackingItem?> showNewHrRequestDialog(BuildContext context) {
  final scoped = hrScopedTheme(Theme.of(context));
  return showDialog<CaseTrackingItem>(
    context: context,
    // Only the close button dismisses it, so a stray tap can't lose the draft.
    barrierDismissible: false,
    builder: (_) => Theme(data: scoped, child: const NewHrRequestDialog()),
  );
}

String hrRequestTypeLabel(AppLocalizations l10n, HrRequestType type) =>
    switch (type) {
      HrRequestType.personalInfo => l10n.myWorkRequestTypePersonalInfo,
      HrRequestType.leave => l10n.myWorkRequestTypeLeave,
      HrRequestType.policy => l10n.myWorkRequestTypePolicy,
      HrRequestType.complaint => l10n.myWorkRequestTypeComplaint,
    };

/// M05 · A0 + A4 — capture a minimal HR request and issue a case code.
class NewHrRequestDialog extends ConsumerStatefulWidget {
  const NewHrRequestDialog({super.key});

  @override
  ConsumerState<NewHrRequestDialog> createState() => _NewHrRequestDialogState();
}

class _NewHrRequestDialogState extends ConsumerState<NewHrRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  HrRequestType? _type;
  List<Attachment> _attachments = const [];
  bool _submitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _attach() async {
    final picked = await ref.read(attachmentPickerProvider).pick();
    if (picked.isEmpty || !mounted) return;
    setState(() => _attachments = [..._attachments, ...picked]);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      final created = await ref
          .read(myWorkRepositoryProvider)
          .submitRequest(
            HrRequestDraft(
              type: _type!,
              description: _descriptionController.text,
              attachmentNames: [for (final a in _attachments) a.name],
            ),
          );
      ref.invalidate(caseTrackingListProvider);
      if (mounted) Navigator.of(context).pop(created);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showAppSnackBar(
        context.l10n.commonErrorTitle,
        type: AppSnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      backgroundColor: AppHrPalette.background,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ContentConstraints.dialog),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: HrPageTitle(l10n.myWorkNewRequest)),
                    IconButton(
                      tooltip: l10n.commonClose,
                      onPressed: _submitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: AppHrPalette.ink),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildFields(l10n),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields(AppLocalizations l10n) => [
    const SizedBox(height: AppSpacing.md),
    DropdownButtonFormField<HrRequestType>(
      initialValue: _type,
      isExpanded: true,
      hint: Text(
        l10n.myWorkRequestTypeHint,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppHrPalette.inkMuted,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      items: [
        for (final type in HrRequestType.values)
          DropdownMenuItem(
            value: type,
            child: Text(hrRequestTypeLabel(l10n, type)),
          ),
      ],
      onChanged: _submitting ? null : (v) => setState(() => _type = v),
      validator: (v) => v == null ? l10n.myWorkRequestTypeRequired : null,
    ),
    const SizedBox(height: AppSpacing.md),
    TextFormField(
      controller: _descriptionController,
      enabled: !_submitting,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(hintText: l10n.myWorkRequestDescriptionHint),
      validator: (v) => (v?.trim().isNotEmpty ?? false)
          ? null
          : l10n.myWorkRequestDescriptionRequired,
    ),
    const SizedBox(height: AppSpacing.md),
    InkWell(
      onTap: _submitting ? null : _attach,
      borderRadius: hrBoxRadius,
      child: InputDecorator(
        isEmpty: _attachments.isEmpty,
        decoration: InputDecoration(
          hintText: l10n.myWorkRequestAttachHint,
          suffixIcon: const Icon(
            Icons.attach_file_rounded,
            color: AppHrPalette.inkMuted,
          ),
        ),
        child: _attachments.isEmpty
            ? null
            : Text(l10n.myWorkRequestAttached(_attachments.length)),
      ),
    ),
    const SizedBox(height: AppSpacing.md),
    HrNoticeBox(text: l10n.myWorkRequestPrivacyNotice),
    const SizedBox(height: AppSpacing.md),
    AppButton(
      label: l10n.myWorkRequestSubmit,
      onPressed: _submit,
      isLoading: _submitting,
      expand: true,
    ),
    const SizedBox(height: AppSpacing.md),
    HrCard(
      child: HrCardText(
        title: l10n.myWorkRequestAfterTitle,
        body: l10n.myWorkRequestAfterBody,
      ),
    ),
    const SizedBox(height: AppSpacing.md),
    HrNoticeBox(text: l10n.myWorkRequestUrgentNote, warning: true),
  ];
}
