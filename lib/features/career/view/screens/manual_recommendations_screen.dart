import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ManualRecommendationsScreen extends StatefulWidget {
  const ManualRecommendationsScreen({super.key});

  @override
  State<ManualRecommendationsScreen> createState() => _ManualRecommendationsScreenState();
}

class _ManualRecommendationsScreenState extends State<ManualRecommendationsScreen> {
  final Set<int> _appliedCards = {};
  final Set<int> _declinedCards = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'Manual Recommendations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable List of Recommendations
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Review and selectively apply AI-\ngenerated improvements to your\nresume.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card 1: EXPERIENCE
                      _RecommendationCard(
                        category: 'EXPERIENCE',
                        currentText:
                            '"Managed a small team of developers to build web applications for various clients."',
                        recommendedText:
                            '"**Spearheaded** a cross-functional team of 6 developers to deliver **enterprise-grade** web applications, resulting in a **25%** increase in operational efficiency** for key clients."',
                        isApplied: _appliedCards.contains(0),
                        isDeclined: _declinedCards.contains(0),
                        onDecline: () => setState(() => _declinedCards.add(0)),
                        onApply: () => setState(() => _appliedCards.add(0)),
                      ),
                      const SizedBox(height: 16),

                      // Card 2: SKILLS
                      _RecommendationCard(
                        category: 'SKILLS',
                        currentText: '"JavaScript, React, CSS, Node.js"',
                        recommendedText:
                            '"**Full-Stack Development**: JavaScript (ES6+), **React.js**, Node.js, **Tailwind CSS**, and **Scalable System Design**."',
                        isApplied: _appliedCards.contains(1),
                        isDeclined: _declinedCards.contains(1),
                        onDecline: () => setState(() => _declinedCards.add(1)),
                        onApply: () => setState(() => _appliedCards.add(1)),
                      ),
                      const SizedBox(height: 16),

                      // Card 3: SUMMARY
                      _RecommendationCard(
                        category: 'SUMMARY',
                        currentText:
                            '"A motivated developer looking for new opportunities to grow and learn in a fast-paced environment."',
                        recommendedText:
                            '"**Results-driven** Software Engineer with **4+ years of experience** specializing in building high-performance SaaS solutions. **Passionate** about optimizing user experiences** and leading high-impact technical projects."',
                        isApplied: _appliedCards.contains(2),
                        isDeclined: _declinedCards.contains(2),
                        onDecline: () => setState(() => _declinedCards.add(2)),
                        onApply: () => setState(() => _appliedCards.add(2)),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Bottom Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Text(
                    'Save & Update Resume',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  label: const Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                    size: 18,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String category;
  final String currentText;
  final String recommendedText;
  final bool isApplied;
  final bool isDeclined;
  final VoidCallback? onDecline;
  final VoidCallback? onApply;

  const _RecommendationCard({
    required this.category,
    required this.currentText,
    required this.recommendedText,
    this.isApplied = false,
    this.isDeclined = false,
    this.onDecline,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Category Header
          Text(
            category,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088CC),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          // Current Text Section
          const Text(
            'CURRENT TEXT',
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Recommended Text Section
          const Text(
            'RECOMMENDED TEXT',
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: RichText(
              text: _parseFormatting(recommendedText),
            ),
          ),
          const SizedBox(height: 14),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isApplied || isDeclined ? null : onDecline,
                child: Text(
                  isDeclined ? 'Declined' : 'Decline',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDeclined ? Colors.red.shade300 : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: isApplied || isDeclined ? null : onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isApplied ? const Color(0xFF10B981) : const Color(0xFF0088CC),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  isApplied ? 'Applied' : 'Apply Change',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Parse double asterisks "**" for inline bold text styling
  TextSpan _parseFormatting(String text) {
    final List<TextSpan> spans = [];
    final List<String> parts = text.split('**');

    for (int i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF111827) : const Color(0xFF4B5563),
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
