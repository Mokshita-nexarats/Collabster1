import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'application_tracking_screen.dart';


class SubmissionDetailsScreen extends StatelessWidget {
  const SubmissionDetailsScreen({super.key});

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
                  const SizedBox(width: 14),
                  const Text(
                    'Submission Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card 1: Job & Status Summary
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
                            Row(
                              children: [
                                Image.network(
                                  'https://img.icons8.com/color/48/adobe-illustrator.png',
                                  width: 36,
                                  height: 36,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Senior Product Designer',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Nexus Systems • San Francisco, CA',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Status Info Box
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ApplicationTrackingScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F4FB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'APPLICATION STATUS',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0088CC),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Applied on: Oct 12, 2026 at 02:30 PM',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 2: Uploaded Documents
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
                            Row(
                              children: [
                                const Text(
                                  'Uploaded Documents',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0088CC),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '1 File',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // PDF doc container
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200, width: 1),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'John_Doe_Resume_Backend..',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '2.4 MB • PDF Document',
                                          style: TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.download_rounded, color: Color(0xFF0088CC), size: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Document preview section
                            Row(
                              children: const [
                                Icon(Icons.remove_red_eye_outlined, color: Colors.grey, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'LIVE DOCUMENT PREVIEW',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Mock representation of resume template
                            Container(
                              height: 280,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200, width: 1),
                              ),
                              child: Stack(
                                children: [
                                  // Text visual representation
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildMockLine(60, 10),
                                              const SizedBox(height: 4),
                                              _buildMockLine(40, 6),
                                            ],
                                          ),
                                          const Spacer(),
                                          const CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Color(0xFFE2E8F0),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      _buildMockLine(double.infinity, 5),
                                      const SizedBox(height: 6),
                                      _buildMockLine(double.infinity, 5),
                                      const SizedBox(height: 6),
                                      _buildMockLine(200, 5),
                                      const SizedBox(height: 20),
                                      _buildMockLine(80, 8),
                                      const SizedBox(height: 10),
                                      _buildMockLine(double.infinity, 5),
                                      const SizedBox(height: 6),
                                      _buildMockLine(180, 5),
                                    ],
                                  ),

                                  // Floating buttons overlay
                                  Positioned(
                                    right: 0,
                                    top: 40,
                                    child: Column(
                                      children: [
                                        _buildZoomBtn(Icons.add_rounded),
                                        const SizedBox(height: 8),
                                        _buildZoomBtn(Icons.remove_rounded),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 3: Profile Answers
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0F9FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.assignment_turned_in_outlined,
                                      color: Color(0xFF0088CC), size: 16),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Profile Answers',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Answer elements
                            _buildAnswerItem('NOTICE PERIOD', '1 Month', false),
                            const SizedBox(height: 12),
                            _buildAnswerItem('EXPECTED SALARY', '\$90,000 / Year', false),
                            const SizedBox(height: 12),
                            _buildAnswerItem('WILLING TO RELOCATE', 'Yes', true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bottom actions
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ApplicationTrackingScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 20),
                          label: const Text(
                            'Review & Enhance',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088CC),
                            elevation: 0,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Revoke Application?'),
                                content: const Text('This will cancel your application for Senior Product Designer at Nexus Systems. This action cannot be undone.'),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Application revoked successfully')),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                    child: const Text('Revoke', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF6B7280), size: 18),
                          label: const Text(
                            'Revoke Application',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE2E8F0),
                            elevation: 0,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // AI Insight note
                      Center(
                        child: Text(
                          'AI Insight: Your profile matches 85% of job requirements.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
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

  Widget _buildMockLine(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  Widget _buildZoomBtn(IconData icon) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.grey.shade600, size: 16),
    );
  }

  Widget _buildAnswerItem(String title, String val, bool hasCheck) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFF0088CC), width: 3),
        ),
      ),
      padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (hasCheck) ...[
                const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF0088CC), size: 14),
                const SizedBox(width: 6),
              ],
              Text(
                val,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
