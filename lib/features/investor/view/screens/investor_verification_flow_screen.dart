import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../../../shared/utils/dashboard_router.dart';

/// Required onboarding for Investor mode. The final completion flag is stored
/// in [AuthSession] and is used by [buildDashboardForRole] to unlock the hub.
class InvestorVerificationFlowScreen extends ConsumerStatefulWidget {
  const InvestorVerificationFlowScreen({super.key});

  @override
  ConsumerState<InvestorVerificationFlowScreen> createState() =>
      _InvestorVerificationFlowScreenState();
}

class _MeetingDetailRow extends StatelessWidget {
  const _MeetingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: InvestorColors.goldSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: InvestorColors.goldPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: InvestorColors.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: InvestorColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InvestorVerificationFlowScreenState
    extends ConsumerState<InvestorVerificationFlowScreen> {
  static const _skyBluePrimary = InvestorColors.goldPrimary;
  static const _skyBlueDeep = InvestorColors.goldDeep;
  static const _skyBlueSoft = InvestorColors.goldSoft;
  static const _canvas = Color(0xFFF8FCFF);
  static const _ink = Color(0xFF171A2B);
  static const _muted = Color(0xFF70778A);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sectors = <String>{};
  final _stages = <String>{};
  final _coInvestments = <String>{};

  int _step = 0;
  bool _started = false;
  String _investorType = 'Solo investor';
  bool _documentsSubmitted = false;
  bool _consultationComplete = false;

  @override
  void initState() {
    super.initState();
    final session = ref.read(authViewModelProvider).session;
    _nameController.text = session?.fullName ?? '';
    _emailController.text = session?.email ?? '';
    _phoneController.text = session?.phone ?? '';
    _sectors.addAll(session?.investorSectors ?? const []);
    _stages.addAll(session?.investorStages ?? const []);
    _coInvestments.addAll(session?.investorCoInvestments ?? const []);
    _investorType = session?.investorType ?? _investorType;
    _documentsSubmitted = session?.investorDocumentsSubmitted ?? false;
    _consultationComplete = session?.investorConsultationComplete ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _persist({bool complete = false}) {
    return ref
        .read(authViewModelProvider.notifier)
        .updateInvestorVerification(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          sectors: _sectors.toList(),
          stages: _stages.toList(),
          investorType: _investorType,
          coInvestments: _coInvestments.toList(),
          documentsSubmitted: _documentsSubmitted,
          consultationComplete: _consultationComplete,
          verificationComplete: complete,
        );
  }

  Future<void> _continue() async {
    if (_step == 0 &&
        (_nameController.text.trim().isEmpty ||
            _emailController.text.trim().isEmpty ||
            _phoneController.text.trim().isEmpty)) {
      _showMessage('Please enter your name, email, and mobile number.');
      return;
    }
    if (_step == 1 && (_sectors.isEmpty || _stages.isEmpty)) {
      _showMessage('Select at least one sector and investment stage.');
      return;
    }
    if (_step == 3) _documentsSubmitted = true;

    await _persist();
    if (!mounted) return;
    setState(() => _step++);
  }

  Future<void> _completeMeeting() async {
    _consultationComplete = true;
    await _persist(complete: true);
    if (!mounted) return;
    setState(() => _step = 6);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _back() {
    if (!_started) {
      Navigator.maybePop(context);
      return;
    }
    if (_step == 0) {
      setState(() => _started = false);
      return;
    }
    setState(() => _step--);
  }

  void _openDashboard() {
    final session = ref.read(authViewModelProvider).session;
    if (session == null) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => buildDashboardForRole(session)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return _buildIntroductionScreen();
    if (_step == 5) return _buildMeetingScreen();
    if (_step == 6) return _buildSuccessScreen();

    final titles = [
      'Investor registration',
      'Investor profile setup',
      'About your investment type',
      'Verification required',
      'One-on-one verification',
    ];
    final subtitles = [
      'Join Collabster as an investor',
      'Tell us what you like to invest in',
      'Tell us more about how you invest',
      'Complete the required verification steps',
      'A quick conversation with our verification team',
    ];

    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Column(
          children: [
            _header(titles[_step], subtitles[_step]),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: _stepContent(),
              ),
            ),
            _bottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionScreen() {
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back_rounded, color: _ink),
                tooltip: 'Back',
              ),
              const Spacer(),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  gradient: InvestorColors.goldGradient,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: _skyBluePrimary.withValues(alpha: 0.24),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Investor mode',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Discover curated startup opportunities and build meaningful founder relationships.',
                style: TextStyle(color: _muted, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              _introPoint(
                Icons.auto_awesome_rounded,
                'Curated deal flow',
                'Explore opportunities matched to your investment thesis.',
              ),
              _introPoint(
                Icons.verified_user_rounded,
                'Verified investor network',
                'Build trust with founders through a verified profile.',
              ),
              _introPoint(
                Icons.insights_rounded,
                'A focused investor hub',
                'Track deals, notes, meetings, and your portfolio in one place.',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () => setState(() => _started = true),
                  style: FilledButton.styleFrom(
                    backgroundColor: _skyBluePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Let's begin verification",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _introPoint(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _skyBlueSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _skyBlueDeep, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String title, String subtitle) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 18),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back_rounded, color: _ink),
                tooltip: 'Back',
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(5, (index) {
              final complete = index < _step;
              final active = index == _step;
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: complete || active
                            ? _skyBluePrimary
                            : const Color(0xFFF0F1F5),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        complete ? '✓' : '${index + 1}',
                        style: TextStyle(
                          color: complete || active ? Colors.white : _muted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (index < 4)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < _step
                              ? _skyBluePrimary
                              : const Color(0xFFE4E5EA),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return _identityStep();
      case 1:
        return _preferencesStep();
      case 2:
        return _investmentTypeStep();
      case 3:
        return _documentsStep();
      default:
        return _consultationStep();
    }
  }

  Widget _identityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us about yourself',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'These details are used for verification and investor communication.',
          style: TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 26),
        _input('Full name', _nameController, Icons.person_outline_rounded),
        const SizedBox(height: 16),
        _input(
          'Email address',
          _emailController,
          Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _input(
          'Mobile number',
          _phoneController,
          Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 22),
        _infoCard(
          Icons.lock_outline_rounded,
          'Your information is encrypted and used only for verification.',
        ),
      ],
    );
  }

  Widget _preferencesStep() {
    const sectors = [
      'AI & ML',
      'FinTech',
      'HealthTech',
      'SaaS',
      'EdTech',
      'Consumer',
      'DeepTech',
    ];
    const stages = [
      'Pre-seed',
      'Seed',
      'Series A',
      'Series B+',
      'Growth',
      'Pre-IPO',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Sectors of interest',
          'Choose the spaces you actively follow.',
        ),
        const SizedBox(height: 12),
        _multiChips(sectors, _sectors),
        const SizedBox(height: 28),
        _sectionTitle(
          'Preferred investment stage',
          'Select one or more stages.',
        ),
        const SizedBox(height: 12),
        _multiChips(stages, _stages),
        const SizedBox(height: 28),
        _sectionTitle('Investor profile', 'How do you usually invest?'),
        const SizedBox(height: 12),
        _typeChoice(
          'Solo investor',
          'I invest my own capital',
          Icons.person_outline_rounded,
        ),
        const SizedBox(height: 10),
        _typeChoice(
          'Syndicate',
          'I co-invest with a group of investors',
          Icons.groups_rounded,
        ),
        const SizedBox(height: 10),
        _typeChoice(
          'Venture fund',
          'I invest on behalf of a fund',
          Icons.account_balance_rounded,
        ),
      ],
    );
  }

  Widget _investmentTypeStep() {
    const coInvestments = ['Zerodha', 'CRED', 'Groww', 'PhysicsWallah'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Your investment style',
          'Select the option that best describes you.',
        ),
        const SizedBox(height: 14),
        _typeChoice(
          'Solo investor',
          'I invest on my own capital',
          Icons.person_outline_rounded,
        ),
        const SizedBox(height: 10),
        _typeChoice(
          'Syndicate',
          'I co-invest with a group of investors',
          Icons.groups_rounded,
        ),
        const SizedBox(height: 10),
        _typeChoice(
          'Venture fund',
          'I invest on behalf of a fund',
          Icons.account_balance_rounded,
        ),
        const SizedBox(height: 30),
        _sectionTitle(
          'Common investments',
          'Optional. Choose any notable investments.',
        ),
        const SizedBox(height: 12),
        _multiChips(coInvestments, _coInvestments),
        const SizedBox(height: 22),
        _infoCard(
          Icons.auto_awesome_outlined,
          'This helps us personalise your deal flow and founder recommendations.',
        ),
      ],
    );
  }

