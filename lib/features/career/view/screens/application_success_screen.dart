import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'mock_interviews_screen.dart';
import 'jobs_screen.dart';

class ApplicationSuccessScreen extends StatefulWidget {
  const ApplicationSuccessScreen({super.key});

  @override
  State<ApplicationSuccessScreen> createState() => _ApplicationSuccessScreenState();
}

class _ApplicationSuccessScreenState extends State<ApplicationSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Green circular checkmark
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD1FAE5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF10B981),
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // SUCCESS Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'SUCCESS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Application Submitted Title
                      const Text(
                        'Application Submitted!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subtext with bold email
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(text: "We've sent a confirmation email to "),
                            TextSpan(
                              text: 'alex.j@example.com',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0088CC),
                              ),
                            ),
                            TextSpan(text: '. You can track your application status in your dashboard.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 38,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0088CC),
                                elevation: 0,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Go to Dashboard',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 38,
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Opening PDF viewer...')),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF0088CC), width: 1.2),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'View PDF Copy',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0088CC),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Card 1: What to Expect Next
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'What to Expect Next',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Step 1
                            _buildExpectStep(
                              isCompleted: true,
                              title: 'Application Review',
                              badgeText: 'IN PROGRESS',
                              badgeColor: const Color(0xFFD1FAE5),
                              badgeTextColor: const Color(0xFF047857),
                              desc: 'The hiring team at Nexus Systems is reviewing your experience.',
                            ),
                            const SizedBox(height: 14),

                            // Step 2
                            _buildExpectStep(
                              isCompleted: false,
                              title: 'Initial Screening Call',
                              desc: 'Expected within 5-7 business days via Phone or Google Meet.',
                            ),
                            const SizedBox(height: 14),

                            // Step 3
                            _buildExpectStep(
                              isCompleted: false,
                              title: 'Technical Assessment / Interview',
                              desc: 'A deep dive into your portfolio and problem-solving skills.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 2: Get Ready for the Interview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088CC),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Auto Generated Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white54, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Auto-Generated',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Get Ready for the\nInterview',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Based on your application to Nexus Systems, we recommend practicing with our tailored mock track.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => MockInterviewsScreen(onBack: () => Navigator.pop(context))));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Start Nexus Systems Mock Track',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0088CC),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: Color(0xFF0088CC), size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Similar Roles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Similar Roles for You',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Row(
                            children: [
                              _buildCircleArrow(Icons.keyboard_arrow_left_rounded),
                              const SizedBox(width: 8),
                              _buildCircleArrow(Icons.keyboard_arrow_right_rounded),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Horizontal Scroll list of similar cards
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildSimilarRoleCard(
                              logoUrl: 'https://img.icons8.com/color/48/adobe-illustrator.png',
                              title: 'Senior UI Designer',
                              location: 'Remote',
                            ),
                            const SizedBox(width: 12),
                            _buildSimilarRoleCard(
                              logoUrl: 'https://img.icons8.com/color/48/figma--v1.png',
                              title: 'Lead Product Designer',
                              location: 'Hybrid',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Skills increase rate footer card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade100, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F4FB),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.trending_up_rounded,
                                  color: Color(0xFF0088CC), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF334155),
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(text: 'Want to '),
                                    TextSpan(
                                      text: 'increase your response rate by 35%?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B)),
                                    ),
                                    TextSpan(text: ' Complete your skills profile.'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Update Profile Skills',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0088CC),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectStep({
    required bool isCompleted,
    required String title,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkmark indicator circle
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFFD1FAE5) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? Colors.transparent : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 14)
                  : null,
            ),
          ],
        ),
        const SizedBox(width: 12),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  if (badgeText != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleArrow(IconData icon) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.grey.shade600, size: 16),
    );
  }

  Widget _buildSimilarRoleCard({
    required String logoUrl,
    required String title,
    required String location,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(logoUrl, width: 28, height: 28),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.grey.shade400, size: 12),
              const SizedBox(width: 2),
              Text(
                location,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0F9FF),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Quick Apply',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0088CC),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
