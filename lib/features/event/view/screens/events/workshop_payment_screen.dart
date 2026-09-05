import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/providers.dart';
import 'workshop_slot_confirmation_screen.dart';

const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);
const _inputBg = Color(0xFFF1F5F9);
const _green = Color(0xFF22C55E);

class WorkshopPaymentScreen extends ConsumerStatefulWidget {
  final String workshopTitle;
  final String organizer;
  const WorkshopPaymentScreen({
    super.key,
    this.workshopTitle = 'Advanced UI/UX Design Workshop',
    this.organizer = 'ADVANCED UI/UX WORKSHOP',
  });

  @override
  ConsumerState<WorkshopPaymentScreen> createState() => _WorkshopPaymentScreenState();
}

class _WorkshopPaymentScreenState extends ConsumerState<WorkshopPaymentScreen> {
  // 0=GooglePay, 1=PhonePe, 2=Paytm, 3=Card
  int _selectedUpi = 0;
  bool _isProcessing = false;

  final TextEditingController _upiCtrl = TextEditingController();
  final TextEditingController _cardCtrl = TextEditingController();
  final TextEditingController _expiryCtrl = TextEditingController();
  final TextEditingController _cvvCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _upiCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
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
                    _buildHeroImage(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildOrderSummary(),
                          const SizedBox(height: 20),
                          _buildUpiSection(),
                          const SizedBox(height: 16),
                          _buildUpiIdField(),
                          const SizedBox(height: 20),
                          _buildCardSection(),
                          const SizedBox(height: 24),
                          _buildPayButton(context),
                          const SizedBox(height: 10),
                          _buildSecureLabel(),
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
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _surface, shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 18),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Payment',
                  style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _surface, shape: BoxShape.circle,
              border: Border.all(color: _borderColor),
            ),
            child: const Icon(Icons.notifications_outlined, color: _textPrimary, size: 18),
          ),
          const SizedBox(width: 10),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_accentLight, _accent]),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero Image ──────────────────────────────────────────────
  Widget _buildHeroImage() {
    return Container(
      height: 140,
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
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.15), shape: BoxShape.circle,
              ),
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, color: Colors.white70, size: 32),
                SizedBox(height: 6),
                Text('Secure Checkout', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Order Summary ───────────────────────────────────────────
  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Checkout',
              style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          _summaryRow('Advanced UI/UX Workshop Ticket', '₹499'),
          const SizedBox(height: 8),
          _summaryRow('Convenience Fee', '₹49'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: _borderColor, thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Total', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
              Text('₹548', style: TextStyle(color: _accentLight, fontSize: 15, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: _textSecondary, fontSize: 12)),
        Text(amount, style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ─── UPI Section ─────────────────────────────────────────────
  Widget _buildUpiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Pay via UPI',
                style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('INSTANT',
                  style: TextStyle(color: _green, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...[
          {'label': 'Google Pay', 'icon': Icons.g_mobiledata_rounded, 'color': Color(0xFF4285F4)},
          {'label': 'PhonePe', 'icon': Icons.phone_android_rounded, 'color': Color(0xFF5A0FC8)},
          {'label': 'Paytm', 'icon': Icons.account_balance_wallet_rounded, 'color': Color(0xFF00B9F1)},
        ].asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          final isSelected = _selectedUpi == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedUpi = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: isSelected ? _accent.withOpacity(0.08) : _inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? _accent : _borderColor, width: isSelected ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(item['label'] as String,
                      style: TextStyle(
                        color: isSelected ? _textPrimary : _textSecondary,
                        fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      )),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? _accent : _borderColor, width: 2),
                      color: isSelected ? _accent : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.circle, color: Colors.white, size: 8)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── UPI ID Field ────────────────────────────────────────────
  Widget _buildUpiIdField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _upiCtrl,
              style: const TextStyle(color: _textPrimary, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Enter UPI ID (e.g. user@okaxis)',
                hintStyle: TextStyle(color: _textSecondary, fontSize: 12),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final upi = _upiCtrl.text.trim();
              if (upi.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a UPI ID first'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$upi verified ✓'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Verify',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Card Section ────────────────────────────────────────────
  Widget _buildCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text('Credit / Debit Card',
                style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
            SizedBox(width: 8),
            Icon(Icons.credit_card_rounded, color: _textSecondary, size: 16),
          ],
        ),
        const SizedBox(height: 12),
        _cardInput(_cardCtrl, 'Card Number', keyboardType: TextInputType.number),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _cardInput(_expiryCtrl, 'MM/YY', keyboardType: TextInputType.datetime)),
            const SizedBox(width: 10),
            Expanded(
              child: _cardInput(
                _cvvCtrl, 'CVV',
                keyboardType: TextInputType.number,
                suffix: const Icon(Icons.visibility_off_outlined, color: _textSecondary, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _cardInput(_nameCtrl, 'Cardholder Name'),
      ],
    );
  }

  Widget _cardInput(
    TextEditingController ctrl,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              keyboardType: keyboardType,
              style: const TextStyle(color: _textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: _textSecondary, fontSize: 12),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
          if (suffix != null) Padding(padding: const EdgeInsets.only(right: 12), child: suffix),
        ],
      ),
    );
  }

  // ─── Pay Button ──────────────────────────────────────────────
  Widget _buildPayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing
            ? null
            : () async {
                ref.read(eventViewModelProvider.notifier)
                    .rsvpEvent(widget.workshopTitle);
                final nav = Navigator.of(context);
                setState(() => _isProcessing = true);
                await Future.delayed(const Duration(milliseconds: 800));
                if (!mounted) return;
                setState(() => _isProcessing = false);
                nav.push(
                  MaterialPageRoute(
                    builder: (_) => WorkshopSlotConfirmationScreen(
                      workshopTitle: widget.workshopTitle,
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          disabledBackgroundColor: _accent.withOpacity(0.6),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pay Now • ₹499',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
      ),
    );
  }

  Widget _buildSecureLabel() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_rounded, color: _textSecondary, size: 12),
        SizedBox(width: 5),
        Text('256-bit Secure Encrypted Payment',
            style: TextStyle(color: _textSecondary, fontSize: 11)),
      ],
    );
  }
}
