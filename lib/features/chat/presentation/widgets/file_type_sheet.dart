import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/theme/app_tokens.dart';

/// A file category the user picked; [extensions] null means any file.
class FileTypeChoice {
  const FileTypeChoice(this.extensions);

  final List<String>? extensions;
}

/// Bottom sheet listing file categories (PDF, Word, Excel, PowerPoint,
/// text, all). The chosen category's extensions filter the system file
/// picker. Resolves to null when dismissed.
Future<FileTypeChoice?> showFileTypeSheet(BuildContext context) {
  final l10n = context.l10n;
  final options = <(IconData, Color, String, List<String>?)>[
    (
      Icons.picture_as_pdf,
      const Color(0xFFD93025),
      l10n.chatFileTypePdf,
      ['pdf'],
    ),
    (
      Icons.description,
      const Color(0xFF2B579A),
      l10n.chatFileTypeWord,
      ['doc', 'docx'],
    ),
    (
      Icons.table_chart,
      const Color(0xFF217346),
      l10n.chatFileTypeExcel,
      ['xls', 'xlsx', 'csv'],
    ),
    (
      Icons.slideshow,
      const Color(0xFFC43E1C),
      l10n.chatFileTypePowerPoint,
      ['ppt', 'pptx'],
    ),
    (
      Icons.article,
      AppHrPalette.inkMuted,
      l10n.chatFileTypeText,
      ['txt', 'csv'],
    ),
    (Icons.folder_open, AppHrPalette.accent, l10n.chatFileTypeAll, null),
  ];

  return showModalBottomSheet<FileTypeChoice>(
    context: context,
    showDragHandle: true,
    // Grows with its content and scrolls on short screens (e.g. landscape).
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: Text(
                l10n.chatFileTypeTitle,
                style: const TextStyle(
                  color: AppHrPalette.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            for (final (icon, color, label, extensions) in options)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                ),
                leading: Icon(icon, color: color),
                title: Text(label),
                subtitle: extensions == null
                    ? null
                    : Text(extensions.map((e) => '.$e').join('  ')),
                onTap: () =>
                    Navigator.of(sheetContext).pop(FileTypeChoice(extensions)),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    ),
  );
}
