import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import 'idea_phase_dashboard_screen.dart';

/// Lightweight verification for founders who have an idea but are not yet a
/// registered company. It intentionally does not request incorporation papers.
class IdeaPhaseVerificationScreen extends ConsumerStatefulWidget {
  const IdeaPhaseVerificationScreen({super.key});

  @override
  ConsumerState<IdeaPhaseVerificationScreen> createState() =>
      _IdeaPhaseVerificationScreenState();
}

class _IdeaPhaseVerificationScreenState
    extends ConsumerState<IdeaPhaseVerificationScreen> {
  static const _primary = InvestorColors.goldPrimary;
  static const _deep = InvestorColors.goldDeep;
  static const _soft = InvestorColors.goldSoft;
  static const _canvas = Color(0xFFF8FCFF);
  static const _ink = Color(0xFF13233B);
  static const _muted = Color(0xFF64748B);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ideaNameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _problemController = TextEditingController();
  final _websiteController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _industry = <String>{};
  final _validation = <String>{};
  final _imagePicker = ImagePicker();

  File? _profilePhoto;

  int _step = -1;

  @override
  void initState() {
    super.initState();
    final session = ref.read(authViewModelProvider).session;
    _nameController.text = session?.fullName ?? '';
    _emailController.text = session?.email ?? '';
    _phoneController.text = session?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ideaNameController.dispose();
    _taglineController.dispose();
    _problemController.dispose();
    _websiteController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step == 0 &&
        (_nameController.text.trim().isEmpty ||
            _emailController.text.trim().isEmpty ||
            _phoneController.text.trim().isEmpty)) {
      _message('Add your name, email, and mobile number to continue.');
      return;
    }
    if (_step == 1 &&
        (_ideaNameController.text.trim().isEmpty ||
            _taglineController.text.trim().isEmpty ||
            _industry.isEmpty)) {
      _message('Add an idea name, short description, and industry.');
      return;
    }
    if (_step == 2 && _validation.isEmpty) {
      _message('Select at least one way you are validating the idea.');
      return;
    }
    if (_step == 4) {
      await _submitIdea();
      return;
    }
    setState(() => _step++);
  }

  Future<void> _submitIdea() async {
    await ref.read(authViewModelProvider.notifier).updateIdeaPhaseData({
      'founderName': _nameController.text.trim(),
      'founderEmail': _emailController.text.trim(),
      'founderPhone': _phoneController.text.trim(),
      'profilePhotoPath': _profilePhoto?.path,
      'ideaName': _ideaNameController.text.trim(),
      'tagline': _taglineController.text.trim(),
      'problem': _problemController.text.trim(),
      'industries': _industry.toList(),
      'validation': _validation.toList(),
      'website': _websiteController.text.trim(),
      'linkedin': _linkedinController.text.trim(),
      'status': 'under_review',
      'submittedAt': DateTime.now().toIso8601String(),
    });
    if (!mounted) return;
    setState(() => _step = 5);
  }

  Future<void> _pickProfilePhoto(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (image == null || !mounted) return;
    setState(() => _profilePhoto = File(image.path));
  }

  Future<void> _showPhotoPicker() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
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
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Add profile photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: _primary,
              ),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: _primary),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source != null) await _pickProfilePhoto(source);
  }

  void _back() {
    if (_step <= -1) {
      Navigator.maybePop(context);
      return;
    }
    setState(() => _step--);
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_step == -1) return _intro();
    if (_step == 5) return _submitted();

    const titles = [
      'Founder profile',
      'Your idea',
      'Validation plan',
      'Supporting information',
      'Review your idea',
    ];
    const subtitles = [
      'Tell us who is building this idea.',
      'Share the problem you want to solve.',
      'Show how you are testing the opportunity.',
      'Add links that bring your idea to life.',
      'Check everything before you submit.',
    ];

    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Column(
          children: [
            _header(titles[_step], subtitles[_step]),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: _content(),
              ),
            ),
            _bottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _intro() {
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
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  gradient: InvestorColors.goldGradient,
                  borderRadius: BorderRadius.circular(27),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Verify your idea',
                style: TextStyle(
                  color: _ink,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Build trust around your early-stage idea and get ready for meaningful feedback, collaborators, and future opportunities.',
                style: TextStyle(color: _muted, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              _benefit(
                Icons.verified_user_outlined,
                'Create an idea profile',
                'Share a clear, verified snapshot of what you are building.',
              ),
              _benefit(
                Icons.people_outline_rounded,
                'Find early collaborators',
                'Connect with people who can help you validate and build.',
              ),
              _benefit(
                Icons.insights_outlined,
                'Learn what comes next',
                'Get a practical foundation before you register a company.',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _next,
                  style: _primaryButtonStyle,
                  child: const Text(
                    'Start your ideal journey',
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
                            ? _primary
                            : const Color(0xFFF0F5F8),
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
                              ? _primary
                              : const Color(0xFFE1EAF0),
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

  Widget _content() {
    return switch (_step) {
      0 => _founderStep(),
      1 => _ideaStep(),
      2 => _validationStep(),
      3 => _supportStep(),
      _ => _reviewStep(),
    };
  }

  Widget _founderStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start with the person behind the idea',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'No company registration is needed at this stage. We only use these details to make your profile credible.',
          style: TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 26),
        Center(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: _soft,
                    backgroundImage: _profilePhoto == null
                        ? null
                        : FileImage(_profilePhoto!),
                    child: _profilePhoto == null
                        ? const Icon(
                            Icons.person_outline_rounded,
                            color: _primary,
                            size: 38,
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Material(
                      color: _primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: _showPhotoPicker,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _showPhotoPicker,
                icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                label: Text(
                  _profilePhoto == null ? 'Add profile photo' : 'Change photo',
                ),
                style: TextButton.styleFrom(foregroundColor: _primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _field('Your name', _nameController, Icons.person_outline_rounded),
        const SizedBox(height: 16),
        _field(
          'Email address',
          _emailController,
          Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _field(
          'Mobile number',
          _phoneController,
          Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 22),
        _infoCard(
          Icons.shield_outlined,
          'Your contact details stay private. They are used only to confirm ownership of this idea profile.',
        ),
      ],
    );
  }

  Widget _ideaStep() {
    const industries = [
      'AI & ML',
      'FinTech',
      'HealthTech',
      'EdTech',
      'Climate',
      'Consumer',
      'SaaS',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Give your idea a clear identity',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'A working name is enough. You can refine this later as your idea grows.',
          style: TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 26),
        _field(
          'Idea name',
          _ideaNameController,
          Icons.lightbulb_outline_rounded,
        ),
        const SizedBox(height: 16),
        _field(
          'One-line description',
          _taglineController,
          Icons.short_text_rounded,
          hint: 'What are you building?',
        ),
        const SizedBox(height: 16),
        _field(
          'Problem you want to solve (optional)',
          _problemController,
          Icons.manage_search_rounded,
          maxLines: 4,
          hint: 'Describe the customer problem in your own words.',
        ),
        const SizedBox(height: 24),
        _sectionTitle('Industry', 'Choose the spaces your idea belongs to.'),
        const SizedBox(height: 12),
        _chips(industries, _industry),
      ],
    );
  }

  Widget _validationStep() {
    const options = [
      ('I have spoken to potential users', Icons.forum_outlined),
      ('I have a prototype or wireframe', Icons.design_services_outlined),
      ('I have researched the market', Icons.travel_explore_rounded),
      ('I have early interest or sign-ups', Icons.group_add_outlined),
      ('I am looking for a co-founder', Icons.handshake_outlined),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How far have you explored the idea?',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'There is no minimum requirement. This helps us understand the support that will be most useful.',
          style: TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 22),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _selectCard(option.$1, option.$2, _validation),
          ),
        ),
        const SizedBox(height: 12),
        _infoCard(
          Icons.tips_and_updates_outlined,
          'An idea can be at any stage. Honest details help us point you to the right next step.',
        ),
      ],
    );
  }

  Widget _supportStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bring your idea to life',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Links are optional. Add anything that helps reviewers understand your direction.',
          style: TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 26),
        _field(
          'Prototype, landing page, or pitch link (optional)',
          _websiteController,
          Icons.link_rounded,
          keyboardType: TextInputType.url,
          hint: 'https://',
        ),
        const SizedBox(height: 16),
        _field(
          'LinkedIn profile (optional)',
          _linkedinController,
          Icons.person_pin_outlined,
          keyboardType: TextInputType.url,
          hint: 'https://linkedin.com/in/',
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: InvestorColors.border),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome_outlined, color: _primary),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  'You do not need a registered company, pitch deck, or financial documents for Idea Phase verification.',
                  style: TextStyle(color: _deep, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reviewStep() {
    final name = _ideaNameController.text.trim().isEmpty
        ? 'Your idea'
        : _ideaNameController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ready to submit?',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Review the essentials below. You can update your idea profile after verification.',
          style: TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 24),
        _reviewCard(
          icon: Icons.person_outline_rounded,
          title: 'Founder',
          values: [
            _nameController.text.trim(),
            _emailController.text.trim(),
            _phoneController.text.trim(),
          ],
        ),
        const SizedBox(height: 12),
        _reviewCard(
          icon: Icons.lightbulb_outline_rounded,
          title: name,
          values: [_taglineController.text.trim(), _industry.join(' · ')],
        ),
        const SizedBox(height: 12),
        _reviewCard(
          icon: Icons.insights_outlined,
          title: 'Validation progress',
          values: _validation.toList(),
        ),
        const SizedBox(height: 20),
        _infoCard(
          Icons.verified_user_outlined,
          'We review idea profiles for clarity, authenticity, and community fit. This is not a legal company verification.',
        ),
      ],
    );
  }

  Widget _submitted() {
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
                decoration: const BoxDecoration(
                  color: _soft,
                  shape: BoxShape.circle,
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_top_rounded,
                      color: _primary,
                      size: 62,
                    ),
                    Positioned(
                      right: 18,
                      bottom: 18,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: _primary,
                        child: Icon(Icons.check_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Idea submitted for review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Our team will review your idea profile and let you know when it is ready to share with the community.',
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
                  color: _soft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: InvestorColors.goldLight),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule_rounded, color: _primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Usually reviewed within 1-2 days',
                      style: TextStyle(
                        color: _deep,
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const IdeaPhaseDashboardScreen(),
                      ),
                    );
                  },
                  style: _primaryButtonStyle,
                  child: const Text(
                    'Go to Dashboard',
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

  Widget _bottomAction() {
    final label = _step == 4 ? 'Submit idea for review' : 'Continue';
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: _next,
            style: _primaryButtonStyle,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? hint,
    int maxLines = 1,
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
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: maxLines == 1 ? Icon(icon, color: _primary) : null,
            alignLabelWithHint: maxLines > 1,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: InvestorColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: InvestorColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _primary, width: 1.5),
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
        style: const TextStyle(color: _ink, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 3),
      Text(subtitle, style: const TextStyle(color: _muted, fontSize: 13)),
    ],
  );

  Widget _chips(List<String> values, Set<String> selected) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: values.map((value) {
      final isSelected = selected.contains(value);
      return FilterChip(
        label: Text(value),
        selected: isSelected,
        onSelected: (enabled) => setState(() {
          enabled ? selected.add(value) : selected.remove(value);
        }),
        selectedColor: _soft,
        backgroundColor: Colors.white,
        checkmarkColor: _primary,
        labelStyle: TextStyle(
          color: isSelected ? _deep : _ink,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        ),
        side: BorderSide(color: isSelected ? _primary : InvestorColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
    }).toList(),
  );

  Widget _selectCard(String title, IconData icon, Set<String> selectedValues) {
    final selected = selectedValues.contains(title);
    return InkWell(
      onTap: () => setState(() {
        selected ? selectedValues.remove(title) : selectedValues.add(title);
      }),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? InvestorColors.goldMist : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _primary : InvestorColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? _primary : _muted),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? _primary : const Color(0xFFB1B6C2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefit(IconData icon, String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _soft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _deep, size: 21),
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
                style: const TextStyle(color: _muted, height: 1.35),
              ),
            ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primary, size: 21),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: _deep, fontSize: 13, height: 1.4),
          ),
        ),
      ],
    ),
  );

  Widget _reviewCard({
    required IconData icon,
    required String title,
    required List<String> values,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: InvestorColors.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _soft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primary),
        ),
        const SizedBox(width: 12),
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
              const SizedBox(height: 4),
              ...values
                  .where((value) => value.isNotEmpty)
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        value,
                        style: const TextStyle(color: _muted, fontSize: 13),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    ),
  );

  ButtonStyle get _primaryButtonStyle => FilledButton.styleFrom(
    backgroundColor: _primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}
