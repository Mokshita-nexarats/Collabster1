import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'course_detail_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'In Progress', 'Completed', 'Saved'];

  final List<_Course> _courses = [
    _Course(title: 'Flutter Masterclass', instructor: 'Dr. Angela Yu', lessons: 42, completed: 28, rating: 4.9, color: const Color(0xFF7C3AED), icon: Icons.flutter_dash_rounded, status: 'In Progress'),
    _Course(title: 'Advanced React Patterns', instructor: 'Maximilian Schwarzmuller', lessons: 36, completed: 23, rating: 4.8, color: const Color(0xFF6D28D9), icon: Icons.code_rounded, status: 'In Progress'),
    _Course(title: 'System Design Fundamentals', instructor: 'Alex Xu', lessons: 30, completed: 10, rating: 4.7, color: const Color(0xFF5B21B6), icon: Icons.architecture_rounded, status: 'In Progress'),
    _Course(title: 'Python for Data Science', instructor: 'Jose Portilla', lessons: 48, completed: 48, rating: 4.9, color: const Color(0xFF10B981), icon: Icons.analytics_rounded, status: 'Completed'),
    _Course(title: 'UI/UX Design Bootcamp', instructor: 'Daniel Walter Scott', lessons: 25, completed: 25, rating: 4.6, color: const Color(0xFF10B981), icon: Icons.design_services_rounded, status: 'Completed'),
    _Course(title: 'AWS Cloud Practitioner', instructor: 'Stephane Maarek', lessons: 32, completed: 0, rating: 4.8, color: const Color(0xFFF59E0B), icon: Icons.cloud_rounded, status: 'Saved'),
  ];

  List<_Course> get _filteredCourses {
    if (_selectedFilter == 0) return _courses;
    if (_selectedFilter == 1) return _courses.where((c) => c.status == 'In Progress').toList();
    if (_selectedFilter == 2) return _courses.where((c) => c.status == 'Completed').toList();
    return _courses.where((c) => c.status == 'Saved').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Text('My Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedFilter = i);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_filters[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF6D28D9))),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _filteredCourses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _buildCourseCard(_filteredCourses[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(_Course course) {
    final progress = course.lessons > 0 ? course.completed / course.lessons : 0.0;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(title: course.title, instructor: course.instructor, lessons: course.lessons, completed: course.completed, color: course.color, icon: course.icon))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDE9FE), width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: course.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(course.icon, color: course.color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const SizedBox(height: 3),
                  Text(course.instructor, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFEDE9FE), valueColor: AlwaysStoppedAnimation<Color>(course.color), minHeight: 5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: course.color)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: course.status == 'Completed' ? const Color(0xFFD1FAE5) : course.status == 'Saved' ? const Color(0xFFFEF3C7) : const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(course.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: course.status == 'Completed' ? const Color(0xFF047857) : course.status == 'Saved' ? const Color(0xFFD97706) : const Color(0xFF7C3AED))),
            ),
          ],
        ),
      ),
    );
  }
}

class _Course {
  final String title, instructor;
  final int lessons, completed;
  final double rating;
  final Color color;
  final IconData icon;
  final String status;
  const _Course({required this.title, required this.instructor, required this.lessons, required this.completed, required this.rating, required this.color, required this.icon, required this.status});
}
