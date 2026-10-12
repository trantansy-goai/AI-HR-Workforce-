import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/error_mapper.dart';
import '../domain/attachment.dart';
import '../domain/file_services.dart';

/// Downloads remote attachments once into a cache folder. URLs on
/// [trustedHosts] (the app's own API, e.g. Open WebUI's
/// `/api/v1/files/{id}/content`) go through [authorizedDio] with the
/// session's token; any other URL through [publicDio], so the token never
/// leaves the app's backend.
class CachingAttachmentDownloader implements AttachmentDownloader {
  CachingAttachmentDownloader({
    required this.authorizedDio,
    required this.publicDio,
    required this.trustedHosts,
    required this.cacheDirectory,
  });

  final Dio authorizedDio;
  final Dio publicDio;
  final Set<String> trustedHosts;
  final Future<Directory> Function() cacheDirectory;

  final Map<String, Future<String>> _inFlight = {};

  @override
  Future<String> localPath(Attachment attachment) {
    final device = attachment.devicePath;
    if (device != null) return Future.value(device);
    final url = attachment.remoteUrl;
    if (url == null) {
      return Future.error(const NotFoundFailure('Attachment has no file'));
    }
    // The callback must not return the removed future: whenComplete would
    // wait for it, i.e. for itself.
    return _inFlight[url] ??= _download(url, attachment.name).whenComplete(() {
      _inFlight.remove(url);
    });
  }

  Future<String> _download(String url, String name) async {
    final root = await cacheDirectory();
    // One folder per URL keeps the original file name for "open with".
    final key = base64Url.encode(utf8.encode(url)).replaceAll('=', '');
    final folder = Directory(
      '${root.path}/attachments/${key.length > 120 ? key.substring(key.length - 120) : key}',
    );
    final file = File('${folder.path}/${_safeName(name)}');
    if (await file.exists() && await file.length() > 0) return file.path;
    await folder.create(recursive: true);
    final host = Uri.tryParse(url)?.host;
    final dio = trustedHosts.contains(host) ? authorizedDio : publicDio;
    try {
      await dio.download(url, file.path);
    } on DioException catch (e) {
      if (await file.exists()) await file.delete();
      throw ErrorMapper.fromDio(e);
    }
    return file.path;
  }

  static String _safeName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[/\\:*?"<>|]'), '_').trim();
    return cleaned.isEmpty ? 'file' : cleaned;
  }
}
