import 'package:flutter/material.dart';

class MentorEarningsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const MentorEarningsScreen({super.key, this.onBack});

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
                  const Text('Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
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
                    _buildEarningsSummary(),
                    const SizedBox(height: 24),
                    const Text('This Month', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    _buildEarningsBar('Week 1', 1200, 1500),
                    const SizedBox(height: 10),
                    _buildEarningsBar('Week 2', 980, 1500),
                    const SizedBox(height: 10),
                    _buildEarningsBar('Week 3', 1350, 1500),
                    const SizedBox(height: 10),
                    _buildEarningsBar('Week 4', 420, 1500),
                    const SizedBox(height: 24),
                    const Text('Recent Payouts', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    _buildPayoutRow(mentee: 'Priya Sharma', amount: '\$45', date: 'Aug 20', type: 'Session'),
                    const SizedBox(height: 8),
                    _buildPayoutRow(mentee: 'Alex Chen', amount: '\$55', date: 'Aug 18', type: 'Session'),
                    const SizedBox(height: 8),
                    _buildPayoutRow(mentee: 'Marcus Lee', amount: '\$90', date: 'Aug 15', type: 'Package'),
                    const SizedBox(height: 8),
                    _buildPayoutRow(mentee: 'David Kim', amount: '\$45', date: 'Aug 12', type: 'Session'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF14B8A6)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF14B8A6).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Earnings', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          const Text('\$3,950', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('This month', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            children: [
              _miniStat('Sessions', '156'),
              Container(width: 1, height: 30, color: Colors.white24),
              _miniStat('Avg/Session', '\$48'),
              Container(width: 1, height: 30, color: Colors.white24),
              _miniStat('Pending', '\$135'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildEarningsBar(String week, double amount, double max) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(week, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: amount / max, backgroundColor: const Color(0xFFCCFBF1), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)), minHeight: 12),
          ),
        ),
        const SizedBox(width: 10),
        Text('\$${amount.toInt()}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
      ],
    );
  }

  Widget _buildPayoutRow({required String mentee, required String amount, required String date, required String type}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: const Color(0xFFCCFBF1), child: Text(mentee[0], style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(mentee, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              Text('$type  •  $date', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ]),
          ),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
        ],
      ),
    );
  }
}
