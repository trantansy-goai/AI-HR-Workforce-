import 'package:equatable/equatable.dart';

class DocumentItem extends Equatable {
  const DocumentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.fileType,
    required this.fileSizeFormatted,
    required this.downloadUrl,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String fileType;
  final String fileSizeFormatted;
  final String downloadUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    fileType,
    fileSizeFormatted,
    downloadUrl,
    createdAt,
  ];
}

abstract interface class DocumentRepository {
  Future<List<DocumentItem>> getDocuments();
  Future<DocumentItem> getDocumentDetail(String id);

  /// Saves the file on this device and returns its path.
  Future<String> download(DocumentItem document);
}
