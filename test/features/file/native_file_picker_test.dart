import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_project_base/features/file/data/native_file_picker.dart';
import 'package:flutter_project_base/features/file/domain/attachment.dart';
import 'package:flutter_test/flutter_test.dart';

base class _TestPlatformFile extends PlatformFile {
  _TestPlatformFile({
    required this.name,
    required this.filePath,
    this.sizeBytes = 1024,
  });

  @override
  final String name;

  final String filePath;
  final int sizeBytes;

  @override
  Uri get uri => Uri.file(filePath);

  @override
  String? get path => filePath;

  @override
  XFile get xFile => XFile(filePath);

  @override
  int? lengthSync() => sizeBytes;

  @override
  Future<int?> length() async => sizeBytes;

  @override
  Future<Uint8List> readAsBytes() async => Uint8List(0);

  @override
  Stream<Uint8List> readAsByteStream() => const Stream.empty();
}

void main() {
  group('NativeFilePicker', () {
    test('returns empty list when user cancels picker', () async {
      final picker = NativeFilePicker(
        pickerDelegate: ({type = FileType.any}) async => [],
      );

      final files = await picker.pick();
      expect(files, isEmpty);
    });

    test('maps picked file into Attachment entity correctly', () async {
      final testFile = _TestPlatformFile(
        name: 'report.pdf',
        filePath: '/storage/emulated/0/Download/report.pdf',
        sizeBytes: 2048,
      );

      final picker = NativeFilePicker(
        pickerDelegate: ({type = FileType.any}) async => [testFile],
      );

      final files = await picker.pick();
      expect(files.length, equals(1));

      final attachment = files.first;
      expect(attachment.name, equals('report.pdf'));
      expect(attachment.mimeType, equals('application/pdf'));
      expect(attachment.kind, equals(AttachmentKind.document));
      expect(attachment.sizeBytes, equals(2048));
      expect(
        attachment.source,
        equals(
          const LocalAttachmentSource(
            '/storage/emulated/0/Download/report.pdf',
          ),
        ),
      );
    });
  });
}
