import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/di/core_providers.dart';
import '../data/caching_attachment_downloader.dart';
import '../data/default_file_picker.dart';
import '../data/demo_file_services.dart';
import '../data/native_file_picker.dart';
import '../data/open_webui_file_uploader.dart';
import '../domain/attachment.dart';
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

/// Device copies of remote attachments; the token is only sent to the
/// app's own API hosts.
final attachmentDownloaderProvider = Provider<AttachmentDownloader>((ref) {
  final config = ref.watch(appConfigProvider);
  return CachingAttachmentDownloader(
    authorizedDio: ref.watch(authenticatedDioProvider),
    publicDio: ref.watch(publicDioProvider),
    trustedHosts: {
      for (final url in [config.openWebUiBaseUrl, config.apiBaseUrl])
        ?Uri.tryParse(url)?.host,
    },
    cacheDirectory: getApplicationCacheDirectory,
  );
});

/// Path of a device copy of an attachment (downloaded when remote).
final attachmentLocalPathProvider = FutureProvider.autoDispose
    .family<String, Attachment>((ref, attachment) {
      return ref.watch(attachmentDownloaderProvider).localPath(attachment);
    });
