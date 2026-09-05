import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'session_review_screen.dart';


class CodingSessionScreen extends StatefulWidget {
  const CodingSessionScreen({super.key});

  @override
  State<CodingSessionScreen> createState() => _CodingSessionScreenState();
}

class _CodingSessionScreenState extends State<CodingSessionScreen> {
  int _selectedSampleTab = 0; // 0 = Sample 1, 1 = Sample 2, 2 = Custom

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
                    'Coding Assessment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Time Remaining Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8F4FB), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.access_time_rounded,
                        color: Color(0xFF0088CC), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'TIME REMAINING: 42:15',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0088CC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Workspace Layout
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card 1: Problem Details
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4FB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.code_rounded, color: Color(0xFF0088CC), size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    'ALGORITHM: MEDIUM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0088CC),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Longest Contiguous Subarray',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(
                                      text:
                                          'Given an array of integers, find the length of the longest contiguous subarray with a sum equal to '),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'k',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(text: '. Return 0 if no such subarray exists.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Limits Row
                            Row(
                              children: [
                                Icon(Icons.speed_rounded,
                                    color: Colors.grey.shade400, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Time Limit: 2.0s',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Icon(Icons.dns_outlined,
                                    color: Colors.grey.shade400, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Memory Limit: 256MB',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // WORKSPACE Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'WORKSPACE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374151),
                              letterSpacing: 0.8,
                            ),
                          ),
                          Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Python 3.10',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.keyboard_arrow_down_rounded,
                                    color: Colors.grey.shade600, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Helper buttons list
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildHelperChip('{ }'),
                            _buildHelperChip('( )'),
                            _buildHelperChip('[ ]'),
                            _buildHelperChip(';'),
                            _buildHelperChip('-'),
                            _buildHelperChip('='),
                            _buildHelperChip(':'),
                            _buildHelperChip('tab'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Code Editor container
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2E),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            // Mock window top bar
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  _buildCircleDot(Colors.red),
                                  const SizedBox(width: 6),
                                  _buildCircleDot(Colors.amber),
                                  const SizedBox(width: 6),
                                  _buildCircleDot(Colors.green),
                                  const Spacer(),
                                  const Text(
                                    'solution.py',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white10, height: 1, thickness: 1),

                            // Mock code editor body
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Line numbers
                                  const Text(
                                    '1\n2\n3\n4\n5\n6\n7',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white24,
                                      fontFamily: 'monospace',
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Code lines
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                          height: 1.6,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: 'def ',
                                              style: TextStyle(color: Color(0xFFF43F5E))),
                                          TextSpan(
                                              text: 'solve',
                                              style: TextStyle(color: Color(0xFF229ED9))),
                                          TextSpan(
                                              text: '(nums: List[int], k: int) -> int:\n',
                                              style: TextStyle(color: Colors.white)),
                                          TextSpan(
                                              text: '    """\n',
                                              style: TextStyle(color: Color(0xFF34D399))),
                                          TextSpan(
                                              text: '    Finds the longest contiguous\n',
                                              style: TextStyle(color: Color(0xFF34D399))),
                                          TextSpan(
                                              text: '    subarray with sum k.\n',
                                              style: TextStyle(color: Color(0xFF34D399))),
                                          TextSpan(
                                              text: '    # Write your solution here\n',
                                              style: TextStyle(color: Colors.white38)),
                                          TextSpan(
                                              text: '    pass\n',
                                              style: TextStyle(color: Color(0xFFF43F5E))),
                                          TextSpan(
                                              text: '    ',
                                              style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // TEST RESULTS Section title
                      const Text(
                        'TEST RESULTS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF374151),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Test results container card
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
                            // Compiled successfully banner
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD1FAE5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_rounded,
                                      color: Color(0xFF10B981), size: 12),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Code compiled successfully.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Execution:\n0.12s',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade500,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Sample Tabs
                            Row(
                              children: [
                                _buildSampleTab(0, 'Sample 1'),
                                _buildSampleTab(1, 'Sample 2'),
                                _buildSampleTab(2, '+ Custom'),
                              ],
                            ),
                            const Divider(color: Color(0xFFE8F4FB), height: 1, thickness: 1.2),
                            const SizedBox(height: 16),

                            // INPUT
                            const Text(
                              'INPUT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9FB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'nums = [1, -1, 5, -2, 3], k = 3',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // EXPECTED OUTPUT
                            const Text(
                              'EXPECTED OUTPUT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9FB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '4',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // YOUR OUTPUT
                            const Text(
                              'YOUR OUTPUT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '4',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF047857),
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

            // Bottom Buttons Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Running code against test cases...'), duration: Duration(seconds: 2)),
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded,
                            color: Color(0xFF0088CC), size: 18),
                        label: const Text(
                          'Run Code',
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
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SessionReviewScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Submit Solution',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

  Widget _buildHelperChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'monospace',
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildCircleDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSampleTab(int index, String title) {
    final selected = _selectedSampleTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedSampleTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: selected
              ? const Border(
                  bottom: BorderSide(color: Color(0xFF0088CC), width: 2))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? const Color(0xFF0088CC) : Colors.grey,
              ),
            ),
            if (index < 2) ...[
              const SizedBox(width: 4),
              const CircleAvatar(
                radius: 3.5,
                backgroundColor: Color(0xFF10B981),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
