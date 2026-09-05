import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'session_feedback_screen.dart';


class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({super.key});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  int _activeTab = 0; // 0 = Code Editor, 1 = Problem Prompt
  bool _isMicOn = true;
  bool _isCamOn = true;
  bool _isScreenSharing = false;

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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088CC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 3, backgroundColor: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'LIVE WORKSPACE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Main Viewports and Editor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Video Viewport Row
                    Row(
                      children: [
                        // Viewport 1 (Coach)
                        Expanded(
                          child: _buildVideoViewport(
                            name: 'David Chen (Coach)',
                            imageUrl: 'https://i.pravatar.cc/150?img=11',
                            isActive: true,
                            micIcon: Icons.mic_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Viewport 2 (Candidate)
                        Expanded(
                          child: _buildVideoViewport(
                            name: 'Alex Chen (You)',
                            imageUrl: 'https://i.pravatar.cc/150?img=68',
                            isActive: false,
                            indicatorIcon: Icons.equalizer_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Editor / Prompt workspace tabs card
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          children: [
                            // Tabs Header
                            Row(
                              children: [
                                _buildWorkspaceTab(0, Icons.code_rounded, 'Code Editor'),
                                _buildWorkspaceTab(1, Icons.assignment_outlined, 'Problem Prompt'),
                              ],
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                            // Workspace body
                            Expanded(
                              child: _activeTab == 0 ? _buildCodeEditorView() : _buildProblemPromptView(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Video call controller bar at bottom
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlBtn(
                    icon: _isMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                    isActive: _isMicOn,
                    onTap: () => setState(() => _isMicOn = !_isMicOn),
                  ),
                  const SizedBox(width: 14),
                  _buildControlBtn(
                    icon: _isCamOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                    isActive: _isCamOn,
                    onTap: () => setState(() => _isCamOn = !_isCamOn),
                  ),
                  const SizedBox(width: 14),
                  _buildControlBtn(
                    icon: Icons.screen_share_rounded,
                    isActive: _isScreenSharing,
                    onTap: () => setState(() => _isScreenSharing = !_isScreenSharing),
                  ),
                  const Spacer(),

                  // Leave Button
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SessionFeedbackScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 16),
                      label: const Text(
                        'Leave',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        elevation: 0,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
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

  Widget _buildVideoViewport({
    required String name,
    required String imageUrl,
    required bool isActive,
    IconData? micIcon,
    IconData? indicatorIcon,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Name tag overlay
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  if (isActive) ...[
                    const CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating status icons
          if (micIcon != null)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFF0088CC),
                  shape: BoxShape.circle,
                ),
                child: Icon(micIcon, color: Colors.white, size: 12),
              ),
            ),

          if (indicatorIcon != null)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(indicatorIcon, color: const Color(0xFF10B981), size: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceTab(int index, IconData icon, String label) {
    final selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: selected ? const Color(0xFF0088CC) : Colors.grey.shade400, size: 14),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: selected ? const Color(0xFF0088CC) : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 2,
              color: selected ? const Color(0xFF0088CC) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeEditorView() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'def solve(nums: List[int]) -> int:',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFFF472B6)),
          ),
          SizedBox(height: 4),
          Text(
            '    # Implement the Two-Sum variant logic here',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            '    hash_map = {}',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF229ED9)),
          ),
          SizedBox(height: 12),
          Text(
            '    for i, n in enumerate(nums):',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFFF472B6)),
          ),
          SizedBox(height: 4),
          Text(
            '        diff = target - n',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFFE2E8F0)),
          ),
          SizedBox(height: 4),
          Text(
            '        if diff in hash_map:',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFFF472B6)),
          ),
          SizedBox(height: 4),
          Text(
            '            return [hash_map[diff], i]',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF229ED9)),
          ),
          SizedBox(height: 4),
          Text(
            '        hash_map[n] = i',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF229ED9)),
          ),
          SizedBox(height: 12),
          Text(
            '    return []',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFFF472B6)),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemPromptView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Two-Sum Variant',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          SizedBox(height: 10),
          Text(
            'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\n\nYou can return the answer in any order.',
            style: TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBtn({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8F4FB) : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF0088CC) : Colors.grey.shade500,
          size: 20,
        ),
      ),
    );
  }
}
