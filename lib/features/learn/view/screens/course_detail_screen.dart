import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseDetailScreen extends StatefulWidget {
  final String title, instructor;
  final int lessons, completed;
  final Color color;
  final IconData icon;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.instructor,
    required this.lessons,
    required this.completed,
    required this.color,
    required this.icon,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late int _completed = widget.completed.clamp(0, widget.lessons);

  static const List<_Module> _modules = [
    _Module(title: 'Getting Started', lessons: ['Introduction', 'Setup & Installation', 'Your First App']),
    _Module(title: 'Core Concepts', lessons: ['Widgets & Layouts', 'State Management', 'Navigation', 'Forms & Validation']),
    _Module(title: 'Advanced Topics', lessons: ['Animations', 'Custom Painters', 'Platform Integration', 'Testing']),
    _Module(title: 'Production', lessons: ['Performance Optimization', 'CI/CD Setup', 'App Store Deployment']),
  ];

  List<String> get _allLessons => [for (final m in _modules) ...m.lessons];

  bool _moduleComplete(int moduleIndex) => _completed >= _moduleStartIndex(moduleIndex + 1);

  int _moduleStartIndex(int moduleIndex) {
    int start = 0;
    for (var i = 0; i < moduleIndex; i++) {
      start += _modules[i].lessons.length;
    }
    return start;
  }

  void _openLessonPlayer({required int startIndex}) async {
    HapticFeedback.lightImpact();
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => _LessonPlayerScreen(
          courseTitle: widget.title,
          lessons: _allLessons,
          startIndex: startIndex.clamp(0, _allLessons.length - 1),
          completedCount: _completed,
          color: widget.color,
        ),
      ),
    );
    if (result != null && mounted) setState(() => _completed = result);
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.lessons > 0 ? _completed / widget.lessons : 0.0;
    final isDone = _completed >= widget.lessons;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [widget.color, widget.color.withValues(alpha: 0.8)]),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                        child: Icon(widget.icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 16),
                      Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('by ${widget.instructor}', style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _statChip(Icons.access_time_rounded, '${widget.lessons} lessons'),
                          const SizedBox(width: 12),
                          _statChip(Icons.bar_chart_rounded, '${(progress * 100).toInt()}% complete'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(value: progress, backgroundColor: widget.color.withValues(alpha: 0.15), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6),
                ),
                const SizedBox(height: 24),
                ...List.generate(_modules.length, (i) {
                  return GestureDetector(
                    onTap: () => _openLessonPlayer(startIndex: _moduleStartIndex(i)),
                    child: _buildModuleCard(_modules[i], i + 1),
                  );
                }),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: isDone ? null : () => _openLessonPlayer(startIndex: _completed),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isDone ? Colors.grey.shade400 : widget.color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(isDone ? 'Course Completed!' : 'Continue Learning', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 14),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
      ],
    );
  }

  Widget _buildModuleCard(_Module module, int moduleNum) {
    final done = _moduleComplete(moduleNum - 1);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: done ? const Color(0xFFD1FAE5) : const Color(0xFFEDE9FE), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: done ? const Color(0xFF10B981) : widget.color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(done ? Icons.check_rounded : Icons.play_arrow_rounded, color: done ? Colors.white : widget.color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('Module $moduleNum: ${module.title}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)))),
            ],
          ),
          const SizedBox(height: 10),
          ...module.lessons.map((lesson) => Padding(
            padding: const EdgeInsets.only(left: 38, bottom: 6),
            child: Row(
              children: [
                Icon(Icons.circle, size: 6, color: Colors.grey.shade300),
                const SizedBox(width: 8),
                Expanded(child: Text(lesson, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _LessonPlayerScreen extends StatefulWidget {
  final String courseTitle;
  final List<String> lessons;
  final int startIndex;
  final int completedCount;
  final Color color;

  const _LessonPlayerScreen({
    required this.courseTitle,
    required this.lessons,
    required this.startIndex,
    required this.completedCount,
    required this.color,
  });

  @override
  State<_LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<_LessonPlayerScreen> {
  late int _index;
  late int _completed;

  @override
  void initState() {
    super.initState();
    _index = widget.startIndex;
    _completed = widget.completedCount > _index ? widget.completedCount : _index;
  }

  bool get _isLast => _index >= widget.lessons.length - 1;
  double get _progress => _completed / widget.lessons.length;

  void _markCompleteAndContinue() {
    HapticFeedback.mediumImpact();
    if (_completed <= _index) _completed = _index + 1;
    if (!_isLast) {
      setState(() => _index += 1);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Course Completed!', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('You finished all ${widget.lessons.length} lessons of "${widget.courseTitle}". Your certificate is on its way.', style: const TextStyle(fontSize: 13.5, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, _completed);
            },
            child: Text('Done', style: TextStyle(color: widget.color, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessonTitle = widget.lessons[_index];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, _completed),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.courseTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                        Text('Lesson ${_index + 1} of ${widget.lessons.length}', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: _progress, backgroundColor: const Color(0xFFEDE9FE), valueColor: AlwaysStoppedAnimation<Color>(widget.color), minHeight: 6),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [widget.color, widget.color.withValues(alpha: 0.75)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 14,
                      left: 16,
                      right: 16,
                      child: Text('Lesson ${_index + 1}: $lessonTitle', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 38),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('About this lesson', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  'In "$lessonTitle" we walk through the key ideas step by step with practical examples you can follow along in your editor. By the end you will be able to apply these concepts directly in your own projects.',
                  style: TextStyle(fontSize: 13, height: 1.55, color: Colors.grey.shade600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _markCompleteAndContinue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(14)),
                    child: Text(
                      _isLast ? 'Mark Complete & Finish' : 'Mark Complete & Continue',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Module {
  final String title;
  final List<String> lessons;
  const _Module({required this.title, required this.lessons});
}
