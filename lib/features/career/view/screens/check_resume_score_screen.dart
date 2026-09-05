import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import 'ats_score_screen.dart';

class CheckResumeScoreScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const CheckResumeScoreScreen({super.key, this.onBack});

  @override
  ConsumerState<CheckResumeScoreScreen> createState() => _CheckResumeScoreScreenState();
}

class _CheckResumeScoreScreenState extends ConsumerState<CheckResumeScoreScreen> {
  bool _hasSelectedFile = false;
  String _selectedFileName = 'Alex_Senior_Designer_Resume.pdf';

  void _pickFile() {
    setState(() {
      _hasSelectedFile = true;
      _selectedFileName = 'Alex_Senior_Designer_Resume.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selected "Alex_Senior_Designer_Resume.pdf" for ATS Analysis!'),
        backgroundColor: Color(0xFF0088CC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Alex Rivera';
    final userInitials = userName.isNotEmpty ? userName.split(' ').map((e) => e.isEmpty ? '' : e[0]).take(2).join() : 'AR';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0088CC)),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Check Resume Score',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0088CC)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF0088CC),
              child: Text(
                userInitials,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. AI Resume Analysis Section Header
              Row(
                children: const [
                  Icon(Icons.auto_awesome_rounded, color: Color(0xFF0088CC), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'AI Resume Analysis',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0088CC),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Our advanced AI evaluates your resume against industry benchmarks for ATS score, keywords, and formatting to help you land your dream job.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),

              // 2. Browse Files Dashed Container Box
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF0088CC),
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0088CC).withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F4FB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_upload_rounded,
                          color: Color(0xFF0088CC),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _hasSelectedFile ? _selectedFileName : 'Browse Files',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Support for PDF, DOC, DOCX',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Max file size: 5MB',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0088CC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Check Score Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ATSScoreScreen()),
                    );
                  },
                  icon: const Icon(Icons.bar_chart_rounded, size: 20),
                  label: const Text('Check Score'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088CC),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Why ATS Matters Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: 0.85,
                            strokeWidth: 5,
                            backgroundColor: const Color(0xFFE8F4FB),
                            color: const Color(0xFF0088CC),
                          ),
                        ),
                        const Text(
                          '85%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0088CC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Why ATS Matters',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '75% of resumes are rejected by ATS before they reach a human recruiter.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. Pro Tip Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8F4FB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0088CC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'PRO TIP',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Use active verbs and quantifiable metrics to boost your ATS compatibility by up to 40%.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF006699),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
