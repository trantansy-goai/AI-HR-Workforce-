import '../domain/learning_course.dart';

class FakeLearningRepository implements LearningRepository {
  static final _courses = [
    LearningCourse(
      id: 'course-1',
      title: 'An toàn lao động cơ bản',
      description: 'Nhận diện mối nguy, sử dụng bảo hộ và quy trình xử lý sự cố tại nhà máy.',
      category: 'An toàn',
      lessonCount: 6,
      completionPercentage: 0.4,
      isCompleted: false,
      isMandatory: true,
      dueDate: DateTime(2026, 10, 12),
      format: CourseFormat.video,
      durationMinutes: 12,
      quizQuestionCount: 8,
    ),
    const LearningCourse(
      id: 'course-2',
      title: 'Quy tắc ứng xử tại nhà máy',
      description:
          'Chuẩn mực giao tiếp, giờ giấc và an ninh ra vào khu vực sản xuất.',
      category: 'Văn hóa',
      lessonCount: 8,
      completionPercentage: 0.0,
      isCompleted: false,
      format: CourseFormat.document,
      durationMinutes: 6,
    ),
    const LearningCourse(
      id: 'course-3',
      title: 'Bảo mật thông tin & nhận diện lừa đảo',
      description: 'Đào tạo an ninh thông tin bắt buộc cho toàn bộ nhân viên.',
      category: 'Bảo mật',
      lessonCount: 4,
      completionPercentage: 1.0,
      isCompleted: true,
      format: CourseFormat.document,
      durationMinutes: 10,
    ),
  ];

  @override
  Future<List<LearningCourse>> getCourses() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _courses;
  }

  @override
  Future<LearningCourse> getCourseDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _courses.firstWhere((c) => c.id == id, orElse: () => _courses.first);
  }
}