  Widget _documentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Complete your verification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'As per Indian regulations, we need these documents before enabling investor access.',
          style: TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 24),
        _documentRow(Icons.badge_outlined, 'Aadhaar card', 'Identity document'),
        _documentRow(
          Icons.credit_card_outlined,
          'PAN card',
          'Tax identification document',
        ),
        _documentRow(
          Icons.description_outlined,
          'Income / net worth certificate',
          'Proof of investor suitability',
        ),
        const SizedBox(height: 20),
        _infoCard(
          Icons.verified_user_outlined,
          'All documents are encrypted and reviewed by the Collabster verification team.',
        ),
      ],
    );
  }

  Widget _consultationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: InvestorColors.goldShimmer,
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(radius: 62, backgroundColor: Colors.white54),
              Icon(Icons.handshake_rounded, size: 76, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'One-on-one verification',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Schedule a short conversation with our team to finish your investor verification.',
          style: TextStyle(color: _muted, height: 1.5),
        ),
        const SizedBox(height: 24),
        _checkLine('Video call with our verification expert'),
        _checkLine('Review of your documents and profile'),
        _checkLine('Investor suitability check'),
      ],
    );
  }

  Widget _bottomAction() {
    final label = switch (_step) {
      3 => 'Submit documents',
      4 => 'Continue to meeting details',
      _ => 'Continue',
    };
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: _continue,
            style: FilledButton.styleFrom(
              backgroundColor: _skyBluePrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingScreen() {
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 18),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _back,
                    icon: const Icon(Icons.arrow_back_rounded, color: _ink),
                    tooltip: 'Back',
                  ),
                  const Expanded(
                    child: Text(
                      'Your verification meeting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: InvestorColors.goldGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.video_call_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'One-on-one verification call',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Your meeting has been scheduled with our verification team.',
                            style: TextStyle(color: Colors.white, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Meeting details',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: InvestorColors.border),
                      ),
                      child: const Column(
                        children: [
                          _MeetingDetailRow(
                            icon: Icons.calendar_today_rounded,
                            label: 'Date',
                            value: '12 September 2026',
                          ),
                          Divider(height: 28, color: InvestorColors.border),
                          _MeetingDetailRow(
                            icon: Icons.access_time_rounded,
                            label: 'Time',
                            value: '3:00 PM - 3:20 PM IST',
                          ),
                          Divider(height: 28, color: InvestorColors.border),
                          _MeetingDetailRow(
                            icon: Icons.videocam_outlined,
                            label: 'Format',
                            value: 'Video call',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _skyBlueSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: _skyBluePrimary,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Keep your identity documents nearby. The call usually takes about 20 minutes.',
                              style: TextStyle(
                                color: _skyBlueDeep,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _completeMeeting,
                    style: FilledButton.styleFrom(
                      backgroundColor: _skyBluePrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text(
                      'Mark meeting as completed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  color: _skyBlueSoft,
                  shape: BoxShape.circle,
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      size: 62,
                      color: _skyBluePrimary,
                    ),
                    Positioned(
                      right: 18,
                      bottom: 18,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: _skyBluePrimary,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Verification completed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your investor profile is verified. You can now explore curated deal flow and connect with founders.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _skyBlueSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: InvestorColors.goldLight),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: _skyBluePrimary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Investor access is active',
                      style: TextStyle(
                        color: _skyBlueDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _openDashboard,
                  style: FilledButton.styleFrom(
                    backgroundColor: _skyBluePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Go to Investor Dashboard',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _skyBluePrimary),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE1E3E9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE1E3E9)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: _ink,
        ),
      ),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(color: _muted, fontSize: 13)),
    ],
  );

  Widget _multiChips(List<String> options, Set<String> selection) => Wrap(
    spacing: 9,
    runSpacing: 9,
    children: options.map((option) {
      final selected = selection.contains(option);
      return FilterChip(
        selected: selected,
        onSelected: (value) => setState(() {
          value ? selection.add(option) : selection.remove(option);
        }),
        label: Text(option),
        labelStyle: TextStyle(
          color: selected ? _skyBluePrimary : _ink,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
        selectedColor: _skyBlueSoft,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: selected ? _skyBluePrimary : const Color(0xFFE1E3E9),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
    }).toList(),
  );

  Widget _typeChoice(String title, String subtitle, IconData icon) {
    final selected = _investorType == title;
    return InkWell(
      onTap: () => setState(() => _investorType = title),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? InvestorColors.goldMist : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _skyBluePrimary : const Color(0xFFE5E7EB),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? _skyBluePrimary : _muted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? _skyBluePrimary : const Color(0xFFB1B6C2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentRow(IconData icon, String title, String subtitle) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEF0F4))),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _skyBlueSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _skyBluePrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                ],
              ),
            ),
            const Text(
              'Required',
              style: TextStyle(
                color: Color(0xFFD97706),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  Widget _infoCard(IconData icon, String text) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: InvestorColors.goldMist,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Icon(icon, color: _skyBluePrimary, size: 21),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4C4670),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _checkLine(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: _skyBluePrimary,
          size: 21,
        ),
        const SizedBox(width: 11),
        Text(
          text,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
