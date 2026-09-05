import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../model/startup_models.dart';
import '../widgets/startup_color_helper.dart';

class InvestorDetailScreen extends ConsumerWidget {
  const InvestorDetailScreen({
    super.key,
    required this.investor,
    required this.startupName,
  });

  final FundraisingInvestor investor;
  final String startupName;

  void _showScheduleCallSheet(
    BuildContext context,
    WidgetRef ref,
    String partnerEmail,
  ) {
    String selectedTimeSlot = 'Tomorrow 10:00 AM';
    String selectedFormat = 'Google Meet';
    final agendaCtrl = TextEditingController(
      text: 'Series A Pitch & Financial Model Walkthrough',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.event_available_rounded,
                          color: Color(0xFF0088CC),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Schedule Call with Partner',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12233D),
                              ),
                            ),
                            Text(
                              'Invite: $partnerEmail',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Available Date & Time',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Tomorrow 10:00 AM',
                      'Tomorrow 02:30 PM',
                      'Aug 5 - 11:00 AM',
                      'Aug 7 - 04:00 PM',
                    ].map((slot) {
                      final selected = slot == selectedTimeSlot;
                      return GestureDetector(
                        onTap: () =>
                            setModalState(() => selectedTimeSlot = slot),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF0088CC)
                                : const Color(0xFFF0F9FF),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF0088CC)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Text(
                            slot,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF4B5563),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Meeting Format',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        ['Google Meet', 'Zoom Video', 'Phone Call'].map((fmt) {
                      final selected = fmt == selectedFormat;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedFormat = fmt),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF0088CC)
                                : const Color(0xFFF0F9FF),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF0088CC)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Text(
                            fmt,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF4B5563),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: agendaCtrl,
                    decoration: InputDecoration(
                      hintText: 'Meeting Agenda & Topic',
                      prefixIcon: const Icon(Icons.notes_outlined),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(fundraisingViewModelProvider.notifier)
                            .updateInvestorStatus(
                              investor,
                              'Meeting: $selectedTimeSlot',
                            );
                        ref
                            .read(fundraisingViewModelProvider.notifier)
                            .addAttentionTask(
                              FundraisingTask(
                                title: 'Investor Call with ${investor.name}',
                                subtitle: '$selectedTimeSlot · $selectedFormat',
                                iconKey: 'video',
                                isUrgent: true,
                              ),
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Call scheduled with ${investor.name} for $selectedTimeSlot via $selectedFormat!',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: const Text(
                        'Confirm & Send Calendar Invite',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSendDeckSheet(
    BuildContext context,
    WidgetRef ref,
    String partnerEmail,
  ) {
    final state = ref.read(fundraisingViewModelProvider);
    String selectedDeck = state.documents.isNotEmpty
        ? state.documents.first.name
        : 'Pitch Deck v3.pdf';

    final noteCtrl = TextEditingController(
      text:
          'Hi, Please find attached our pitch deck and financial model for Series A round.',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Color(0xFF0088CC),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Send Pitch Material',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12233D),
                              ),
                            ),
                            Text(
                              'To: $partnerEmail',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Select Document Attachment',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...state.documents.map((doc) {
                    final selected = doc.name == selectedDeck;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => setModalState(() => selectedDeck = doc.name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFE8F4FB)
                                : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF0088CC)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf_outlined,
                                color: selected
                                    ? const Color(0xFF0088CC)
                                    : const Color(0xFF6B7280),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  doc.name,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? const Color(0xFF0088CC)
                                        : const Color(0xFF12233D),
                                  ),
                                ),
                              ),
                              Text(
                                doc.size,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Personalized Cover Note',
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(fundraisingViewModelProvider.notifier)
                            .updateInvestorStatus(
                              investor,
                              'Deck Sent - Awaiting Review',
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Successfully sent $selectedDeck to $partnerEmail!',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text(
                        'Send Deck to Partner',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fundraisingViewModelProvider);

    final currentInvestor = state.activeInvestors.firstWhere(
      (i) => i.name == investor.name,
      orElse: () => investor,
    );

    final partnerName = currentInvestor.leadPartner ?? 'Managing Partner';
    final partnerEmail = currentInvestor.email ??
        'contact@${currentInvestor.name.toLowerCase().replaceAll(' ', '')}.com';
    final notes = currentInvestor.notes ??
        'Evaluating product-market fit and recurring revenue traction for Series A round.';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          // Header Banner
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    StartupColorHelper.fromKey(currentInvestor.colorKey),
                    const Color(0xFF0088CC),
                    const Color(0xFF0088CC),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Text(
                            'Investor Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Investor contact for ${currentInvestor.name} copied!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Fund Badge Avatar
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            currentInvestor.initials,
                            style: TextStyle(
                              color: StartupColorHelper.fromKey(currentInvestor.colorKey),
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentInvestor.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Target Check: ${currentInvestor.amount} · ${currentInvestor.fund}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          currentInvestor.meetingIn.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Details Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showScheduleCallSheet(
                          context,
                          ref,
                          partnerEmail,
                        ),
                        icon: const Icon(Icons.event_available_rounded,
                            size: 18),
                        label: const Text(
                          'Schedule Call',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showSendDeckSheet(
                          context,
                          ref,
                          partnerEmail,
                        ),
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text(
                          'Send Deck',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0088CC),
                          side: const BorderSide(
                            color: Color(0xFF0088CC),
                            width: 1.5,
                          ),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Lead Partner & Contact Info Card
                _cardContainer(
                  title: 'Lead Partner & Contact',
                  icon: Icons.person_outline_rounded,
                  child: Column(
                    children: [
                      _infoRow(
                        icon: Icons.badge_outlined,
                        label: 'Lead Partner',
                        value: partnerName,
                      ),
                      const Divider(height: 24),
                      _infoRow(
                        icon: Icons.mail_outline,
                        label: 'Partner Email',
                        value: partnerEmail,
                        trailing: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied $partnerEmail'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F4FB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Copy',
                              style: TextStyle(
                                color: Color(0xFF0088CC),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      _infoRow(
                        icon: Icons.monetization_on_outlined,
                        label: 'Proposed Check Size',
                        value: currentInvestor.amount,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Investment Notes & Strategy
                _cardContainer(
                  title: 'Investment Notes & Focus',
                  icon: Icons.notes_outlined,
                  child: Text(
                    notes,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _cardContainer({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0088CC), size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  static Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 18),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF12233D),
              ),
            ),
          ],
        ),
        if (trailing != null) ...[
          const Spacer(),
          trailing,
        ],
      ],
    );
  }
}
