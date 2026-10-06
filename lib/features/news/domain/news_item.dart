import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedAt,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final DateTime publishedAt;
  final String? imageUrl;

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    content,
    publishedAt,
    imageUrl,
  ];
}

abstract interface class NewsRepository {
  Future<List<NewsItem>> getNews();
  Future<NewsItem> getNewsDetail(String id);
}
