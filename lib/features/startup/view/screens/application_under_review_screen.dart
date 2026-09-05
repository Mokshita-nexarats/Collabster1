import 'package:flutter/material.dart';

import 'registration_submitted_screen.dart';

class ApplicationUnderReviewScreen extends StatelessWidget {
  const ApplicationUnderReviewScreen({super.key});

  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _background = Color(0xFFF8FAFC);
  static const Color _text = Color(0xFF202124);
  static const Color _mutedText = Color(0xFF626A79);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _skyBlue, size: 25),
                padding: const EdgeInsets.only(left: 25, top: 8),
                constraints: const BoxConstraints(),
                splashRadius: 22,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(11, 11, 11, 32),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 610),
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE1E4EC)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 1),
                      const _SubmittedIcon(),
                      const SizedBox(height: 35),
                      const Text(
                        'Application Under\nReview',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Your application has been submitted\nsuccessfully.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: _mutedText,
                        ),
                      ),
                      const SizedBox(height: 31),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FB),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: const Color(0xFFD8DDF0)),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: _skyBlue, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Our team will verify your details\nand update you within 1-2\nbusiness days.',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.25,
                                  color: Color(0xFF4D5060),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RegistrationSubmittedScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _skyBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Track Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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
}

class _SubmittedIcon extends StatelessWidget {
  const _SubmittedIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 98,
          height: 98,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.assignment_turned_in,
            size: 49,
            color: Color(0xFF0284C7),
          ),
        ),
        Positioned(
          right: -7,
          bottom: -7,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFB7FFB9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.check, size: 19, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
