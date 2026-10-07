import 'package:flutter/material.dart';
import 'package:flutter_project_base/features/chat/presentation/widgets/file_type_sheet.dart';
import 'package:flutter_project_base/features/file/domain/attachment.dart';
import 'package:flutter_project_base/features/file/presentation/attachment_viewers.dart';
import 'package:flutter_project_base/features/file/presentation/file_type_style.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helpers.dart';

Attachment _file(
  String name, {
  AttachmentKind kind = AttachmentKind.document,
}) => Attachment(
  id: name,
  name: name,
  mimeType: 'application/octet-stream',
  kind: kind,
  source: LocalAttachmentSource('/tmp/$name'),
);

void main() {
  test('FileTypeStyle picks icon and label by extension', () {
    expect(FileTypeStyle.of(_file('a.pdf')).icon, Icons.picture_as_pdf);
    expect(FileTypeStyle.of(_file('a.pdf')).label, 'PDF');
    expect(FileTypeStyle.of(_file('b.DOCX')).icon, Icons.description);
    expect(FileTypeStyle.of(_file('c.xlsx')).icon, Icons.table_chart);
    expect(FileTypeStyle.of(_file('d.pptx')).icon, Icons.slideshow);
    expect(FileTypeStyle.of(_file('e.zip')).icon, Icons.folder_zip);
    expect(FileTypeStyle.of(_file('noext')).label, 'FILE');
  });

  test('uploading keeps the on-device copy for previews', () {
    final local = _file('photo.jpg', kind: AttachmentKind.image);
    final uploaded = local.copyWith(
      source: const RemoteAttachmentSource(url: 'https://x/photo.jpg'),
      uploadStatus: UploadStatus.uploaded,
    );
    expect(uploaded.devicePath, '/tmp/photo.jpg');
    expect(uploaded.remoteUrl, 'https://x/photo.jpg');
  });

  test('formatClock formats media positions', () {
    expect(formatClock(const Duration(seconds: 5)), '0:05');
    expect(formatClock(const Duration(minutes: 3, seconds: 7)), '3:07');
    expect(formatClock(const Duration(hours: 1, minutes: 2)), '1:02:00');
  });

  testWidgets('file type sheet returns the chosen extensions', (tester) async {
    FileTypeChoice? choice;
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => choice = await showFileTypeSheet(context),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Choose file type'), findsOneWidget);

    await tester.tap(find.text('Word'));
    await tester.pumpAndSettle();
    expect(choice?.extensions, ['doc', 'docx']);
  });
}
