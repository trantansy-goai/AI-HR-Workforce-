import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/features/file/data/caching_attachment_downloader.dart';
import 'package:goai_mobile/features/file/domain/attachment.dart';

import '../../helpers/fake_http_adapter.dart';

Attachment _remote(String url, {String name = 'leave.pdf'}) => Attachment(
  id: 'a',
  name: name,
  mimeType: 'application/pdf',
  kind: AttachmentKind.document,
  source: RemoteAttachmentSource(url: url),
);

void main() {
  late Directory temp;
  late FakeHttpAdapter authorized;
  late FakeHttpAdapter public;
  late CachingAttachmentDownloader downloader;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('att');
    FakeResponse file(_) =>
        const FakeResponse('bytes', contentType: 'application/pdf');
    authorized = FakeHttpAdapter({'GET /api/v1/files/f-1/content': file});
    public = FakeHttpAdapter({'GET /pic.png': file});
    downloader = CachingAttachmentDownloader(
      authorizedDio: fakeDio(authorized),
      publicDio: fakeDio(public),
      trustedHosts: {'webui.test'},
      cacheDirectory: () async => temp,
    );
  });

  tearDown(() => temp.delete(recursive: true));

  test('downloads own-API files with the session, once', () async {
    final attachment = _remote('https://webui.test/api/v1/files/f-1/content');

    final path = await downloader.localPath(attachment);
    final again = await downloader.localPath(attachment);

    expect(path, again);
    expect(path, endsWith('/leave.pdf'));
    expect(await File(path).readAsString(), 'bytes');
    expect(authorized.calls, ['GET /api/v1/files/f-1/content']);
    expect(public.calls, isEmpty);
  });

  test('other hosts never get the session', () async {
    await downloader.localPath(
      _remote('https://cdn.example.com/pic.png', name: 'pic.png'),
    );

    expect(public.calls, ['GET /pic.png']);
    expect(authorized.calls, isEmpty);
  });

  test('device files are used as they are', () async {
    const local = Attachment(
      id: 'l',
      name: 'x.m4a',
      mimeType: 'audio/mp4',
      kind: AttachmentKind.audio,
      source: LocalAttachmentSource('/tmp/x.m4a'),
    );

    expect(await downloader.localPath(local), '/tmp/x.m4a');
    expect([...authorized.calls, ...public.calls], isEmpty);
  });
}
