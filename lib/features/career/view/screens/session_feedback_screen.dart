import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SessionFeedbackScreen extends StatefulWidget {
  const SessionFeedbackScreen({super.key});

  @override
  State<SessionFeedbackScreen> createState() => _SessionFeedbackScreenState();
}

class _SessionFeedbackScreenState extends State<SessionFeedbackScreen> {
  int _stars = 0;

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
                    'Feedback',
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
                      // Card 1: Overall Score circle
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Overall Score',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Circle indicator
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    value: 0.78,
                                    strokeWidth: 9,
                                    backgroundColor: Colors.grey.shade100,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0088CC)),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      '7.8',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Text(
                                      'out of 10',
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'Strong performance! You are in the top 15% of candidates for this role.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 2: Competency Breakdown
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
                              'Competency Breakdown',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 16),

                            _buildProgressRow('Technical Accuracy', 7, 10),
                            const SizedBox(height: 12),
                            _buildProgressRow('Communication', 8, 10),
                            const SizedBox(height: 12),
                            _buildProgressRow('Problem Solving', 9, 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 3: What You Did Well
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border(
                            left: const BorderSide(color: Color(0xFF0088CC), width: 4),
                            top: BorderSide(color: Colors.grey.shade100, width: 1.2),
                            right: BorderSide(color: Colors.grey.shade100, width: 1.2),
                            bottom: BorderSide(color: Colors.grey.shade100, width: 1.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.check_circle_rounded, color: Color(0xFF0088CC), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'What You Did Well',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            _buildBulletItem(Icons.check_rounded, const Color(0xFF0088CC),
                                'Strong structural explanation of the algorithm before diving into the code.'),
                            const SizedBox(height: 10),
                            _buildBulletItem(Icons.check_rounded, const Color(0xFF0088CC),
                                'Clean code syntax and appropriate naming conventions throughout.'),
                            const SizedBox(height: 10),
                            _buildBulletItem(Icons.check_rounded, const Color(0xFF0088CC),
                                'Excellent response to edge case probing for large data sets.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 4: Areas to Improve
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border(
                            left: const BorderSide(color: Color(0xFFEF4444), width: 4),
                            top: BorderSide(color: Colors.grey.shade100, width: 1.2),
                            right: BorderSide(color: Colors.grey.shade100, width: 1.2),
                            bottom: BorderSide(color: Colors.grey.shade100, width: 1.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Areas to Improve',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            _buildBulletItem(Icons.close_rounded, const Color(0xFFEF4444),
                                'Verbally explain time complexity earlier in the session.'),
                            const SizedBox(height: 10),
                            _buildBulletItem(Icons.close_rounded, const Color(0xFFEF4444),
                                'Avoid long periods of silence while writing helper functions.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Filler Words & Pacing Metrics Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildFillerWordCard(),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildPacingCard(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card 5: Timeline Bookmarks
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
                              'Timeline Bookmarks',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 16),

                            _buildBookmarkRow('04:12', 'Coding Started'),
                            const SizedBox(height: 10),
                            _buildBookmarkRow('12:30', 'Space Complexity Analysis'),
                            const SizedBox(height: 10),
                            _buildBookmarkRow('22:45', 'Behavioral Q2'),
                            const SizedBox(height: 10),
                            _buildBookmarkRow('34:10', 'Final Wrap-up'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 6: Target Practice Dynamic Programming
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088CC),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'RECOMMENDED NEXT STEP',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Target Practice: Dynamic Programming',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF006699),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Based on your session, focusing on sub-problem identification in DP will boost your technical score by 15%.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF006699),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Start Practice button
                            SizedBox(
                              height: 38,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0088CC),
                                  elevation: 0,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Start Practice',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 7: How was your AI Session? feedback form
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'How was your AI Session?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final selected = _stars > index;
                                return GestureDetector(
                                  onTap: () => setState(() => _stars = index + 1),
                                  child: Icon(
                                    selected ? Icons.star_rounded : Icons.star_outline_rounded,
                                    color: selected ? const Color(0xFFFBBF24) : Colors.grey.shade300,
                                    size: 32,
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),

                            // Textfield input
                            Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200, width: 1),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const TextField(
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Share any feedback anonymously...',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Submit button
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0088CC),
                                  elevation: 0,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Feedback',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
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

  Widget _buildProgressRow(String label, int val, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
            Text(
              '$val/$total',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: val / total,
            minHeight: 6,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0088CC)),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletItem(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 10),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFillerWordCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filler Word Tracker',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('"Um"', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const Text('14', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0088CC))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('"Like"', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const Text('8', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0088CC))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPacingCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pacing Meter',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 12),
          const Text(
            '135 WPM',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
          ),
          const SizedBox(height: 2),
          Text(
            'Perfect Pacing',
            style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkRow(String time, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4FB),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088CC),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}
