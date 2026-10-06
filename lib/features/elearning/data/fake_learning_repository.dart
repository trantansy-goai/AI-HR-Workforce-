import '../domain/learning_course.dart';

class FakeLearningRepository implements LearningRepository {
  static final _courses = [
    const LearningCourse(
      id: 'course-1',
      title: 'Enterprise AI & Security Compliance 101',
      description: 'Learn company standards for prompt hygiene, data privacy, and secure API operations.',
      category: 'Compliance',
      lessonCount: 5,
      completionPercentage: 1.0,
      isCompleted: true,
    ),
    const LearningCourse(
      id: 'course-2',
      title: 'Prompt Engineering for Business Productivity',
      description: 'Master structured prompting techniques to streamline daily workflow and report generation.',
      category: 'AI Skills',
      lessonCount: 8,
      completionPercentage: 0.4,
      isCompleted: false,
    ),
    const LearningCourse(
      id: 'course-3',
      title: 'Information Safety & Phishing Awareness',
      description:
          'Essential cyber security training for all company employees.',
      category: 'Security',
      lessonCount: 4,
      completionPercentage: 0.0,
      isCompleted: false,
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
