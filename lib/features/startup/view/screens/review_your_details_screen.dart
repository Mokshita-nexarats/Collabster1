import 'package:flutter/material.dart';

import 'application_under_review_screen.dart';

class ReviewYourDetailsScreen extends StatelessWidget {
  const ReviewYourDetailsScreen({super.key});

  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _skyLight = Color(0xFFE0F2FE);

  void _onSubmit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ApplicationUnderReviewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 27, top: 15),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Color(0xFF202020),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Step indicator — all Company Details steps done
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: [
                  _step('1', done: true),
                  _line(done: true),
                  _step('2', done: true),
                  _line(done: true),
                  _step('3', done: true),
                  _line(done: true),
                  _step('4', done: true),
                  _line(done: true),
                  _step('5', done: true),
                ],
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Company Details',
              style: TextStyle(
                fontSize: 11,
                color: _skyBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 21),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Review Your Details',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Verify all information before submitting.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF626A79),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Details card — single level, no nested cards
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: const Color(0xFFE0DCE8)),
                      ),
                      child: Column(
                        children: [
                          _detailRow(
                            context,
                            icon: Icons.business,
                            title: 'Company Type',
                            value: 'Private Limited / LLP',
                          ),
                          _divider(),
                          _detailRow(
                            context,
                            icon: Icons.store_outlined,
                            title: 'Company Name',
                            value: 'TechNova Solutions Pvt.\nLtd.',
                          ),
                          _divider(),
                          _detailRow(
                            context,
                            icon: Icons.badge_outlined,
                            title: 'PAN',
                            value: '******234D',
                            verified: true,
                          ),
                          _divider(),
                          _detailRow(
                            context,
                            icon: Icons.receipt_long_outlined,
                            title: 'GST',
                            value: '09AABCT1234D1ZS',
                            verified: true,
                          ),
                          _divider(),
                          _detailRow(
                            context,
                            icon: Icons.person_outline,
                            title: 'Founder / Owner',
                            value: 'Arjun Patel',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Information box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F3F6),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: const Color(0xFFE4E4EA)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Color(0xFF707586),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'By submitting this application, you confirm '
                              'that all details provided are accurate and '
                              'legally binding. Our team will verify these '
                              'documents within 1-2 business days.',
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.55,
                                color: Color(0xFF626A79),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 23),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: ElevatedButton(
                        onPressed: () => _onSubmit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _skyBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Submit Application',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(String number, {bool active = false, bool done = false}) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active || done ? _skyBlue : const Color(0xFFE9E9EE),
      ),
      child: done && !active
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              number,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : const Color(0xFF747783),
              ),
            ),
    );
  }

  Widget _line({bool done = false}) {
    return Expanded(
      child: Container(
        height: 1,
        color: done ? _skyBlue : const Color(0xFFE5E3EA),
      ),
    );
  }

  Widget _detailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool verified = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          // Icon circle — sky tint
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _skyLight,
              border: Border.all(color: _skyBlue),
            ),
            child: Icon(icon, size: 23, color: _skyBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF626A79),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222222),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _skyLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_outlined,
                              size: 12,
                              color: _skyBlue,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 10,
                                color: _skyBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.edit_outlined,
              size: 21,
              color: Color(0xFF777784),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, color: Color(0xFFE5E3EA));
  }
}
