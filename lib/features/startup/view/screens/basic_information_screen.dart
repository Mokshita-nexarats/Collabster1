import 'package:flutter/material.dart';

import 'pan_gst_details_screen.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  static const Color _skyBlue = Color(0xFF0284C7);

  final _nameController =
      TextEditingController(text: 'TechNova Solutions Pvt. Ltd.');
  final _yearController = TextEditingController(text: '2022');
  final _emailController = TextEditingController(text: 'info@technova.com');
  final _websiteController =
      TextEditingController(text: 'https://www.technova.com');
  final _addressController = TextEditingController(
    text: '123, Innovation Drive, Sector 62, Noida,\nUttar Pradesh - 201309',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickYear() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse('${_yearController.text}-01-01') ?? now,
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _skyBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _yearController.text = '${picked.year}');
    }
  }

  void _onNext() {
    FocusScope.of(context).unfocus();
    if (_nameController.text.trim().isEmpty ||
        _yearController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PanGstDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back arrow
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 28, top: 15),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF202020),
                    size: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 42),

            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  _step('1', false, done: true),
                  _line(done: true),
                  _step('2', true),
                  _line(),
                  _step('3', false),
                  _line(),
                  _step('4', false),
                  _line(),
                  _step('5', false),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Company Details',
              style: TextStyle(
                fontSize: 11,
                color: _skyBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Tell us about your company.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666676),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Plain form (no outer card, single-border fields)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _field(
                          'Company Name',
                          _nameController,
                          hint: 'TechNova Solutions Pvt. Ltd.',
                          required: true,
                        ),
                        _field(
                          'Year of Incorporation',
                          _yearController,
                          hint: '2022',
                          required: true,
                          readOnly: true,
                          suffix: Icons.calendar_today_outlined,
                          onSuffixTap: _pickYear,
                          onTap: _pickYear,
                        ),
                        _field(
                          'Registered Email',
                          _emailController,
                          hint: 'info@technova.com',
                          keyboardType: TextInputType.emailAddress,
                          required: true,
                        ),
                        _field(
                          'Website',
                          _websiteController,
                          hint: 'https://www.technova.com',
                          keyboardType: TextInputType.url,
                          optional: true,
                        ),

                        // Address
                        const SizedBox(height: 1),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Registered Address',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _addressController,
                          maxLines: 4,
                          maxLength: 200,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Color(0xFF333333),
                          ),
                          decoration: InputDecoration(
                            hintText:
                                '123, Innovation Drive, Sector 62, Noida, Uttar Pradesh - 201309',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            counterText:
                                '${_addressController.text.length}/200',
                            counterStyle: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF666676),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFDDE0E8),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFDDE0E8),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: _skyBlue,
                                width: 1.4,
                              ),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 22),

                        // Next button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(String number, bool active, {bool done = false}) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active || done ? _skyBlue : const Color(0xFFE9E9EE),
      ),
      alignment: Alignment.center,
      child: done && !active
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              number,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : const Color(0xFF737784),
              ),
            ),
    );
  }

  Widget _line({bool done = false}) {
    return Expanded(
      child: Container(
        height: 1,
        color: done ? _skyBlue : const Color(0xFFE5E4EA),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    bool required = false,
    bool optional = false,
    bool readOnly = false,
    IconData? suffix,
    VoidCallback? onSuffixTap,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF333333),
                  ),
                  children: required
                      ? const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]
                      : [],
                ),
              ),
              if (optional)
                const Text(
                  '(Optional)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666676),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            onTap: readOnly ? onTap : null,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: suffix != null
                  ? GestureDetector(
                      onTap: onSuffixTap ?? onTap,
                      child: const Icon(
                        Icons.calendar_today_outlined,
                        size: 21,
                        color: Color(0xFF626978),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFDDE0E8),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFDDE0E8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: _skyBlue,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
