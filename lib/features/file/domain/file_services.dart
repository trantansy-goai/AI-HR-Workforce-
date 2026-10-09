import 'attachment.dart';

/// Uploads a local attachment to remote storage.
///
/// Implement per backend: presigned S3/MinIO PUT, Firebase Storage, or a
/// custom multipart endpoint. Throws `AppFailure` on error.
abstract interface class FileUploader {
  Future<RemoteAttachmentSource> upload(
    Attachment attachment, {
    void Function(double progress)? onProgress,
  });
}

/// Lets the user choose files. Implement with `file_picker` / `image_picker`
/// in the data layer; a demo implementation backs the fake backend.
abstract interface class AttachmentPicker {
  Future<List<Attachment>> pick({Set<AttachmentKind>? kinds});

  /// Photos and videos via the platform's own media picker (Android Photo
  /// Picker / iOS PHPicker). Empty when the user cancels.
  Future<List<Attachment>> pickMedia();

  /// Documents via the platform file picker, limited to [extensions]
  /// (without dots, e.g. `['pdf']`); null allows any file.
  Future<List<Attachment>> pickFiles({List<String>? extensions});
}

/// Local copies of remote attachments, for players and viewers that cannot
/// send the session's credentials themselves. Throws `AppFailure`.
abstract interface class AttachmentDownloader {
  /// Path of a device copy of [attachment]: its own device path, or a
  /// cached download of its URL.
  Future<String> localPath(Attachment attachment);
}
