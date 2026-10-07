import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedAt,
    this.imageUrl,
    this.tags = const [],
    this.byline,
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final DateTime publishedAt;
  final String? imageUrl;

  /// Audience/owner tags used to filter (e.g. a site or department).
  /// Empty means the item is for everyone.
  final List<String> tags;

  /// Who approved/owns the item, shown before the date.
  final String? byline;

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    content,
    publishedAt,
    imageUrl,
    tags,
    byline,
  ];
}

abstract interface class NewsRepository {
  Future<List<NewsItem>> getNews();
  Future<NewsItem> getNewsDetail(String id);
}
