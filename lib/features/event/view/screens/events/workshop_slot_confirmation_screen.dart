import 'package:flutter/material.dart';

const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _accentBg = Color(0xFFEFF6FF);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);
const _green = Color(0xFF22C55E);

class WorkshopSlotConfirmationScreen extends StatelessWidget {
  final String workshopTitle;
  final String email;
  const WorkshopSlotConfirmationScreen({
    super.key,
    this.workshopTitle = 'Advanced UI/UX Design Workshop',
    this.email = 'alex.j@example.com',
  });

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
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildSuccessIcon(),
                    const SizedBox(height: 20),
                    _buildSuccessHeader(context),
                    const SizedBox(height: 24),
                    _buildTicketCard(),
                    const SizedBox(height: 20),
                    _buildActionButtons(context),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        // Pop back to Events Home
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      child: const Text(
                        'Go back to Event Hub →',
                        style: TextStyle(
                          color: _accentLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              child: Text('Slot confirmation',
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

  Widget _buildSuccessIcon() {
    return Container(
      width: 72, height: 72,
      decoration: BoxDecoration(
        color: _green.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: _green.withOpacity(0.4), width: 2),
      ),
      child: const Icon(Icons.check_rounded, color: _green, size: 36),
    );
  }

  Widget _buildSuccessHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: _green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _green.withOpacity(0.3)),
          ),
          child: const Text('Success',
              style: TextStyle(color: _green, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 14),
        const Text('Slot Confirmed!',
            style: TextStyle(color: _textPrimary, fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: _textSecondary, fontSize: 13, height: 1.5),
            children: [
              const TextSpan(text: "We've sent a confirmation email to "),
              TextSpan(
                text: email,
                style: const TextStyle(color: _accentLight, fontWeight: FontWeight.w600),
              ),
              TextSpan(text: ". You're all set for the $workshopTitle."),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          // Top badges row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _accent.withOpacity(0.3)),
                  ),
                  child: const Text('WORKSHOP',
                      style: TextStyle(color: _accentLight, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _borderColor),
                  ),
                  child: const Text('#UW-98432',
                      style: TextStyle(color: _textSecondary, fontSize: 9, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Advanced UI/UX\nDesign Workshop',
                    style: TextStyle(color: _textPrimary, fontSize: 17, fontWeight: FontWeight.w900, height: 1.25)),
                const SizedBox(height: 14),
                // 2x2 info grid
                Row(
                  children: [
                    _ticketInfoCell('DATE', 'August 15, 2026'),
                    const SizedBox(width: 20),
                    _ticketInfoCell('TIME', '10:00 AM'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ticketInfoCell('VENUE', '📍 Studio A'),
                    const SizedBox(width: 20),
                    _ticketInfoCell('ENTRY', 'Student Pass'),
                  ],
                ),
                const SizedBox(height: 16),
                // Dashed divider
                LayoutBuilder(builder: (ctx, constraints) {
                  final w = constraints.maxWidth;
                  return Row(
                    children: List.generate(
                      (w / 8).floor(),
                      (_) => Expanded(
                        child: Container(
                          height: 1,
                          color: _borderColor,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                // QR code placeholder
                Center(
                  child: Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomPaint(painter: _QrPainter()),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text('Scan at the entrance for verification',
                      style: TextStyle(color: _textSecondary, fontSize: 11)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketInfoCell(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _textSecondary, fontSize: 9, letterSpacing: 0.5)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ticket downloaded to your device ✓'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 16, color: _accentLight),
            label: const Text('Download', style: TextStyle(color: _accentLight, fontSize: 13, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _accent, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ticket link copied — share it with friends!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.share_rounded, size: 16, color: _accentLight),
            label: const Text('Share', style: TextStyle(color: _accentLight, fontSize: 13, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _accent, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

// Simple QR pattern painter
class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1830);
    final cellSize = size.width / 10;

    // Simple grid pattern mimicking a QR code
    const pattern = [
      [1,1,1,1,1,1,1,0,1,0],
      [1,0,0,0,0,0,1,0,0,1],
      [1,0,1,1,1,0,1,0,1,0],
      [1,0,1,1,1,0,1,1,0,1],
      [1,0,1,1,1,0,1,0,1,0],
      [1,0,0,0,0,0,1,1,0,1],
      [1,1,1,1,1,1,1,0,1,0],
      [0,0,0,0,0,0,0,0,1,1],
      [1,0,1,1,0,1,1,0,0,1],
      [0,1,0,0,1,0,0,1,1,0],
    ];

    for (int row = 0; row < pattern.length; row++) {
      for (int col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(col * cellSize + 4, row * cellSize + 4, cellSize - 1, cellSize - 1),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
