import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/features/chat/domain/entities/message.dart';
import 'package:goai_mobile/features/chat/domain/entities/message_metadata.dart';
import 'package:goai_mobile/features/chat/domain/entities/participant.dart';
import 'package:goai_mobile/features/chat/domain/extensions/ai_extensions.dart';
import 'package:goai_mobile/features/chat/presentation/widgets/chat_composer.dart';
import 'package:goai_mobile/features/chat/presentation/widgets/message_bubble.dart';
import 'package:goai_mobile/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:goai_mobile/features/file/domain/attachment.dart';
import 'package:goai_mobile/features/file/presentation/attachment_viewers.dart';
import 'package:goai_mobile/features/voice/data/fake_voice_recorder.dart';

import '../helpers/test_helpers.dart';

const me = Participant(id: 'me', displayName: 'Me', type: SenderType.user);
const agent = Participant(
  id: 'a',
  displayName: 'Agent Linh',
  type: SenderType.agent,
);

Message message({
  String content = 'Hello there',
  Participant sender = me,
  MessageStatus status = MessageStatus.sent,
  MessageType type = MessageType.text,
  ReplyReference? replyTo,
  MessageMetadata metadata = const MessageMetadata.empty(),
  List<Attachment> attachments = const [],
}) => Message(
  id: 'm1',
  conversationId: 'c',
  sender: sender,
  createdAt: DateTime(2026, 1, 1, 9, 30),
  content: content,
  status: status,
  type: type,
  replyTo: replyTo,
  metadata: metadata,
  attachments: attachments,
);

