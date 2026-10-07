import '../domain/news_item.dart';

class FakeNewsRepository implements NewsRepository {
  static final _news = [
    NewsItem(
      id: 'news-1',
      title: 'Thông điệp từ Ban điều hành',
      summary: 'Định hướng quý IV và cảm ơn tập thể nhân viên.',
      content: 'Ban điều hành gửi lời cảm ơn tới toàn thể nhân viên và chia sẻ định hướng ưu tiên quý IV: an toàn, chất lượng và phát triển con người.',
      publishedAt: DateTime(2026, 10, 7, 8),
      byline: 'Đã duyệt bởi người được ủy quyền',
    ),
    NewsItem(
      id: 'news-2',
      title: 'Lịch khám sức khỏe định kỳ',
      summary: 'Khám sức khỏe định kỳ năm 2026 cho nhân viên Nhà máy A.',
      content: 'Nhân viên Nhà máy A khám sức khỏe định kỳ theo lịch từng bộ phận. Vui lòng mang CCCD và nhịn ăn sáng.',
      publishedAt: DateTime(2026, 10, 6, 9),
      tags: const ['Nhà máy A', 'HR'],
      byline: 'Chủ sở hữu: HR',
    ),
    NewsItem(
      id: 'news-3',
      title: 'Cập nhật tuyến xe đưa đón',
      summary: 'Điều chỉnh điểm đón tuyến 2 và tuyến 5 từ tuần sau.',
      content: 'Từ tuần sau, tuyến 2 và tuyến 5 điều chỉnh điểm đón để rút ngắn thời gian di chuyển. Chi tiết xem bảng tuyến mới.',
      publishedAt: DateTime(2026, 10, 4, 7),
      tags: const ['Nhà máy A'],
      byline: 'Chủ sở hữu: Hành chính',
    ),
  ];

  @override
  Future<List<NewsItem>> getNews() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _news;
  }

  @override
  Future<NewsItem> getNewsDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _news.firstWhere((n) => n.id == id, orElse: () => _news.first);
  }
}
