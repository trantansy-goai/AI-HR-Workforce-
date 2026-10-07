import 'package:flutter/material.dart';

import '../domain/attachment.dart';

/// Icon, tint and short label ("PDF", "DOCX"…) for a file, by extension.
class FileTypeStyle {
  const FileTypeStyle(this.icon, this.color, this.label);

  final IconData icon;
  final Color color;
  final String label;

  static const _pdf = Color(0xFFD93025);
  static const _word = Color(0xFF2B579A);
  static const _excel = Color(0xFF217346);
  static const _powerPoint = Color(0xFFC43E1C);
  static const _archive = Color(0xFF7B5E3B);
  static const _text = Color(0xFF5B6475);
  static const _media = Color(0xFF6B4BB8);

  static String extensionOf(String name) {
    final dot = name.lastIndexOf('.');
    return dot < 0 || dot == name.length - 1
        ? ''
        : name.substring(dot + 1).toLowerCase();
  }

  static FileTypeStyle of(Attachment attachment) {
    final ext = extensionOf(attachment.name);
    final label = ext.isEmpty ? 'FILE' : ext.toUpperCase();
    return switch (ext) {
      'pdf' => FileTypeStyle(Icons.picture_as_pdf, _pdf, label),
      'doc' ||
      'docx' ||
      'rtf' ||
      'odt' => FileTypeStyle(Icons.description, _word, label),
      'xls' ||
      'xlsx' ||
      'csv' ||
      'ods' => FileTypeStyle(Icons.table_chart, _excel, label),
      'ppt' ||
      'pptx' ||
      'odp' => FileTypeStyle(Icons.slideshow, _powerPoint, label),
      'zip' ||
      'rar' ||
      '7z' => FileTypeStyle(Icons.folder_zip, _archive, label),
      'txt' || 'md' || 'json' => FileTypeStyle(Icons.article, _text, label),
      _ => switch (attachment.kind) {
        AttachmentKind.image => FileTypeStyle(Icons.image, _media, label),
        AttachmentKind.video => FileTypeStyle(Icons.movie, _media, label),
        AttachmentKind.audio => FileTypeStyle(Icons.audiotrack, _media, label),
        _ => FileTypeStyle(Icons.insert_drive_file, _text, label),
      },
    };
  }
}

/// Rounded square with the file-type icon.
class FileTypeIcon extends StatelessWidget {
  const FileTypeIcon({super.key, required this.attachment, this.size = 40});

  final Attachment attachment;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = FileTypeStyle.of(attachment);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(style.icon, color: style.color, size: size * 0.6),
    );
  }
}
