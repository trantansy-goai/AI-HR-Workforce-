import 'dart:async';

import '../domain/attachment.dart';
import '../domain/file_services.dart';

/// Platform-agnostic file picker service adapter.
class DefaultFilePickerService implements AttachmentPicker {
  DefaultFilePickerService({this.shouldCancel = false, this.simulatedFiles});

  final bool shouldCancel;
  final List<Attachment>? simulatedFiles;

  @override
  Future<List<Attachment>> pick({Set<AttachmentKind>? kinds}) async {
    if (shouldCancel) {
      return const []; // User cancelled picker
    }

    if (simulatedFiles != null) {
      return simulatedFiles!;
    }

    // Default development picked file fixture
    final now = DateTime.now();
    final fileId = 'picked-${now.millisecondsSinceEpoch}';
    return [
      Attachment(
        id: fileId,
        name: 'Onboarding_Guidelines.pdf',
        mimeType: 'application/pdf',
        kind: AttachmentKind.document,
        source: LocalAttachmentSource(
          '/tmp/picked_document_${now.millisecondsSinceEpoch}.pdf',
        ),
        sizeBytes: 1548576,
      ),
    ];
  }
}
