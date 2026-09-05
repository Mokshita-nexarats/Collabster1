import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'founder_owner_details_screen.dart';

class PanGstDetailsScreen extends StatefulWidget {
  const PanGstDetailsScreen({super.key});

  @override
  State<PanGstDetailsScreen> createState() => _PanGstDetailsScreenState();
}

class _PanGstDetailsScreenState extends State<PanGstDetailsScreen> {
  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _skyLight = Color(0xFFE0F2FE);

  final _panController = TextEditingController(text: 'AABCT1234D');
  final _gstController = TextEditingController(text: '09AABCT1234D1ZS');
  String _gstType = 'Regular';

  static const _gstTypes = ['Regular', 'Composition', 'Exempt', 'SEZ'];

  @override
  void dispose() {
    _panController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  void _onNext() {
    FocusScope.of(context).unfocus();
    if (_panController.text.trim().isEmpty ||
        _gstController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill PAN and GST numbers'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FounderOwnerDetailsScreen()),
    );
  }

  Future<void> _pickGstType() async {
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
            const Text('Select GST Type',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            for (final t in _gstTypes)
              ListTile(
                onTap: () => Navigator.pop(ctx, t),
                title: Text(t,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: _gstType == t
                    ? const Icon(Icons.check_circle,
                        color: _skyBlue, size: 20)
                    : null,
              ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _gstType = picked);
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
                padding: const EdgeInsets.only(left: 24, top: 15),
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

            // Step indicator — step 3 active, 1 & 2 done
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  _step('1', done: true),
                  _line(done: true),
                  _step('2', done: true),
                  _line(done: true),
                  _step('3', active: true),
                  _line(),
                  _step('4'),
                  _line(),
                  _step('5'),
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
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PAN & GST Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Provide your company's PAN and GST information.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF626A79),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Plain form (no outer card)
                    _field(
                      'PAN Number',
                      _panController,
                      hint: 'AABCT1234D',
                      verified: true,
                      formatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const SizedBox(height: 17),
                    _field(
                      'GST Number',
                      _gstController,
                      hint: '09AABCT1234D1ZS',
                      verified: true,
                      formatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                        LengthLimitingTextInputFormatter(15),
                      ],
                    ),
                    const SizedBox(height: 17),
                    const Text.rich(
                      TextSpan(
                        text: 'GST Type',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF222222),
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // GST Type — tap to open BottomSheet, no DropdownButton overlay
                    GestureDetector(
                      onTap: _pickGstType,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFDDE0E8)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _gstType,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF333333)),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 20,
                                color: Color(0xFF626A79)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info box — sky blue tint
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _skyLight,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: _skyBlue),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: _skyBlue,
                            size: 23,
                          ),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'PAN and GST details help us verify\n'
                              'your company information securely.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: Color(0xFF555363),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

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
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 7),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
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

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    bool verified = false,
    List<TextInputFormatter>? formatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF222222),
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: formatters,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            suffixIcon: verified
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _skyLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 15,
                            color: _skyBlue,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 12,
                              color: _skyBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minHeight: 30,
              minWidth: 0,
            ),
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
    );
  }
}
