import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/default_file_picker.dart';
import '../data/demo_file_services.dart';
import '../data/native_file_picker.dart';
import '../domain/file_services.dart';

/// Override with a real uploader (S3/MinIO/Firebase/custom) in the app.
final fileUploaderProvider = Provider<FileUploader>(
  (ref) => FakeFileUploader(),
);

/// Platform file picker service.
final attachmentPickerProvider = Provider<AttachmentPicker>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.useFakeNativeAdapters
      ? DefaultFilePickerService()
      : const NativeFilePicker();
});
