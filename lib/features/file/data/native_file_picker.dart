import 'package:file_picker/file_picker.dart';

import '../domain/attachment.dart';
import '../domain/file_services.dart';
import '../domain/mime_types.dart';

typedef FilePickerDelegate = Future<List<PlatformFile>> Function({
  FileType type,
});

/// Production native implementation of [AttachmentPicker] using `file_picker`.
class NativeFilePicker implements AttachmentPicker {
  const NativeFilePicker({this.pickerDelegate});

  final FilePickerDelegate? pickerDelegate;

  @override
  Future<List<Attachment>> pick({Set<AttachmentKind>? kinds}) async {
    FileType fileType = FileType.any;
    if (kinds != null && kinds.length == 1) {
      final kind = kinds.first;
      switch (kind) {
        case AttachmentKind.image:
          fileType = FileType.image;
        case AttachmentKind.video:
          fileType = FileType.video;
        case AttachmentKind.audio:
          fileType = FileType.audio;
        case AttachmentKind.document:
        case AttachmentKind.other:
          fileType = FileType.any;
      }
    }

    final pickerFn =
        pickerDelegate ??
        (({FileType type = FileType.any}) => FilePicker.pickFiles(type: type));

    final files = await pickerFn(type: fileType);

    if (files.isEmpty) {
      return const []; // User cancelled picker
    }

    final attachments = <Attachment>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final path = file.path;
      if (path == null) continue;

      final name = file.name;
      final mimeType = MimeTypes.fromFileName(name);
      final kind = MimeTypes.kindOf(mimeType);
      final size = file.lengthSync();

      attachments.add(
        Attachment(
          id: 'picked_${timestamp}_$i',
          name: name,
          mimeType: mimeType,
          kind: kind,
          source: LocalAttachmentSource(path),
          sizeBytes: size,
        ),
      );
    }

    return attachments;
  }
}
