import '../domain/document_item.dart';

class FakeDocumentRepository implements DocumentRepository {
  static final _demoDocuments = [
    DocumentItem(
      id: 'doc-101',
      title: 'Company Security Guidelines 2026',
      description: 'Standard operational security and compliance policies for mobile users.',
      fileType: 'PDF',
      fileSizeFormatted: '2.4 MB',
      downloadUrl: 'https://example.com/docs/security.pdf',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    DocumentItem(
      id: 'doc-102',
      title: 'AI Usage & Token Policy',
      description: 'Employee guidelines regarding enterprise AI model quotas and compliance.',
      fileType: 'PDF',
      fileSizeFormatted: '1.1 MB',
      downloadUrl: 'https://example.com/docs/ai_policy.pdf',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    DocumentItem(
      id: 'doc-103',
      title: 'Employee Onboarding Manual',
      description:
          'General handbook for new team members and organizational overview.',
      fileType: 'DOCX',
      fileSizeFormatted: '3.8 MB',
      downloadUrl: 'https://example.com/docs/onboarding.docx',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  @override
  Future<List<DocumentItem>> getDocuments() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _demoDocuments;
  }

  @override
  Future<DocumentItem> getDocumentDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _demoDocuments.firstWhere(
      (d) => d.id == id,
      orElse: () => _demoDocuments.first,
    );
  }
}
