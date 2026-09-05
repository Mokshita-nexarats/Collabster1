import 'package:flutter/material.dart';

class MentorReviewsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const MentorReviewsScreen({super.key, this.onBack});

  final List<_Review> _reviews = const [
    _Review(mentee: 'Priya Sharma', rating: 5, comment: 'Amazing mentor! Helped me understand Flutter state management in just 2 sessions. Highly recommend!', date: '2 days ago', topic: 'Flutter State Management'),
    _Review(mentee: 'Alex Chen', rating: 5, comment: 'Very insightful system design review. Clear explanations and practical examples.', date: '1 week ago', topic: 'System Design'),
    _Review(mentee: 'Marcus Lee', rating: 4, comment: 'Great code review session. Learned a lot about best practices and clean architecture.', date: '2 weeks ago', topic: 'Code Review'),
    _Review(mentee: 'David Kim', rating: 5, comment: 'Career guidance was exactly what I needed. Helped me plan my next steps clearly.', date: '3 weeks ago', topic: 'Career Guidance'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF14B8A6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingSummary(),
                    const SizedBox(height: 24),
                    const Text('Recent Reviews', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    ..._reviews.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildReviewCard(r),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Column(
            children: [
              const Text('4.9', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Color(0xFF0D9488))),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (i) => Icon(i < 4 ? Icons.star_rounded : Icons.star_half_rounded, color: const Color(0xFFFBBF24), size: 18)),
              ),
              const SizedBox(height: 4),
              Text('${_reviews.length} reviews', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _ratingBar(5, 0.75),
                const SizedBox(height: 4),
                _ratingBar(4, 0.20),
                const SizedBox(height: 4),
                _ratingBar(3, 0.05),
                const SizedBox(height: 4),
                _ratingBar(2, 0.0),
                const SizedBox(height: 4),
                _ratingBar(1, 0.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(int stars, double percentage) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text('$stars', style: TextStyle(fontSize: 11, color: Colors.grey.shade500))),
        Icon(Icons.star_rounded, color: const Color(0xFFFBBF24), size: 12),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: percentage, backgroundColor: const Color(0xFFCCFBF1), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)), minHeight: 6),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(_Review review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundColor: const Color(0xFFCCFBF1), child: Text(review.mentee[0], style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 14))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(review.mentee, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  Text(review.topic, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ]),
              ),
              Text(review.date, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) => Icon(i < review.rating ? Icons.star_rounded : Icons.star_outline_rounded, color: const Color(0xFFFBBF24), size: 16)),
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4)),
        ],
      ),
    );
  }
}

class _Review {
  final String mentee, comment, date, topic;
  final int rating;
  const _Review({required this.mentee, required this.rating, required this.comment, required this.date, required this.topic});
}
