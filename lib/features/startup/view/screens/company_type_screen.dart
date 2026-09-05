import 'package:flutter/material.dart';

import 'basic_information_screen.dart';

class CompanyTypeScreen extends StatefulWidget {
  const CompanyTypeScreen({super.key});

  @override
  State<CompanyTypeScreen> createState() => _CompanyTypeScreenState();
}

class _CompanyTypeScreenState extends State<CompanyTypeScreen> {
  int _selectedIndex = 0;

  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _skyLight = Color(0xFFE0F2FE);

  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BasicInformationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Color(0xFF202020),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Main Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE1E1E8),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. Company Type',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202020),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select the type of company you want to register.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF626A79),
                      ),
                    ),
                    const SizedBox(height: 33),
                    _companyOption(
                      index: 0,
                      icon: Icons.person,
                      title: 'Sole Owner Company',
                      description:
                          'A business owned and run by\none individual.',
                    ),
                    const SizedBox(height: 16),
                    _companyOption(
                      index: 1,
                      icon: Icons.people_outline,
                      title: 'Partnership Firm',
                      description:
                          'A business owned by two or\nmore people.',
                    ),
                    const SizedBox(height: 16),
                    _companyOption(
                      index: 2,
                      icon: Icons.business,
                      title: 'Private Limited / LLP',
                      description:
                          'A corporate structure\nprotecting personal assets.',
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: ElevatedButton(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _skyBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 15,
                      color: Color(0xFF626A79),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Secure Registration Process',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF626A79),
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
    );
  }

  Widget _companyOption({
    required int index,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final bool selected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        decoration: BoxDecoration(
          color: selected ? _skyLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _skyBlue : const Color(0xFFE1E1E8),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 27,
              color: selected ? _skyBlue : const Color(0xFF626A79),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: Color(0xFF626A79),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _skyBlue : Colors.white,
                border: Border.all(
                  color: selected ? _skyBlue : const Color(0xFFC9C6D9),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
