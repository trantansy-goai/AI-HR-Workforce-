import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/default_file_picker.dart';
import '../data/demo_file_services.dart';
import '../data/native_file_picker.dart';
import '../data/open_webui_file_uploader.dart';
import '../domain/file_services.dart';

/// Open WebUI file storage (RAG), or a simulated upload with the fake
/// backend.
final fileUploaderProvider = Provider<FileUploader>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) return FakeFileUploader();
  return OpenWebUiFileUploader(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: config.openWebUiBaseUrl,
  );
});

/// Platform file picker service.
final attachmentPickerProvider = Provider<AttachmentPicker>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.useFakeNativeAdapters
      ? DefaultFilePickerService()
      : const NativeFilePicker();
});
