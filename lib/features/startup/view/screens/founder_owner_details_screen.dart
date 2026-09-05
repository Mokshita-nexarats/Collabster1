import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'partnership_details_screen.dart';

class FounderOwnerDetailsScreen extends StatefulWidget {
  const FounderOwnerDetailsScreen({super.key});

  @override
  State<FounderOwnerDetailsScreen> createState() =>
      _FounderOwnerDetailsScreenState();
}

class _FounderOwnerDetailsScreenState
    extends State<FounderOwnerDetailsScreen> {
  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _skyLight = Color(0xFFE0F2FE);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _picker = ImagePicker();

  File? _photo;
  String _countryCode = '+91';

  static const List<String> _countryCodes = [
    '+91', '+1', '+44', '+61', '+81', '+49', '+33', '+86',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PartnershipDetailsScreen()),
    );
  }

  // ── Country code picker (BottomSheet — no overlay widgets) ────────────────

  Future<void> _pickCountryCode() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Country Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final code in _countryCodes)
              ListTile(
                onTap: () => Navigator.pop(ctx, code),
                title: Text(code,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: _countryCode == code
                    ? Icon(Icons.check_circle,
                        color: _skyBlue, size: 20)
                    : null,
              ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _countryCode = picked);
    }
  }

  // ── Photo picker ──────────────────────────────────────────────────────────

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose Source',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ListTile(
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              leading: const Icon(Icons.photo_library_outlined,
                  color: _skyBlue),
              title: const Text('Gallery'),
            ),
            ListTile(
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
              leading:
                  const Icon(Icons.camera_alt_outlined, color: _skyBlue),
              title: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    final picked = await _picker.pickImage(
        source: source, imageQuality: 85, maxWidth: 800);
    if (picked == null || !mounted) return;
    setState(() => _photo = File(picked.path));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      size: 25, color: Color(0xFF202020)),
                ),
              ),
              const SizedBox(height: 28),

              // Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE1E1E8)),
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
                    // Step dots
                    Row(
                      children: [
                        _stepDot('1', done: true),
                        _stepLine(done: true),
                        _stepDot('2', done: true),
                        _stepLine(done: true),
                        _stepDot('3', done: true),
                        _stepLine(done: true),
                        _stepDot('4', active: true),
                        _stepLine(),
                        _stepDot('5'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Company Details',
                      style: TextStyle(
                          fontSize: 11,
                          color: _skyBlue,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Founder / Owner Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202020),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tell us about the primary founder or owner.',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF626A79)),
                    ),
                    const SizedBox(height: 24),

                    // Avatar
                    Center(
                      child: GestureDetector(
                        onTap: _pickPhoto,
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _skyLight,
                                    border: Border.all(
                                        color: _skyBlue, width: 2),
                                    image: _photo != null
                                        ? DecorationImage(
                                            image: FileImage(_photo!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _photo == null
                                      ? const Icon(Icons.person_outline,
                                          size: 48,
                                          color: Color(0xFF777384))
                                      : null,
                                ),
                                Positioned(
                                  right: -2,
                                  bottom: 2,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _skyBlue,
                                    ),
                                    child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 17,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _photo == null
                                  ? 'Upload Photo'
                                  : 'Change Photo',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _skyBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Full Name
                    _label('Full Name', required: true),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _nameController,
                      hint: 'Enter your full name',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _label('Email Address', required: true),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _emailController,
                      hint: 'name@company.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Phone — GestureDetector for country code, NO DropdownButton
                    _label('Mobile Number', required: true),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Country code tap area — pure Container, no overlay
                        GestureDetector(
                          onTap: _pickCountryCode,
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            decoration: BoxDecoration(
                              color: _skyLight,
                              border: Border.all(
                                  color: const Color(0xFFDDE0E8)),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _countryCode,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Color(0xFF626A79)),
                              ],
                            ),
                          ),
                        ),
                        // Phone number field
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1A1A1A)),
                            decoration: const InputDecoration(
                              hintText: '98765 43210',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF)),
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 17),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                    color: Color(0xFFDDE0E8)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                    color: Color(0xFFDDE0E8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                borderSide: BorderSide(
                                    color: _skyBlue, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Next button
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
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _label(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF222222),
        ),
        children: required
            ? const [
                TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red))
              ]
            : [],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style:
          const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 14, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFFDDE0E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFFDDE0E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: _skyBlue, width: 1.5),
        ),
      ),
    );
  }

  Widget _stepDot(String n,
      {bool active = false, bool done = false}) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active || done
            ? _skyBlue
            : const Color(0xFFE9E9EE),
      ),
      child: done && !active
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : Text(
              n,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? Colors.white
                      : const Color(0xFF747783)),
            ),
    );
  }

  Widget _stepLine({bool done = false}) {
    return Expanded(
      child: Container(
        height: 1,
        color: done ? _skyBlue : const Color(0xFFE5E3EA),
      ),
    );
  }
}
