import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'course_detail_screen.dart';

class ExploreCoursesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ExploreCoursesScreen({super.key, this.onBack});

  @override
  State<ExploreCoursesScreen> createState() => _ExploreCoursesScreenState();
}

class _ExploreCoursesScreenState extends State<ExploreCoursesScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Flutter', 'React', 'AI/ML', 'System Design', 'DevOps'];

  final List<_Course> _allCourses = [
    _Course(title: 'Flutter Masterclass', instructor: 'Dr. Angela Yu', lessons: 42, rating: 4.9, students: 12400, price: '\$19.99', color: const Color(0xFF7C3AED), icon: Icons.flutter_dash_rounded, tag: 'Bestseller', category: 'Flutter'),
    _Course(title: 'AI & Machine Learning', instructor: 'Andrew Ng', lessons: 38, rating: 4.8, students: 8900, price: '\$24.99', color: const Color(0xFF6D28D9), icon: Icons.smart_toy_rounded, tag: 'Trending', category: 'AI/ML'),
    _Course(title: 'React Advanced Patterns', instructor: 'Maximilian S.', lessons: 36, rating: 4.7, students: 6200, price: '\$17.99', color: const Color(0xFF5B21B6), icon: Icons.code_rounded, tag: null, category: 'React'),
    _Course(title: 'System Design Bootcamp', instructor: 'Alex Xu', lessons: 30, rating: 4.9, students: 4500, price: '\$29.99', color: const Color(0xFF8B5CF6), icon: Icons.architecture_rounded, tag: 'New', category: 'System Design'),
    _Course(title: 'Docker & Kubernetes', instructor: 'KodeKloud', lessons: 28, rating: 4.6, students: 3800, price: '\$15.99', color: const Color(0xFF7C3AED), icon: Icons.kitchen_rounded, tag: null, category: 'DevOps'),
    _Course(title: 'TypeScript Mastery', instructor: 'The Net Ninja', lessons: 34, rating: 4.5, students: 5100, price: '\$14.99', color: const Color(0xFF6D28D9), icon: Icons.javascript_rounded, tag: null, category: 'React'),
    _Course(title: 'Flutter Animations Deep Dive', instructor: 'Andrea Bizzotto', lessons: 22, rating: 4.8, students: 3200, price: '\$16.99', color: const Color(0xFF5B21B6), icon: Icons.animation_rounded, tag: null, category: 'Flutter'),
    _Course(title: 'MLOps Fundamentals', instructor: 'Google Cloud', lessons: 26, rating: 4.7, students: 2800, price: '\$21.99', color: const Color(0xFF8B5CF6), icon: Icons.science_rounded, tag: null, category: 'AI/ML'),
  ];

  List<_Course> get _filteredCourses {
    if (_selectedFilter == 0) return _allCourses;
    return _allCourses.where((c) => c.category == _filters[_selectedFilter]).toList();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.onBack != null)
                        GestureDetector(
                          onTap: widget.onBack,
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF8B5CF6), size: 22),
                        ),
                      const SizedBox(width: 14),
                      const Text('Explore Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFEDE9FE))),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Text('Search courses, topics, or instructors...', style: TextStyle(fontSize: 13, color: Colors.grey.shade400))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedFilter = i);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_filters[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF6D28D9))),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredCourses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_outlined, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No courses found', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.75),
                      itemCount: _filteredCourses.length,
                      itemBuilder: (ctx, i) => _buildCourseGridCard(_filteredCourses[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseGridCard(_Course course) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(title: course.title, instructor: course.instructor, lessons: course.lessons, completed: 0, color: course.color, icon: course.icon))),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDE9FE), width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [course.color, course.color.withValues(alpha: 0.7)])),
              child: Stack(
                children: [
                  Center(child: Icon(course.icon, color: Colors.white.withValues(alpha: 0.3), size: 40)),
                  if (course.tag != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                        child: Text(course.tag!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.25)),
                  const SizedBox(height: 3),
                  Text(course.instructor, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: const Color(0xFFFBBF24), size: 14),
                      const SizedBox(width: 2),
                      Text('${course.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const Spacer(),
                      Text(course.price, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: course.color)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Course {
  final String title, instructor, price, category;
  final int lessons, students;
  final double rating;
  final Color color;
  final IconData icon;
  final String? tag;
  const _Course({required this.title, required this.instructor, required this.lessons, required this.rating, required this.students, required this.price, required this.color, required this.icon, required this.tag, required this.category});
}
