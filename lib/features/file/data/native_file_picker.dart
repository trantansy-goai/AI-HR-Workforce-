import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/attachment.dart';
import '../domain/file_services.dart';
import '../domain/mime_types.dart';

typedef FilePickerDelegate = Future<List<PlatformFile>> Function({
  FileType type,
  List<String>? allowedExtensions,
});

/// Opens the platform media picker; returns the chosen photos/videos.
typedef MediaPickerDelegate = Future<List<XFile>> Function();

/// Production native implementation of [AttachmentPicker]:
/// - photos/videos through `image_picker` (Android Photo Picker, iOS
///   PHPicker — no storage permission needed);
/// - documents through `file_picker`, optionally filtered by extension.
class NativeFilePicker implements AttachmentPicker {
  const NativeFilePicker({this.pickerDelegate, this.mediaDelegate});

  final FilePickerDelegate? pickerDelegate;
  final MediaPickerDelegate? mediaDelegate;

  @override
  Future<List<Attachment>> pick({Set<AttachmentKind>? kinds}) async {
    var fileType = FileType.any;
    if (kinds != null && kinds.length == 1) {
      fileType = switch (kinds.first) {
        AttachmentKind.image => FileType.image,
        AttachmentKind.video => FileType.video,
        AttachmentKind.audio => FileType.audio,
        AttachmentKind.document || AttachmentKind.other => FileType.any,
      };
    }
    return _pickWithFilePicker(type: fileType);
  }

  @override
  Future<List<Attachment>> pickFiles({List<String>? extensions}) =>
      _pickWithFilePicker(
        type: extensions == null ? FileType.any : FileType.custom,
        allowedExtensions: extensions,
      );

  @override
  Future<List<Attachment>> pickMedia() async {
    final pickerFn =
        mediaDelegate ?? () => ImagePicker().pickMultipleMedia(limit: 10);
    final files = await pickerFn();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return [
      for (var i = 0; i < files.length; i++)
        _attachment(
          id: 'media_${timestamp}_$i',
          name: files[i].name,
          path: files[i].path,
          size: await _sizeOf(files[i].path),
        ),
    ];
  }

  Future<List<Attachment>> _pickWithFilePicker({
    required FileType type,
    List<String>? allowedExtensions,
  }) async {
    final pickerFn =
        pickerDelegate ??
        ({FileType type = FileType.any, List<String>? allowedExtensions}) =>
            FilePicker.pickFiles(
              type: type,
              allowedExtensions: allowedExtensions,
            );

    final files = await pickerFn(
      type: type,
      allowedExtensions: allowedExtensions,
    );
    if (files.isEmpty) return const []; // User cancelled picker

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final attachments = <Attachment>[];
    for (var i = 0; i < files.length; i++) {
      final file = files[i];
      final path = file.path;
      if (path == null) continue;
      attachments.add(
        _attachment(
          id: 'picked_${timestamp}_$i',
          name: file.name,
          path: path,
          size: file.lengthSync(),
        ),
      );
    }
    return attachments;
  }

  Attachment _attachment({
    required String id,
    required String name,
    required String path,
    int? size,
  }) {
    final mimeType = MimeTypes.fromFileName(name);
    return Attachment(
      id: id,
      name: name,
      mimeType: mimeType,
      kind: MimeTypes.kindOf(mimeType),
      source: LocalAttachmentSource(path),
      sizeBytes: size,
    );
  }

  Future<int?> _sizeOf(String path) async {
    try {
      return await File(path).length();
    } catch (_) {
      return null;
    }
  }
}
