import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'coding_session_screen.dart';
import 'session_review_screen.dart';

class InterviewSessionScreen extends StatefulWidget {
  const InterviewSessionScreen({super.key});

  @override
  State<InterviewSessionScreen> createState() => _InterviewSessionScreenState();
}

class _InterviewSessionScreenState extends State<InterviewSessionScreen> {
  bool _hintRevealed = false;

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
                  const Icon(
                    Icons.pause_rounded,
                    color: Color(0xFF111827),
                    size: 22,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Mock Interview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Time Elapsed Badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F9FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Elapsed Time: 02:45',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0088CC),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Question Card
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088CC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    'BEHAVIORAL QUESTION',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '"Tell me about a time you handled a difficult stakeholder conflict."',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() => _hintRevealed = !_hintRevealed);
                              },
                              icon: Icon(Icons.lightbulb_outline_rounded,
                                  color: const Color(0xFF0088CC), size: 16),
                              label: Text(
                                _hintRevealed ? 'Hide Hint' : 'Reveal Hint',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0088CC)),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF0F9FF),
                                minimumSize: const Size(140, 38),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                setState(() => _hintRevealed = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Question reloaded'), duration: Duration(seconds: 1)),
                                );
                              },
                              icon: const Icon(Icons.refresh_rounded,
                                  color: Colors.grey, size: 16),
                              label: const Text(
                                'Retry Question',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Structure Tip Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Left sky blue accent line
                                Container(
                                  width: 4,
                                  color: const Color(0xFF0088CC),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.lightbulb_outline_rounded,
                                            color: Color(0xFF0088CC), size: 20),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Structure Tip',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF111827),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Try using the STAR method (Situation, Task, Action, Result) to structure your response. It helps keep your story concise and outcome-oriented.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Live Feedback Card
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
                              children: const [
                                Icon(Icons.bar_chart_rounded,
                                    color: Color(0xFF0088CC), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Live Feedback',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0088CC),
                                  ),
                                ),
                                Spacer(),
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(0xFF0088CC),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Feedback Point 1
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(Icons.check_circle_outline_rounded,
                                      color: Color(0xFF10B981), size: 16),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Great start! You're clearly defining the situation and identifying the key players involved.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF047857),
                                        height: 1.4,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Feedback Point 2
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F9FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(Icons.arrow_circle_right_outlined,
                                      color: Color(0xFF0088CC), size: 16),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Next: Try to emphasize your specific Actions. What steps did you take to resolve the tension?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0088CC),
                                        height: 1.4,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Voice Intensity Visualizer
                            const Text(
                              'VOICE INTENSITY',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildVisualizerBar(12),
                                _buildVisualizerBar(8),
                                _buildVisualizerBar(16),
                                _buildVisualizerBar(28),
                                _buildVisualizerBar(36),
                                _buildVisualizerBar(20),
                                _buildVisualizerBar(14),
                                _buildVisualizerBar(8),
                                _buildVisualizerBar(6),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Bottom AI Coach indicator
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0F9FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.mic_none_rounded,
                                      color: Color(0xFF0088CC), size: 16),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AI Coach is listening...',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
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

            // Outlined Actions Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Stop & Submit?'),
                            content: const Text('Are you sure you want to end this mock interview session? Your responses will be submitted for review.'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const SessionReviewScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0088CC)),
                                child: const Text('Submit', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.stop_circle_outlined,
                          color: Color(0xFF0088CC), size: 18),
                      label: const Text(
                        'Stop & Submit',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0088CC)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE8F4FB), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CodingSessionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 16),
                      label: const Text(
                        'Next Question',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizerBar(double height) {
    return Container(
      width: 14,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF229ED9).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