void main() {
  group('MessageBubble', () {
    testWidgets('renders text, sender name and status', (tester) async {
      await tester.pumpWidget(
        testApp(
          MessageBubble(
            message: message(sender: agent),
            isMine: false,
            showSenderName: true,
          ),
        ),
      );
      expect(find.text('Hello there'), findsOneWidget);
      expect(find.text('Agent Linh'), findsOneWidget);
    });

    testWidgets('failed message shows hint and retries on tap', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        testApp(
          MessageBubble(
            message: message(status: MessageStatus.failed),
            isMine: true,
            onRetry: () => retried = true,
          ),
        ),
      );
      expect(find.text('Not sent. Tap to retry.'), findsOneWidget);
      await tester.tap(find.text('Hello there'));
      expect(retried, isTrue);
    });

    testWidgets('streaming message shows a caret', (tester) async {
      await tester.pumpWidget(
        testApp(
          MessageBubble(
            message: message(
              content: 'Partial',
              status: MessageStatus.streaming,
            ),
            isMine: false,
          ),
        ),
      );
      expect(find.textContaining('Partial'), findsOneWidget);
      expect(find.textContaining('▍', findRichText: true), findsOneWidget);
    });

    testWidgets('renders reply quote, attachments and citations', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          MessageBubble(
            message: message(
              sender: const Participant(
                id: 'ai',
                displayName: 'AI',
                type: SenderType.ai,
              ),
              replyTo: const ReplyReference(
                messageId: 'x',
                senderName: 'Me',
                preview: 'Original question',
              ),
              attachments: const [
                Attachment(
                  id: 'f',
                  name: 'report.pdf',
                  mimeType: 'application/pdf',
                  kind: AttachmentKind.document,
                  source: RemoteAttachmentSource(url: 'https://x/report.pdf'),
                  sizeBytes: 2048,
                ),
              ],
              metadata: MessageMetadata.of([
                const Citations([SourceReference(id: '1', title: 'Guide')]),
              ]),
            ),
            isMine: false,
          ),
        ),
      );
      expect(find.text('Original question'), findsOneWidget);
      expect(find.text('report.pdf'), findsOneWidget);
      expect(find.text('2.0 KB · PDF'), findsOneWidget);
      expect(find.text('Sources'), findsOneWidget);
      expect(find.text('Guide'), findsOneWidget);
    });

    testWidgets('system messages are centered plain text', (tester) async {
      await tester.pumpWidget(
        testApp(
          MessageBubble(
            message: message(
              content: 'Conversation started',
              sender: Participant.system,
              type: MessageType.system,
            ),
            isMine: false,
          ),
        ),
      );
      expect(find.text('Conversation started'), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('long press triggers reply', (tester) async {
      var replied = false;
      await tester.pumpWidget(
        testApp(
          MessageBubble(
            message: message(),
            isMine: true,
            onReply: () => replied = true,
          ),
        ),
      );
      await tester.longPress(find.text('Hello there'));
      expect(replied, isTrue);
    });
  });

  group('ChatComposer', () {
    testWidgets('send is disabled until text is entered, then clears', (
      tester,
    ) async {
      final sent = <String>[];
      await tester.pumpWidget(testApp(ChatComposer(onSend: sent.add)));

      IconButton sendButton() => tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.send),
      );
      expect(sendButton().onPressed, isNull);

      await tester.enterText(find.byType(TextField), '  hi  ');
      await tester.pump();
      expect(sendButton().onPressed, isNotNull);

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(sent, ['hi']);
      expect(find.text('  hi  '), findsNothing);
    });

    testWidgets('shows stop button while generating', (tester) async {
      var stopped = false;
      await tester.pumpWidget(
        testApp(
          ChatComposer(
            onSend: (_) {},
            isGenerating: true,
            onStop: () => stopped = true,
          ),
        ),
      );
      expect(find.byIcon(Icons.send), findsNothing);
      await tester.tap(find.byIcon(Icons.stop));
      expect(stopped, isTrue);
    });

    testWidgets('reply banner can be cancelled; attach is optional', (
      tester,
    ) async {
      var cancelled = false;
      var attached = false;
      var media = false;
      await tester.pumpWidget(
        testApp(
          ChatComposer(
            onSend: (_) {},
            onAttachFile: () => attached = true,
            onAttachMedia: () => media = true,
            replyTo: const ReplyReference(
              messageId: 'x',
              senderName: 'Linh',
              preview: 'Earlier',
            ),
            onCancelReply: () => cancelled = true,
          ),
        ),
      );
      expect(find.text('Replying to Linh'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.tap(find.byIcon(Icons.attach_file));
      await tester.tap(find.byIcon(Icons.photo_library_outlined));
      expect(cancelled, isTrue);
      expect(attached, isTrue);
      expect(media, isTrue);
    });

    testWidgets('mic is hidden without onVoiceRecorded', (tester) async {
      await tester.pumpWidget(testApp(ChatComposer(onSend: (_) {})));
      expect(find.byIcon(Icons.mic), findsNothing);
    });

    testWidgets('records a voice note and hands back path + duration', (
      tester,
    ) async {
      final recorder = FakeVoiceRecorder();
      String? path;
      await tester.pumpWidget(
        testApp(
          ChatComposer(
            onSend: (_) {},
            voiceRecorder: recorder,
            onVoiceRecorded: (p, _) => path = p,
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump();
      expect(find.textContaining('Recording'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.stop_circle));
      await tester.pump();
      expect(path, '/tmp/fake_voice_recording.m4a');
      expect(find.textContaining('Recording'), findsNothing);
      recorder.dispose();
    });

    testWidgets('blocked microphone offers to open app settings', (
      tester,
    ) async {
      final recorder = FakeVoiceRecorder(
        grantPermission: false,
        permanentlyDenied: true,
      );
      await tester.pumpWidget(
        testApp(
          ChatComposer(
            onSend: (_) {},
            voiceRecorder: recorder,
            onVoiceRecorded: (_, _) {},
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();

      expect(find.text('Microphone access needed'), findsOneWidget);
      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();
      expect(recorder.settingsOpened, 1);
      expect(find.textContaining('Recording'), findsNothing);
      recorder.dispose();
    });

    testWidgets('denied microphone also offers settings; cancel closes', (
      tester,
    ) async {
      final recorder = FakeVoiceRecorder(grantPermission: false);
      await tester.pumpWidget(
        testApp(
          ChatComposer(
            onSend: (_) {},
            voiceRecorder: recorder,
            onVoiceRecorded: (_, _) {},
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();
      expect(find.text('Microphone access needed'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(recorder.settingsOpened, 0);
      recorder.dispose();
    });
  });

  group('MessageBubble attachments', () {
    Message withAttachment(Attachment a, {String content = ''}) =>
        message(content: content, attachments: [a]);

    const pdf = Attachment(
      id: 'f',
      name: 'Hop_dong.docx',
      mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      kind: AttachmentKind.document,
      source: LocalAttachmentSource('/tmp/Hop_dong.docx'),
      sizeBytes: 1536,
    );

    testWidgets('is at most 2/3 of the screen width', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        testApp(
          MessageBubble(
            message: withAttachment(pdf, content: 'x' * 400),
            isMine: true,
          ),
        ),
      );
      final width = tester.getSize(find.byType(GestureDetector).first).width;
      expect(width, lessThanOrEqualTo(400 * 2 / 3 + 0.5));
    });

    testWidgets('file shows type, size and opens the file viewer', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(MessageBubble(message: withAttachment(pdf), isMine: true)),
      );
      expect(find.text('Hop_dong.docx'), findsOneWidget);
      expect(find.text('1.5 KB · DOCX'), findsOneWidget);
      expect(find.byIcon(Icons.description), findsOneWidget);

      await tester.tap(find.text('Hop_dong.docx'));
      await tester.pumpAndSettle();
      expect(find.byType(FileViewerPage), findsOneWidget);
      expect(find.text('Open with another app'), findsOneWidget);
    });

    testWidgets('image opens the full-screen image viewer', (tester) async {
      const image = Attachment(
        id: 'i',
        name: 'anh.jpg',
        mimeType: 'image/jpeg',
        kind: AttachmentKind.image,
        source: LocalAttachmentSource('/tmp/does-not-exist.jpg'),
      );
      await tester.pumpWidget(
        testApp(MessageBubble(message: withAttachment(image), isMine: false)),
      );
      await tester.tap(find.bySemanticsLabel('anh.jpg'));
      await tester.pumpAndSettle();
      expect(find.byType(ImageViewerPage), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });
  });

  testWidgets('TypingIndicator shows names and hides when empty', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(TypingIndicator(participants: {agent})));
    expect(find.text('Agent Linh is typing…'), findsOneWidget);

    await tester.pumpWidget(testApp(const TypingIndicator(participants: {})));
    expect(find.textContaining('typing'), findsNothing);
  });
}
