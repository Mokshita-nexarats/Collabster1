import 'package:flutter/material.dart';
import 'workshop_payment_screen.dart';

// ─── Color Tokens ───────────────────────────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _accentBg = Color(0xFFEFF6FF);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);
const _inputBg = Color(0xFFF1F5F9);
const _danger = Color(0xFFFF3C5C);
const _green = Color(0xFF22C55E);

class WorkshopRegistrationScreen extends StatefulWidget {
  final String workshopTitle;
  final String organizer;
  const WorkshopRegistrationScreen({
    super.key,
    this.workshopTitle = 'Mastering Figma for Prototyping',
    this.organizer = 'ADVANCED UI/UX WORKSHOP',
  });

  @override
  State<WorkshopRegistrationScreen> createState() =>
      _WorkshopRegistrationScreenState();
}

class _WorkshopRegistrationScreenState
    extends State<WorkshopRegistrationScreen> {
  int _selectedGender = 0; // 0=Male,1=Female,2=Other
  bool _agreeTerms = false;
  String _selectedCourse = 'B.Des';
  String _selectedYear = '2025';

  final TextEditingController _firstNameCtrl =
      TextEditingController(text: 'John');
  final TextEditingController _lastNameCtrl =
      TextEditingController(text: 'Doe');
  final TextEditingController _emailCtrl =
      TextEditingController(text: 'john.doe@university.edu');
  final TextEditingController _mobileCtrl =
      TextEditingController(text: '9876543210');

  final int _slotsTotal = 100;
  final int _slotsFilled = 86;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero image
                    _buildHeroImage(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildWorkshopBadge(),
                          const SizedBox(height: 12),
                          _buildHeader(),
                          const SizedBox(height: 16),
                          _buildSlotsBar(),
                          const SizedBox(height: 16),
                          _buildInfoGrid(),
                          const SizedBox(height: 22),
                          _buildSectionLabel('Personal Details'),
                          const SizedBox(height: 14),
                          _buildNameRow(),
                          const SizedBox(height: 12),
                          _buildGenderSelector(),
                          const SizedBox(height: 12),
                          _buildCourseYearRow(),
                          const SizedBox(height: 12),
                          _buildLabeledInput(
                              'Email Address *', _emailCtrl, 'john.doe@university.edu',
                              keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 12),
                          _buildMobileInput(),
                          const SizedBox(height: 20),
                          _buildPaymentCard(),
                          const SizedBox(height: 16),
                          _buildTermsRow(),
                          const SizedBox(height: 20),
                          _buildReserveButton(context),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar ─────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _surface,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: _textPrimary, size: 18),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('workshop registration',
                  style: TextStyle(
                      color: _textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _surface,
              shape: BoxShape.circle,
              border: Border.all(color: _borderColor),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: _textPrimary, size: 18),
          ),
          const SizedBox(width: 10),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [_accentLight, _accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('R',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero Image ──────────────────────────────────────────────
  Widget _buildHeroImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF0F172A), Color(0xFF006699)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 40,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: _accentLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Icon centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.design_services_rounded,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(height: 10),
                const Text('Workshop',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Workshop Badge ──────────────────────────────────────────
  Widget _buildWorkshopBadge() {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _accentBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.school_rounded, color: _accentLight, size: 14),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.organizer.toUpperCase(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6),
          ),
        ),
      ],
    );
  }

  // ─── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Register Your Participation',
          style: const TextStyle(
              color: _textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.2),
        ),
        const SizedBox(height: 6),
        const Text(
          'Master production-ready design frameworks with industry experts.',
          style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }

  // ─── Slots Bar ───────────────────────────────────────────────
  Widget _buildSlotsBar() {
    final pct = _slotsFilled / _slotsTotal;
    final remaining = _slotsTotal - _slotsFilled;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_slotsFilled / $_slotsTotal slots filled',
                  style: const TextStyle(color: _textSecondary, fontSize: 12)),
              Text('Only $remaining seats left!',
                  style: const TextStyle(
                      color: _danger,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: _borderColor,
              color: _accent,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Info Grid ───────────────────────────────────────────────
  Widget _buildInfoGrid() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _infoCell(Icons.access_time_rounded, 'Time',
                      '10:00 AM -\n4:00 PM')),
              const SizedBox(width: 12),
              Expanded(
                  child: _infoCell(Icons.calendar_today_rounded, 'Date',
                      'August 15,\n2026')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _infoCell(Icons.location_on_outlined, 'Venue',
                      'Studio A /\nHybrid')),
              const SizedBox(width: 12),
              Expanded(
                  child: _infoCell(
                      Icons.currency_rupee_rounded, 'Fee', '₹499 / Entry')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCell(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _accentLight, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: _textSecondary, fontSize: 10)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Section Label ───────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(label,
        style: const TextStyle(
            color: _textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w800));
  }

  // ─── Name Row ────────────────────────────────────────────────
  Widget _buildNameRow() {
    return Row(
      children: [
        Expanded(
            child: _buildLabeledInput('First Name *', _firstNameCtrl, 'John')),
        const SizedBox(width: 10),
        Expanded(
            child: _buildLabeledInput('Last Name *', _lastNameCtrl, 'Doe')),
      ],
    );
  }

  // ─── Labeled Input ───────────────────────────────────────────
  Widget _buildLabeledInput(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: _textPrimary, fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: _textSecondary, fontSize: 12),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Gender Selector ─────────────────────────────────────────
  Widget _buildGenderSelector() {
    final genders = ['Male', 'Female', 'Other'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender *',
            style: TextStyle(
                color: _textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: List.generate(genders.length, (i) {
            final isSelected = _selectedGender == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedGender = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? _accent : _inputBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isSelected ? _accent : _borderColor),
                ),
                child: Text(
                  genders[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ─── Course + Year Row ───────────────────────────────────────
  Widget _buildCourseYearRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Course / Degree *',
                  style: TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCourse,
                    dropdownColor: _card,
                    style: const TextStyle(
                        color: _textPrimary, fontSize: 12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _textSecondary, size: 18),
                    items: ['B.Des', 'B.Tech', 'MBA', 'MCA', 'BBA']
                        .map((c) => DropdownMenuItem(
                            value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedCourse = v!),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Graduation Year *',
                  style: TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedYear,
                    dropdownColor: _card,
                    style: const TextStyle(
                        color: _textPrimary, fontSize: 12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _textSecondary, size: 18),
                    items: ['2024', '2025', '2026', '2027', '2028']
                        .map((y) => DropdownMenuItem(
                            value: y, child: Text(y)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedYear = v!),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Mobile Input ─────────────────────────────────────────────
  Widget _buildMobileInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mobile Number *',
            style: TextStyle(
                color: _textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: _borderColor)),
                ),
                child: const Text('+91',
                    style: TextStyle(
                        color: _textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              Expanded(
                child: TextField(
                  controller: _mobileCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                      color: _textPrimary, fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: '9876543210',
                    hintStyle: TextStyle(
                        color: _textSecondary, fontSize: 12),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Payment Card ─────────────────────────────────────────────
  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded,
                  color: _accentLight, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Secure Payment',
                    style: TextStyle(
                        color: _textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.credit_card_rounded,
                    color: _textSecondary, size: 14),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.account_balance_wallet_outlined,
                    color: _textSecondary, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Select your preferred payment method after clicking reserve.',
            style: TextStyle(
                color: _textSecondary, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: _green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _green.withOpacity(0.3)),
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle_rounded,
                    color: _green, size: 16),
                SizedBox(width: 8),
                Text('Payment verification enabled',
                    style: TextStyle(
                        color: _green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Terms Row ───────────────────────────────────────────────
  Widget _buildTermsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (v) => setState(() => _agreeTerms = v ?? false),
            activeColor: _accent,
            checkColor: Colors.white,
            side: BorderSide(color: _borderColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                  color: _textSecondary, fontSize: 11, height: 1.5),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Participation',
                  style: TextStyle(
                      color: _accentLight,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      ' and acknowledge that the fee is non-refundable within 48 hours of the event.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Reserve Button ──────────────────────────────────────────
  Widget _buildReserveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkshopPaymentScreen(
                workshopTitle: widget.workshopTitle,
                organizer: widget.organizer,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Reserve My Slot',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
