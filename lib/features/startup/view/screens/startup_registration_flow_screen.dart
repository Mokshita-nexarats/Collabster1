import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/startup_models.dart';
import '../../viewmodel/registration_state.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/utils/app_snackbar.dart';
import 'startup_success_screen.dart';

class StartupRegistrationFlowScreen extends ConsumerStatefulWidget {
  const StartupRegistrationFlowScreen({
    super.key,
    this.selectedRole = 'Startup',
  });

  final String selectedRole;

  @override
  ConsumerState<StartupRegistrationFlowScreen> createState() =>
      _StartupRegistrationFlowScreenState();
}

class _StartupRegistrationFlowScreenState
    extends ConsumerState<StartupRegistrationFlowScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _startupNameController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(
    text: 'United States',
  );
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _founderNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController(
    text: 'https://yourstartup.com',
  );
  final TextEditingController _incorporationController =
      TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();
  final TextEditingController _missionController = TextEditingController();
  final TextEditingController _visionController = TextEditingController();
  final TextEditingController _socialWebsiteController = TextEditingController(
    text: 'https://acme.ai',
  );
  final TextEditingController _socialLinkedInController = TextEditingController(
    text: 'linkedin.com/acme',
  );
  final TextEditingController _socialProductHuntController =
      TextEditingController(text: 'producthunt.com/acme');
  final TextEditingController _inviteEmailController = TextEditingController();
  final TextEditingController _useOfFundsController = TextEditingController();
  final TextEditingController _legalStructureController = TextEditingController(
    text: 'Private Limited',
  );
  String _phoneCode = '+91';
  bool _reviewConfirmed = false;
  final Set<String> _reviewExpanded = {'startup'};
  String? _verificationAppId;
  String? _verificationSubmittedOn;

  void _ensureVerificationMeta() {
    if (_verificationAppId != null) return;
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    _verificationAppId =
        'APP-${now.year}-${(now.millisecondsSinceEpoch % 900000) + 100000}';
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final h12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
    _verificationSubmittedOn =
        '${now.day} ${months[now.month - 1]} ${now.year}, '
        '$h12:${now.minute.toString().padLeft(2, '0')} $ampm';
  }

  File? _founderPhoto;
  File? _logoFile;
  File? _coverFile;
  File? _pitchDeckFile;
  File? _incorporationCertFile;
  File? _panCardFile;
  File? _gstCertFile;
  final List<File> _supportingDocs = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickFounderPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _sourceOption(
              Icons.photo_library_outlined,
              'Gallery',
              ImageSource.gallery,
            ),
            _sourceOption(
              Icons.camera_alt_outlined,
              'Camera',
              ImageSource.camera,
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    if (!kIsWeb) {
      final status = await _requestPermission(source);
      if (!status) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permission required to access photos. Please enable it in Settings.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (picked != null) setState(() => _founderPhoto = File(picked.path));
  }

  Widget _sourceOption(IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0284C7).withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0284C7), size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  // Kept for upcoming steps redesign (brand uploads).
  // ignore: unused_element
  Future<void> _pickImageFile({required String type}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload $type',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _sourceOption(
              Icons.photo_library_outlined,
              'Gallery',
              ImageSource.gallery,
            ),
            _sourceOption(
              Icons.camera_alt_outlined,
              'Camera',
              ImageSource.camera,
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    if (!kIsWeb) {
      final status = await _requestPermission(source);
      if (!status) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permission required to access photos. Please enable it in Settings.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (picked == null || !mounted) return;
    final file = File(picked.path);
    setState(() {
      switch (type) {
        case 'Logo':
          _logoFile = file;
        case 'Cover Image':
          _coverFile = file;
      }
    });
    if (mounted) {
      AppSnackBar.showSuccess(context, '$type uploaded');
    }
  }

  Future<void> _pickDocument({required String type}) async {
    final deckTypes = {
      'Pitch Deck',
      'Certificate of Incorporation',
      'PAN Card',
      'GST Certificate',
    };
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type == 'Pitch Deck'
          ? ['pdf', 'pptx', 'ppt']
          : deckTypes.contains(type)
          ? ['pdf', 'jpg', 'jpeg', 'png']
          : ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg'],
      allowMultiple: type == 'Supporting Documents',
    );
    if (result == null || result.files.isEmpty) return;
    if (!mounted) return;
    final files = result.files
        .where((f) => f.path != null)
        .map((f) => File(f.path!))
        .toList();
    if (files.isEmpty) return;
    setState(() {
      switch (type) {
        case 'Pitch Deck':
          _pitchDeckFile = files.first;
        case 'Certificate of Incorporation':
          _incorporationCertFile = files.first;
        case 'PAN Card':
          _panCardFile = files.first;
        case 'GST Certificate':
          _gstCertFile = files.first;
        case 'Supporting Documents':
          _supportingDocs.addAll(files);
      }
    });
    if (mounted) {
      AppSnackBar.showSuccess(context, '${files.length} file(s) uploaded');
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.camera.request();
      }
    } else {
      status = await Permission.photos.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.photos.request();
      }
      if (status.isPermanentlyDenied || status.isDenied) {
        status = await Permission.storage.status;
        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.storage.request();
        }
      }
    }
    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      openAppSettings();
      return false;
    }
    return status.isGranted || status.isLimited;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _startupNameController.dispose();
    _taglineController.dispose();
    _industryController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _founderNameController.dispose();
    _designationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _incorporationController.dispose();
    _shortDescriptionController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _missionController.dispose();
    _visionController.dispose();
    _socialWebsiteController.dispose();
    _socialLinkedInController.dispose();
    _socialProductHuntController.dispose();
    _inviteEmailController.dispose();
    _useOfFundsController.dispose();
    _legalStructureController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    final currentStep = ref.read(registrationViewModelProvider).currentStep;
    if (currentStep < RegistrationState.totalSteps - 1) {
      ref.read(registrationViewModelProvider.notifier).goToNextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
      return;
    }

    _publishStartup();
  }

  void _goToPreviousStep() {
    final currentStep = ref.read(registrationViewModelProvider).currentStep;
    if (currentStep > 0) {
      ref.read(registrationViewModelProvider.notifier).goToPreviousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
      return;
    }

    Navigator.pop(context);
  }

  void _showCountryPicker() {
    final countries = [
      'United States',
      'United Kingdom',
      'Canada',
      'Australia',
      'India',
      'Germany',
      'France',
      'Singapore',
      'Japan',
      'Brazil',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Country',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Text(
                        country,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        setState(() {
                          _countryController.text = country;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _publishStartup() async {
    final regState = ref.read(registrationViewModelProvider);
    final startupName = _startupNameController.text.trim();
    if (startupName.isEmpty) {
      _showComingSoon('Enter your startup name before publishing');
      return;
    }

    final createdStartupData = <String, dynamic>{
      'startupName': startupName,
      'startupIndustry': _industryController.text.trim(),
      'startupStage': regState.selectedStage,
      'startupTagline': _taglineController.text.trim(),
      'startupCountry': _countryController.text.trim(),
      'startupCity': _cityController.text.trim(),
      'startupDescription': _shortDescriptionController.text.trim(),
      'startupProblem': _problemController.text.trim(),
      'startupSolution': _solutionController.text.trim(),
      'startupMission': _missionController.text.trim(),
      'startupVision': _visionController.text.trim(),
      'startupWebsite': _websiteController.text.trim(),
      'startupIncorporationDate': _incorporationController.text.trim(),
      'startupFounderName': _founderNameController.text.trim(),
      'startupFounderDesignation': _designationController.text.trim(),
      'startupFounderEmail': _emailController.text.trim(),
      'startupFounderPhone': _phoneController.text.trim(),
      'startupFounderLinkedin': _linkedinController.text.trim(),
      'startupFounderBio': _bioController.text.trim(),
      'startupTeamSize': regState.selectedTeamSize,
      'startupFundingStage': regState.selectedFundingStage,
      'startupCurrentlyRaising': regState.currentlyRaising,
      'startupVisibility': regState.selectedVisibility,
    };
    final existingSession = ref.read(authViewModelProvider).session;

    // Save the profile before showing the confirmation screen so it survives
    // an app restart or an interrupted completion screen.
    await ref
        .read(authViewModelProvider.notifier)
        .updateStartupData(
          startupName: startupName,
          industry: _industryController.text.trim(),
          stage: regState.selectedStage,
          tagline: _taglineController.text.trim(),
          logoPath: _logoFile?.path,
          coverPath: _coverFile?.path,
          country: _countryController.text.trim(),
          city: _cityController.text.trim(),
          description: _shortDescriptionController.text.trim(),
          problem: _problemController.text.trim(),
          solution: _solutionController.text.trim(),
          mission: _missionController.text.trim(),
          vision: _visionController.text.trim(),
          website: _websiteController.text.trim(),
          incorporationDate: _incorporationController.text.trim(),
          founderName: _founderNameController.text.trim(),
          founderPhotoPath: _founderPhoto?.path,
          founderDesignation: _designationController.text.trim(),
          founderEmail: _emailController.text.trim(),
          founderPhone: _phoneController.text.trim().isEmpty
              ? ''
              : '$_phoneCode ${_phoneController.text.trim()}',
          founderLinkedin: _linkedinController.text.trim(),
          founderBio: _bioController.text.trim(),
          socialWebsite: _socialWebsiteController.text.trim(),
          socialLinkedin: _socialLinkedInController.text.trim(),
          socialProductHunt: _socialProductHuntController.text.trim(),
          useOfFunds: _useOfFundsController.text.trim(),
          teamSize: regState.selectedTeamSize,
          fundingStage: regState.selectedFundingStage,
          currentlyRaising: regState.currentlyRaising,
          visibility: regState.selectedVisibility,
          // Keep the first created workspace available when the user later joins
          // another startup and switches between the two.
          originalStartupName:
              existingSession?.originalStartupName ?? startupName,
          originalStartupData:
              existingSession?.originalStartupData ?? createdStartupData,
        );

    // --- Frontend registry: publish so Join Startup screen can find it ---
    final industry = _industryController.text.trim();
    final teamSizeStr = regState.selectedTeamSize; // e.g. '1-5'
    final teamCount = int.tryParse(teamSizeStr.split('-').first) ?? 1;
    ref
        .read(startupRegistryProvider.notifier)
        .addStartup(
          SuggestedStartup(
            name: startupName,
            industry: industry.isNotEmpty ? industry : 'Other',
            location: [
              _cityController.text.trim(),
              _countryController.text.trim(),
            ].where((s) => s.isNotEmpty).join(', '),
            teamMembers: teamCount,
            stage: regState.selectedStage,
            tags: industry.isNotEmpty ? [industry] : [],
            tagline: _taglineController.text.trim(),
            description: _shortDescriptionController.text.trim(),
            problem: _problemController.text.trim(),
            solution: _solutionController.text.trim(),
            mission: _missionController.text.trim(),
            vision: _visionController.text.trim(),
            website: _websiteController.text.trim(),
            founderName: _founderNameController.text.trim(),
            incorporationDate: _incorporationController.text.trim(),
          ),
        );
    // -----------------------------------------------------------------------

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartupSuccessScreen(
          startupName: startupName,
          selectedRole: widget.selectedRole,
          completion: 65,
          industry: _industryController.text.trim(),
          stage: regState.selectedStage,
          tagline: _taglineController.text.trim(),
          country: _countryController.text.trim(),
          city: _cityController.text.trim(),
          legalStructure: _legalStructureController.text.trim(),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    AppSnackBar.showInfo(context, '$feature is coming soon.');
  }

  // Kept for upcoming steps redesign (team invites).
  // ignore: unused_element
  void _inviteTeamMember() {
    final email = _inviteEmailController.text.trim();
    if (email.isEmpty) {
      _showComingSoon('Enter an email address first');
      return;
    }

    ref.read(registrationViewModelProvider.notifier).inviteTeamMember(email);
    _inviteEmailController.clear();

    AppSnackBar.showSuccess(context, 'Invitation sent to $email');
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registrationViewModelProvider);
    final progress = regState.progress;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0284C7)),
          onPressed: _goToPreviousStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${regState.currentStep + 1} of ${RegistrationState.totalSteps}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5B6272),
                    ),
                  ),
                  Text(
                    '${((progress * 100).round())}% Complete',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE0F2FE),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  ref
                      .read(registrationViewModelProvider.notifier)
                      .setCurrentStep(index);
                },
                children: [
                  _buildBasicInformationStep(),
                  _buildFounderInformationStep(),
                  _buildStartupDetailsStep(),
                  _buildBrandingStep(),
                  _buildSocialLinksStep(),
                  _buildTeamMembersStep(),
                  _buildFundingStep(),
                  _buildReviewStep(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFBAE6FD))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _goToPreviousStep,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: const Color(0xFF3B3B4F),
                    side: const BorderSide(color: Color(0xFF94A3B8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(regState.currentStep == 0 ? 'Back' : 'Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _goToNextStep,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    regState.currentStep == RegistrationState.totalSteps - 1
                        ? 'Publish'
                        : 'Next Step',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Kept for upcoming steps redesign (step scaffold).
  // ignore: unused_element
  Widget _buildStepScaffold({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBAE6FD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  // Kept for upcoming steps redesign (form fields).
  // ignore: unused_element
  Widget _field({
    required String label,
    required String hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3E4351),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  // Kept for upcoming steps redesign (skill chips).
  // ignore: unused_element
  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFFE0F2FE),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF0284C7) : const Color(0xFF3C4251),
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: selected ? const Color(0xFF0284C7) : const Color(0xFFD4D6E2),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }

  // Kept for upcoming steps redesign (team size selector).
  // ignore: unused_element
  Widget _teamSizeChip(String label) {
    final selected =
        ref.watch(registrationViewModelProvider).selectedTeamSize == label;
    return GestureDetector(
      onTap: () {
        ref.read(registrationViewModelProvider.notifier).selectTeamSize(label);
      },
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE0F2FE) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF0284C7) : const Color(0xFFD4D6E2),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF0284C7) : const Color(0xFF30384A),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInformationStep() {
    final nameValid = _startupNameController.text.trim().isNotEmpty;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tell us the basic details about your startup.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _basicLabel(
                  'Startup / Company Name',
                  required: true,
                  count: '${_startupNameController.text.length}/100',
                ),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _startupNameController,
                  hint: 'AI Vision Labs',
                  maxLength: 100,
                  suffix: nameValid
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 17,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 29),
                _basicLabel(
                  'Tagline (Optional)',
                  count: '${_taglineController.text.length}/120',
                ),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _taglineController,
                  hint: 'Making AI accessible for everyone',
                  maxLength: 120,
                ),
                const SizedBox(height: 29),
                _basicLabel('Website (Optional)'),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _websiteController,
                  hint: 'https://aivisionlabs.ai',
                  keyboardType: TextInputType.url,
                  prefix: const Icon(
                    Icons.language,
                    color: Color(0xFF5D6472),
                    size: 25,
                  ),
                ),
                const SizedBox(height: 37),
                const Divider(color: Color(0xFFBAE6FD), height: 1),
                const SizedBox(height: 39),
                _basicLabel('Country of Incorporation', required: true),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _countryController,
                  hint: 'India',
                  readOnly: true,
                  onTap: _showCountryPicker,
                  suffix: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF5D6472),
                  ),
                ),
                const SizedBox(height: 29),
                _basicLabel('Incorporation Date', required: true),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _incorporationController,
                  hint: '15 Feb 2024',
                  readOnly: true,
                  onTap: _pickIncorporationDate,
                  suffix: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF5D6472),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 29),
                _basicLabel('Legal Structure', required: true),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _legalStructureController,
                  hint: 'Private Limited',
                  readOnly: true,
                  onTap: _showLegalStructurePicker,
                  suffix: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF5D6472),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _basicLabel(String text, {bool required = false, String? count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF172033),
              ),
              children: required
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Color(0xFFD32F2F)),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        if (count != null)
          Text(
            count,
            style: const TextStyle(fontSize: 14, color: Color(0xFF5D6472)),
          ),
      ],
    );
  }

  Widget _basicTextField({
    required TextEditingController controller,
    required String hint,
    int? maxLength,
    TextInputType? keyboardType,
    Widget? prefix,
    Widget? suffix,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final hasFocusBorder =
        !readOnly &&
        controller == _startupNameController &&
        controller.text.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasFocusBorder
              ? const Color(0xFF0284C7)
              : const Color(0xFFBAE6FD),
          width: hasFocusBorder ? 1.3 : 1,
        ),
      ),
      child: Row(
        children: [
          if (prefix != null) ...[prefix, const SizedBox(width: 14)],
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              maxLength: maxLength,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) => const SizedBox.shrink(),
              keyboardType: keyboardType,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 17, color: Color(0xFF25283A)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF9CA0AD),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 19),
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  Future<void> _pickIncorporationDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1990),
      lastDate: now,
    );
    if (picked == null) return;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    setState(() {
      _incorporationController.text =
          '${picked.day} ${months[picked.month - 1]} ${picked.year}';
    });
  }

  void _showLegalStructurePicker() {
    const options = [
      'Private Limited',
      'LLP',
      'Partnership',
      'Sole Proprietorship',
      'Public Limited',
      'Section 8 Company',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Text(
                  'Select Legal Structure',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Text(
                        option,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: _legalStructureController.text == option
                          ? const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF0284C7),
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _legalStructureController.text = option;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFounderInformationStep() {
    final regState = ref.watch(registrationViewModelProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Details',
            style: TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Help us understand your business better.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _basicLabel('Industry', required: true),
                const SizedBox(height: 9),
                _businessPicker(
                  value: _industryController.text,
                  hint: 'Select industry',
                  onTap: () => _showBusinessOptions(
                    title: 'Select Industry',
                    options: const [
                      'Artificial Intelligence',
                      'FinTech',
                      'HealthTech',
                      'EdTech',
                      'E-commerce',
                      'SaaS',
                      'Climate Tech',
                      'Other',
                    ],
                    current: _industryController.text,
                    onSelected: (v) =>
                        setState(() => _industryController.text = v),
                  ),
                ),
                const SizedBox(height: 20),
                _basicLabel('Sub Industry', required: true),
                const SizedBox(height: 9),
                _businessPicker(
                  value: regState.subIndustry,
                  hint: 'Select sub industry',
                  onTap: () => _showBusinessOptions(
                    title: 'Select Sub Industry',
                    options: const [
                      'AI / Machine Learning',
                      'NLP',
                      'Computer Vision',
                      'Robotics',
                      'Data Analytics',
                      'Other',
                    ],
                    current: regState.subIndustry,
                    onSelected: (v) => ref
                        .read(registrationViewModelProvider.notifier)
                        .selectSubIndustry(v),
                  ),
                ),
                const SizedBox(height: 20),
                _basicLabel(
                  'What best describes your startup?',
                  required: true,
                ),
                const SizedBox(height: 9),
                _businessPicker(
                  value: regState.startupType,
                  hint: 'Select type',
                  onTap: () => _showBusinessOptions(
                    title: 'What best describes your startup?',
                    options: const [
                      'Product Company',
                      'Service Company',
                      'Marketplace',
                      'Platform',
                      'D2C Brand',
                      'Other',
                    ],
                    current: regState.startupType,
                    onSelected: (v) => ref
                        .read(registrationViewModelProvider.notifier)
                        .selectStartupType(v),
                  ),
                ),
                const SizedBox(height: 20),
                _basicLabel('Stage', required: true),
                const SizedBox(height: 9),
                _businessPicker(
                  value: regState.selectedStage,
                  hint: 'Select stage',
                  onTap: () => _showBusinessOptions(
                    title: 'Select Stage',
                    options: const [
                      'Idea',
                      'Prototype',
                      'Pre-Seed',
                      'Seed',
                      'Growth',
                    ],
                    current: regState.selectedStage,
                    onSelected: (v) => ref
                        .read(registrationViewModelProvider.notifier)
                        .selectStage(v),
                  ),
                ),
                const SizedBox(height: 20),
                _basicLabel('Primary Business Model'),
                const SizedBox(height: 9),
                _businessPicker(
                  value: regState.businessModel,
                  hint: 'Select business model',
                  onTap: () => _showBusinessOptions(
                    title: 'Select Business Model',
                    options: const [
                      'SaaS',
                      'Marketplace',
                      'Subscription',
                      'Freemium',
                      'Enterprise',
                      'Advertising',
                      'Transactional',
                      'Other',
                    ],
                    current: regState.businessModel,
                    onSelected: (v) => ref
                        .read(registrationViewModelProvider.notifier)
                        .selectBusinessModel(v),
                  ),
                ),
                const SizedBox(height: 20),
                _basicLabel(
                  'Short Description (Optional)',
                  count: '${_shortDescriptionController.text.length}/300',
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: TextFormField(
                    controller: _shortDescriptionController,
                    maxLines: 4,
                    maxLength: 300,
                    buildCounter:
                        (
                          context, {
                          required currentLength,
                          required isFocused,
                          maxLength,
                        }) => const SizedBox.shrink(),
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFF25283A),
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'We build AI-powered computer vision solutions for real-world applications.',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF9CA0AD),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _businessPicker({
    required String value,
    required String hint,
    required VoidCallback onTap,
  }) {
    final display = value.isEmpty ? hint : value;
    final isHint = value.isEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFBAE6FD)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                display,
                style: TextStyle(
                  fontSize: 17,
                  color: isHint
                      ? const Color(0xFF9CA0AD)
                      : const Color(0xFF25283A),
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF5D6472)),
          ],
        ),
      ),
    );
  }

  void _showBusinessOptions({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Text(
                        option,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: current == option
                          ? const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF0284C7),
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(option);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStartupDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Documents',
            style: TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload the required documents to verify your startup.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: Column(
              children: [
                _documentItem(
                  title: 'Certificate of Incorporation',
                  subtitle: 'PDF, JPG, PNG · Max 5MB',
                  required: true,
                  icon: Icons.file_copy_outlined,
                  file: _incorporationCertFile,
                  onUpload: () =>
                      _pickDocument(type: 'Certificate of Incorporation'),
                ),
                const SizedBox(height: 10),
                _documentItem(
                  title: 'PAN Card',
                  subtitle: 'PDF, JPG, PNG · Max 5MB',
                  required: true,
                  icon: Icons.badge_outlined,
                  file: _panCardFile,
                  onUpload: () => _pickDocument(type: 'PAN Card'),
                ),
                const SizedBox(height: 10),
                _documentItem(
                  title: 'GST Certificate',
                  subtitle: 'If applicable (PDF, JPG, PNG · Max 5MB)',
                  icon: Icons.receipt_long_outlined,
                  file: _gstCertFile,
                  onUpload: () => _pickDocument(type: 'GST Certificate'),
                ),
                const SizedBox(height: 10),
                _documentItem(
                  title: 'Pitch Deck',
                  subtitle: 'Optional (PDF, PPT, PPTX · Max 10MB)',
                  icon: Icons.insert_drive_file_outlined,
                  file: _pitchDeckFile,
                  onUpload: () => _pickDocument(type: 'Pitch Deck'),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock, size: 16, color: Color(0xFF0284C7)),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Your documents are secure and will be '
                          'used only for verification purposes.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onUpload,
    bool required = false,
    File? file,
  }) {
    final fileName = file?.path.split('/').last;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF172033),
                    ),
                    children: [
                      if (required)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: Color(0xFFD32F2F)),
                        ),
                    ],
                  ),
                ),
              ),
              if (file != null)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: Color(0xFF4CAF50),
                )
              else
                Icon(icon, size: 18, color: const Color(0xFF5D6472)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            fileName ?? subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: fileName != null
                  ? const Color(0xFF0284C7)
                  : const Color(0xFF5D6472),
              fontWeight: fileName != null ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onUpload,
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.file_upload_outlined,
                    size: 18,
                    color: Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    file != null ? 'Replace' : 'Upload',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Founder / Owner Information',
            style: TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tell us about the primary founder or owner.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickFounderPhoto,
                        child: Stack(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE0F2FE),
                                border: Border.all(
                                  color: const Color(0xFFBAE6FD),
                                ),
                                image: _founderPhoto != null
                                    ? DecorationImage(
                                        image: FileImage(_founderPhoto!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _founderPhoto != null
                                  ? null
                                  : const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Color(0xFF5D6472),
                                    ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF0284C7),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _pickFounderPhoto,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0284C7),
                        ),
                        child: Text(
                          _founderPhoto != null
                              ? 'Change Photo'
                              : 'Upload Photo',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _basicLabel('Full Name', required: true),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _founderNameController,
                  hint: 'Arjun Patel',
                ),
                const SizedBox(height: 20),
                _basicLabel('Email Address', required: true),
                const SizedBox(height: 9),
                _basicTextField(
                  controller: _emailController,
                  hint: 'arjun.patel@aivisionlabs.ai',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _basicLabel('Phone Number', required: true),
                const SizedBox(height: 9),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _showPhoneCodePicker,
                      child: Container(
                        height: 62,
                        width: 96,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _phoneCode,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF25283A),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: Color(0xFF5D6472),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _basicTextField(
                        controller: _phoneController,
                        hint: '98765 43210',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _basicLabel('Designation / Role', required: true),
                const SizedBox(height: 9),
                _businessPicker(
                  value: _designationController.text,
                  hint: 'Select role',
                  onTap: () => _showBusinessOptions(
                    title: 'Select Designation / Role',
                    options: const [
                      'CEO & Co-Founder',
                      'Founder',
                      'Co-Founder',
                      'CTO',
                      'CFO',
                      'COO',
                      'Other',
                    ],
                    current: _designationController.text,
                    onSelected: (v) =>
                        setState(() => _designationController.text = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhoneCodePicker() {
    const codes = ['+91', '+1', '+44', '+61', '+971', '+65'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Text(
                  'Select Country Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: codes.length,
                  itemBuilder: (context, index) {
                    final code = codes[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Text(
                        code,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: _phoneCode == code
                          ? const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF0284C7),
                            )
                          : null,
                      onTap: () {
                        setState(() => _phoneCode = code);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // Kept for upcoming steps redesign (brand uploads).
  // ignore: unused_element
  Widget _uploadPanel({
    required String title,
    required String subtitle,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
    String? statusLabel,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFD5CEE9),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE9E1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0284C7)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5B6272),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hint,
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      color: Color(0xFF8A90A0),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (statusLabel != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7ED),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F9B54),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinksStep() {
    final members = ref.watch(registrationViewModelProvider).members;
    const avatarBgs = [Color(0xFFE0F2FE), Color(0xFFE0F2FE), Color(0xFFF1F5F9)];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Co-founders / Core Team',
            style: TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add the key individuals building this enterprise. This '
            'helps establish authority and access.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Team Members',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFBAE6FD)),
                const SizedBox(height: 10),
                if (members.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No team members yet. Tap below to add your first co-founder.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D6472),
                        ),
                      ),
                    ),
                  ),
                for (int i = 0; i < members.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i == members.length - 1 ? 0 : 9,
                    ),
                    child: _cofounderTile(
                      name: members[i].name,
                      role: members[i].role,
                      status: members[i].status,
                      initials: members[i].initials,
                      avatarBg: avatarBgs[i % avatarBgs.length],
                      onDelete: () {
                        ref
                            .read(registrationViewModelProvider.notifier)
                            .removeTeamMemberAt(i);
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _showAddTeamMemberDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0284C7),
                      side: const BorderSide(color: Color(0xFF0284C7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 5),
                        Text(
                          'Add Team Member',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cofounderTile({
    required String name,
    required String role,
    required String status,
    required String initials,
    required Color avatarBg,
    required VoidCallback onDelete,
  }) {
    final isFounder = role.toLowerCase().contains('founder');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: avatarBg),
            alignment: Alignment.center,
            child: Text(
              initials.isEmpty ? '?' : initials,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D6472),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA0AD),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: isFounder
                  ? const Color(0xFFE0F2FE)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isFounder ? 'Co-Founder' : 'Core Team',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isFounder
                    ? const Color(0xFF0284C7)
                    : const Color(0xFF5D6472),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
              color: Color(0xFF5D6472),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTeamMemberDialog() {
    final emailController = TextEditingController();
    String selectedRole = 'Co-Founder';
    const roles = [
      'Co-Founder',
      'Founder',
      'CTO',
      'Head of Product',
      'Head of Design',
      'Core Team',
    ];
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text(
            'Add Team Member',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'name@company.com',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                items: roles
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setDialogState(() => selectedRole = v);
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isEmpty) return;
                ref
                    .read(registrationViewModelProvider.notifier)
                    .inviteTeamMember(email, role: selectedRole);
                Navigator.pop(ctx);
                AppSnackBar.showSuccess(context, 'Invitation sent to $email');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
              ),
              child: const Text('Invite'),
            ),
          ],
        ),
      ),
    );
  }

  // Kept for upcoming steps redesign (social links row).
  // ignore: unused_element
  Widget _linkRow(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE2EAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF374151)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showComingSoon('Edit $label'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembersStep() {
    final regState = ref.watch(registrationViewModelProvider);
    final members = regState.members;
    final docCount = [
      _incorporationCertFile,
      _panCardFile,
      _gstCertFile,
      _pitchDeckFile,
    ].whereType<File>().length;
    String val(String v) => v.trim().isEmpty ? '—' : v.trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review & Submit',
            style: TextStyle(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please review all information before submitting.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 16),
          _reviewSection(
            key: 'startup',
            icon: Icons.business,
            title: 'Startup Information',
            editStep: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _reviewInfo('Name', val(_startupNameController.text)),
                  const SizedBox(height: 17),
                  _reviewInfo('Tagline', val(_taglineController.text)),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: _reviewInfo(
                          'Industry',
                          val(_industryController.text),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Stage',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5D6472),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                regState.selectedStage,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF25283A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: _reviewInfo(
                          'Country',
                          val(_countryController.text),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: _reviewInfo(
                          'Date Founded',
                          val(_incorporationController.text),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  _reviewInfo('Structure', val(_legalStructureController.text)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _reviewSection(
            key: 'founder',
            icon: Icons.person_outline,
            title: 'Founder / Owner',
            editStep: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _reviewInfo('Name', val(_founderNameController.text)),
                  const SizedBox(height: 17),
                  _reviewInfo('Email', val(_emailController.text)),
                  const SizedBox(height: 17),
                  _reviewInfo(
                    'Phone',
                    _phoneController.text.trim().isEmpty
                        ? '—'
                        : '$_phoneCode ${_phoneController.text.trim()}',
                  ),
                  const SizedBox(height: 17),
                  _reviewInfo('Designation', val(_designationController.text)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _reviewSection(
            key: 'team',
            icon: Icons.groups_outlined,
            title: 'Team Members',
            subtitle:
                '${members.length} member${members.length == 1 ? '' : 's'}',
            editStep: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: members.isEmpty
                  ? const Text(
                      'No team members added yet.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF5D6472)),
                    )
                  : Column(
                      children: [
                        for (final m in members)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE0F2FE),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    m.initials.isEmpty ? '?' : m.initials,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF172033),
                                        ),
                                      ),
                                      Text(
                                        m.role,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF5D6472),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  m.status,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA0AD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          _reviewSection(
            key: 'docs',
            icon: Icons.description_outlined,
            title: 'Documents',
            subtitle: '$docCount document${docCount == 1 ? '' : 's'}',
            editStep: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                children: [
                  _reviewDocRow(
                    'Certificate of Incorporation',
                    _incorporationCertFile,
                  ),
                  _reviewDocRow('PAN Card', _panCardFile),
                  _reviewDocRow('GST Certificate', _gstCertFile),
                  _reviewDocRow('Pitch Deck', _pitchDeckFile),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => setState(() => _reviewConfirmed = !_reviewConfirmed),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _reviewConfirmed
                          ? const Color(0xFF0284C7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: _reviewConfirmed
                            ? const Color(0xFF0284C7)
                            : const Color(0xFF94A3B8),
                        width: 2,
                      ),
                    ),
                    child: _reviewConfirmed
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'I confirm that all information provided is '
                      'true and accurate to the best of my knowledge.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF29283A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(color: Color(0xFFBAE6FD)),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 53,
            child: ElevatedButton(
              onPressed: () {
                if (!_reviewConfirmed) {
                  AppSnackBar.showInfo(
                    context,
                    'Please confirm the information is accurate first',
                  );
                  return;
                }
                _goToNextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _reviewConfirmed
                    ? const Color(0xFF0284C7)
                    : const Color(0xFF94A3B8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit Application',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _jumpToReviewStep(int index) {
    ref.read(registrationViewModelProvider.notifier).setCurrentStep(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  Widget _reviewSection({
    required String key,
    required IconData icon,
    required String title,
    required int editStep,
    String? subtitle,
    Widget? child,
  }) {
    final expanded = _reviewExpanded.contains(key);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              if (expanded) {
                _reviewExpanded.remove(key);
              } else {
                _reviewExpanded.add(key);
              }
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: expanded ? Radius.zero : const Radius.circular(12),
                ),
                border: expanded
                    ? const Border(bottom: BorderSide(color: Color(0xFFBAE6FD)))
                    : null,
              ),
              child: Row(
                children: [
                  _reviewIconCircle(icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF172033),
                          ),
                        ),
                        if (subtitle != null && !expanded)
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5D6472),
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _jumpToReviewStep(editStep),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: const Color(0xFF5D6472),
                  ),
                ],
              ),
            ),
          ),
          if (expanded && child != null) child,
        ],
      ),
    );
  }

  Widget _reviewIconCircle(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFFE0F2FE),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF0284C7)),
    );
  }

  Widget _reviewInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF5D6472)),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Color(0xFF172033)),
        ),
      ],
    );
  }

  Widget _reviewDocRow(String label, File? file) {
    final picked = file != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            picked ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 18,
            color: picked ? const Color(0xFF4CAF50) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172033),
                  ),
                ),
                if (picked)
                  Text(
                    file.path.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0284C7),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            picked ? 'Uploaded' : 'Missing',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: picked ? const Color(0xFF4CAF50) : const Color(0xFF9CA0AD),
            ),
          ),
        ],
      ),
    );
  }

  // Kept for upcoming steps redesign (member tiles).
  // ignore: unused_element
  Widget _buildMemberTile(StartupMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: const Color(0xFFE0F2FE),
            child: Text(
              member.initials,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  member.role,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D6472),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: member.status == 'Active'
                  ? const Color(0xFFE7F8EA)
                  : const Color(0xFFF1EFFA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              member.status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: member.status == 'Active'
                    ? const Color(0xFF1C8B46)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingStep() {
    _ensureVerificationMeta();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            'Verification',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your application is under review.',
            style: TextStyle(fontSize: 16, color: Color(0xFF5D6472)),
          ),
          const SizedBox(height: 32),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0F2FE),
              border: Border.all(color: const Color(0xFFBAE6FD), width: 5),
            ),
            child: const Center(
              child: Icon(
                Icons.assignment_turned_in,
                size: 58,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 9, color: Color(0xFFD97706)),
                SizedBox(width: 8),
                Text(
                  'Under Review',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF25283A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Your application has been submitted '
              'successfully and is currently being '
              'reviewed by our team.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Color(0xFF5D6472),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Column(
              children: [
                _verificationDetail(
                  'Application ID',
                  _verificationAppId ?? '—',
                ),
                const Divider(height: 1, color: Color(0xFFBAE6FD)),
                _verificationDetail(
                  'Submitted On',
                  _verificationSubmittedOn ?? '—',
                ),
                const Divider(height: 1, color: Color(0xFFBAE6FD)),
                _verificationDetail(
                  'Status',
                  '• Under Review',
                  valueColor: const Color(0xFFD97706),
                ),
                const Divider(height: 1, color: Color(0xFFBAE6FD)),
                _verificationDetail('Estimated Time', '2-3 Business Days'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF0284C7), size: 23),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We will review your application and get '
                    'back to you via email. You can track the '
                    'status anytime.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 53,
            child: OutlinedButton(
              onPressed: _goToNextStep,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0284C7),
                side: const BorderSide(color: Color(0xFF0284C7), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Track Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationDetail(
    String title,
    String value, {
    Color valueColor = const Color(0xFF172033),
  }) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF5D6472)),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    _ensureVerificationMeta();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/company_verification.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.verified_rounded,
                  size: 72,
                  color: Color(0xFF0284C7),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Your company is being\nverified',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              final id = _verificationAppId;
              if (id == null) return;
              Clipboard.setData(ClipboardData(text: id));
              AppSnackBar.showSuccess(context, 'Application ID copied');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Application ID: ${_verificationAppId ?? '—'}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5D6472),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.copy_outlined,
                    size: 17,
                    color: Color(0xFF5D6472),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info, size: 21, color: Color(0xFF0284C7)),
                SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text:
                          'Verification in progress. Estimated\n'
                          'review time: ',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.45,
                        color: Color(0xFF25283A),
                      ),
                      children: [
                        TextSpan(
                          text: '1–2 business days.',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _verificationTimelineItem(
            title: 'Application Submitted',
            status: _TimelineStatus.completed,
          ),
          _verificationTimelineItem(
            title: 'Company Details Verified',
            status: _TimelineStatus.completed,
          ),
          _verificationTimelineItem(
            title: 'Tax Verification',
            description:
                'We are currently reviewing your submitted\n'
                'tax documents and corporate structure.',
            status: _TimelineStatus.current,
          ),
          _verificationTimelineItem(
            title: 'Ownership Verification',
            status: _TimelineStatus.pending,
          ),
          _verificationTimelineItem(
            title: 'Final Document Review',
            status: _TimelineStatus.pending,
            isLast: true,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 53,
            child: ElevatedButton(
              onPressed: _publishStartup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Return to Dashboard',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationTimelineItem({
    required String title,
    required _TimelineStatus status,
    String? description,
    bool isLast = false,
  }) {
    final bool completed = status == _TimelineStatus.completed;
    final bool current = status == _TimelineStatus.current;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: Column(
            children: [
              Container(
                width: current ? 18 : 24,
                height: current ? 18 : 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed
                      ? const Color(0xFF4CAF50)
                      : current
                      ? const Color(0xFF0284C7)
                      : const Color(0xFFE2E8F0),
                  border: current
                      ? Border.all(color: const Color(0xFFBAE6FD), width: 4)
                      : null,
                ),
                child: completed
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: description != null ? 83 : 42,
                  color: completed
                      ? const Color(0xFF0284C7)
                      : const Color(0xFFE2E8F0),
                ),
            ],
          ),
        ),
        const SizedBox(width: 17),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                    color: current
                        ? const Color(0xFF0284C7)
                        : const Color(0xFF25283A),
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF5D6472),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Kept for upcoming steps redesign (review cards).
  // ignore: unused_element
  Widget _reviewCard(String title, String subtitle, int stepIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D6472),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                stepIndex,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

enum _TimelineStatus { completed, current, pending }
