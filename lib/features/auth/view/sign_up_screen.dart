import 'package:flutter/foundation.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../../core/theme/app_assets.dart';
import '../../../shared/enums/app_enums.dart';
import '../model/auth_session.dart';
import '../../../core/di/providers.dart';
import '../../../shared/utils/app_snackbar.dart';
import '../viewmodel/sign_up_state.dart';
import 'secondary_goal_screen.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({
    super.key,
    this.initialPage = 0,
    this.initialRole,
    this.prefilledFullName,
    this.prefilledEmail,
    this.prefilledPhone,
    this.prefilledPassword,
  });

  /// 0 = basic details, 1 = personal info, 2 = role selection
  final int initialPage;

  /// Optional role to pre-select when returning from another screen
  final UserRole? initialRole;

  final String? prefilledFullName;
  final String? prefilledEmail;
  final String? prefilledPhone;
  final String? prefilledPassword;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final PageController _pageController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(
    text: 'India',
  );
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.prefilledFullName);
    _emailController = TextEditingController(text: widget.prefilledEmail);
    _phoneController = TextEditingController(text: widget.prefilledPhone);
    _passwordController = TextEditingController(text: widget.prefilledPassword);
    _confirmPasswordController = TextEditingController(text: widget.prefilledPassword);

    _pageController = PageController(initialPage: widget.initialPage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signUpViewModelProvider.notifier).setCurrentStep(widget.initialPage);
      if (widget.initialRole != null) {
        ref.read(signUpViewModelProvider.notifier).selectRole(widget.initialRole!);
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _validateBasicDetails() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty) {
      _showMessage('Please enter your full name.');
      return false;
    }

    if (email.isEmpty) {
      _showMessage('Please enter your email address.');
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showMessage('Please enter a valid email address.');
      return false;
    }

    if (phone.isEmpty) {
      _showMessage('Please enter your phone number.');
      return false;
    }

    if (password.isEmpty) {
      _showMessage('Please enter a password.');
      return false;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters long.');
      return false;
    }

    if (confirmPassword.isEmpty) {
      _showMessage('Please confirm your password.');
      return false;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return false;
    }

    return true;
  }

  void _nextStep() {
    final currentStep = ref.read(signUpViewModelProvider).currentStep;
    final notifier = ref.read(signUpViewModelProvider.notifier);

    if (currentStep == 0) {
      if (!_validateBasicDetails()) return;
    }

    if (currentStep < 2) {
      notifier.goToNextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeRegistration();
    }
  }

  Future<void> _completeRegistration() async {
    final notifier = ref.read(signUpViewModelProvider.notifier);

    if (!_validateBasicDetails()) {
      notifier.setCurrentStep(0);
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final state = ref.read(signUpViewModelProvider);
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    await ref.read(authViewModelProvider.notifier).signUp(
      AuthSession(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        role: state.selectedRole.name,
        onboardingComplete: true,
        username: _usernameController.text.trim().isEmpty
            ? null
            : _usernameController.text.trim(),
        dateOfBirth: state.dateOfBirth?.toIso8601String(),
        gender: state.selectedGender,
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        profilePhotoLabel: state.photoUploaded ? state.photoLabel : null,
        profilePhotoPath: state.profilePhotoPath,
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecondaryGoalScreen(),
      ),
    );
  }

  void _prevStep() {
    final currentStep = ref.read(signUpViewModelProvider).currentStep;
    final notifier = ref.read(signUpViewModelProvider.notifier);

    if (currentStep > 0) {
      notifier.goToPreviousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent, // transparent scaffold body
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                AppAssets.landingBg,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.70),
                      Colors.black.withOpacity(0.40),
                      Colors.black.withOpacity(0.80),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Content body
            SafeArea(
              child: Column(
                children: [
                  // App navigation bar
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: IconButton(
                          onPressed: _prevStep,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Logo and App Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CollabsterLogo(size: 38),
                      const SizedBox(width: 10),
                      const Text(
                        'CollobSter',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  _buildProgressBar(state),
                  const SizedBox(height: 16),

                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          hintStyle: const TextStyle(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.25),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: const Color(0xFF8B6FFF).withOpacity(0.25),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFB5A4FF),
                              width: 1.8,
                            ),
                          ),
                        ),
                      ),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          ref.read(signUpViewModelProvider.notifier).setCurrentStep(index);
                        },
                        children: [
                          _buildBasicDetailsStep(state),
                          _buildPersonalDetailsStep(state),
                          _buildRoleSelectionStep(state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(SignUpState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 4,
              decoration: BoxDecoration(
                color: index <= state.currentStep
                    ? const Color(0xFFB5A4FF) // bright lavender for active steps
                    : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicDetailsStep(SignUpState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0B30).withOpacity(0.80),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF8B6FFF).withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Let's begin with your basic details.",
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
                const SizedBox(height: 28),
                _buildTextFieldLabel('Full Name'),
                TextFormField(
                  controller: _fullNameController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(
                    hintText: 'John Doe',
                    prefixIcon: Icon(Icons.person_outline, color: Color(0xFFB5A4FF)),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Email Address'),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    hintText: 'name@company.com',
                    prefixIcon: Icon(Icons.mail_outline, color: Color(0xFFB5A4FF)),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Phone Number'),
                Row(
                  children: [
                    Container(
                      width: 84,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF8B6FFF).withOpacity(0.25),
                          width: 1.2,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🇮🇳', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 4),
                          Text('+91', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        decoration: const InputDecoration(hintText: '(555) 000-0000'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Password'),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB5A4FF)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () => ref.read(signUpViewModelProvider.notifier).togglePasswordVisibility(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Confirm Password'),
                TextFormField(
                  controller: _confirmPasswordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: state.obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  onFieldSubmitted: (_) => _nextStep(),
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB5A4FF)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () => ref.read(signUpViewModelProvider.notifier).toggleConfirmPasswordVisibility(),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _buildGradientButton(
                  text: 'Continue',
                  onPressed: _nextStep,
                  showArrow: true,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Color(0xFFB5A4FF),
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildPersonalDetailsStep(SignUpState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0B30).withOpacity(0.80),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF8B6FFF).withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Tell us a bit more about yourself.",
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
                const SizedBox(height: 28),
                Center(
                  child: GestureDetector(
                    onTap: _showPhotoOptions,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                gradient: state.photoUploaded
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF5B61F6),
                                          Color(0xFF8B6FFF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: state.photoUploaded ? null : Colors.white.withOpacity(0.04),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF8B6FFF).withOpacity(state.photoUploaded ? 0.8 : 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: state.profilePhotoBytes != null
                                    ? ClipOval(
                                        child: Image.memory(
                                          state.profilePhotoBytes!,
                                          width: 84,
                                          height: 84,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : state.photoUploaded
                                    ? Text(
                                        _fullNameController.text.trim().isEmpty
                                            ? 'U'
                                            : _fullNameController.text
                                                  .trim()[0]
                                                  .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person_add_alt_1_outlined,
                                        size: 32,
                                        color: Colors.white54,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF5B61F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.photoLabel,
                          style: const TextStyle(
                            color: Color(0xFFB5A4FF),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.profilePhotoBytes != null
                              ? '${state.photoLabel} • Tap to change'
                              : state.photoUploaded
                              ? 'Photo ready • Tap to change'
                              : 'Optional • JPG or PNG • Max 5 MB',
                          style: TextStyle(color: Colors.white.withOpacity(0.38), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextFieldLabel('Username'),
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  decoration: const InputDecoration(
                    hintText: '@alex_designer',
                    suffixIcon: Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Only letters, numbers and underscores',
                  style: TextStyle(color: Colors.white.withOpacity(0.38), fontSize: 11),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFieldLabel('Date of Birth'),
                          TextFormField(
                            controller: _dobController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Select date',
                              suffixIcon: Icon(Icons.calendar_today, size: 20, color: Color(0xFFB5A4FF)),
                            ),
                            readOnly: true,
                            onTap: _pickDateOfBirth,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFieldLabel('Age'),
                          TextFormField(
                            controller: _ageController,
                            style: const TextStyle(color: Colors.white54),
                            decoration: const InputDecoration(hintText: '0'),
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Gender'),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          child: _buildGenderOption(
                            Icons.male,
                            'Male',
                            state.selectedGender == 'Male',
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _buildGenderOption(
                            Icons.female,
                            'Female',
                            state.selectedGender == 'Female',
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _buildGenderOption(
                            Icons.transgender,
                            'Non-Binary',
                            state.selectedGender == 'Non-Binary',
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _buildGenderOption(
                            Icons.visibility_off_outlined,
                            'Prefer Not\nTo Say',
                            state.selectedGender == 'Prefer Not To Say',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Country'),
                TextFormField(
                  controller: _countryController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Select your country',
                    suffixIcon: Icon(Icons.keyboard_arrow_down, color: Color(0xFFB5A4FF)),
                  ),
                  readOnly: true,
                  onTap: _selectCountry,
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('City'),
                TextFormField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.addressCity],
                  onFieldSubmitted: (_) => _nextStep(),
                  decoration: const InputDecoration(hintText: 'Enter your city'),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildBackButton(onPressed: _prevStep),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildGradientButton(text: 'Continue', onPressed: _nextStep),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelectionStep(SignUpState state) {
    // Deduplicate by label — one card per label prevents 2× Startup / 2× Career / 2× Community
    final rolesByLabel = <String, UserRole>{};
    for (final role in UserRole.values) {
      rolesByLabel.putIfAbsent(role.label, () => role);
    }
    final roles = rolesByLabel.values.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0B30).withOpacity(0.80),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF8B6FFF).withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Choose Your Primary Role',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 4),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Select the role that best represents you.",
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: roles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    final isSelected = state.selectedRole == role;

                    return GestureDetector(
                      onTap: () {
                        ref.read(signUpViewModelProvider.notifier).selectRole(role);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF5B61F6).withOpacity(0.25)
                              : Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFB5A4FF)
                                : const Color(0xFF8B6FFF).withOpacity(0.20),
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              role.icon,
                              color: isSelected ? const Color(0xFFB5A4FF) : Colors.white70,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              role.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isSelected ? Colors.white : Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              role.description,
                              style: TextStyle(
                                color: isSelected ? Colors.white70 : Colors.white38,
                                fontSize: 9,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                _buildGradientButton(
                  text: state.roleButtonText,
                  onPressed: _nextStep,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildGenderOption(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        ref.read(signUpViewModelProvider.notifier).selectGender(label.replaceAll('\n', ' '));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B61F6).withOpacity(0.25)
              : Colors.white.withOpacity(0.04),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB5A4FF)
                : const Color(0xFF8B6FFF).withOpacity(0.20),
            width: isSelected ? 1.8 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFB5A4FF) : Colors.white60,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({required String text, required VoidCallback onPressed, bool showArrow = false}) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF5B61F6), Color(0xFF4F46E5)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B61F6).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton({required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: const Color(0xFF8B6FFF).withOpacity(0.35), width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70)),
    );
  }

  void _showMessage(String message) {
    AppSnackBar.showError(context, message);
  }

  Future<void> _pickDateOfBirth() async {
    final state = ref.read(signUpViewModelProvider);
    final notifier = ref.read(signUpViewModelProvider.notifier);
    final now = DateTime.now();
    final initialDate =
        state.dateOfBirth ?? DateTime(now.year - 25, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 80),
      lastDate: DateTime(now.year - 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF5B61F6),
              onPrimary: Colors.white,
              surface: Color(0xFF130E3D),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    notifier.setDateOfBirth(picked);
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    _dobController.text =
        '${picked.day.toString().padLeft(2, '0')} ${months[picked.month - 1]} ${picked.year}';
    _ageController.text = notifier.calculateAge(picked).toString();
  }

  Future<void> _selectCountry() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final countries = [
          'United States',
          'India',
          'United Kingdom',
          'Canada',
          'Australia',
        ];

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          decoration: const BoxDecoration(
            color: Color(0xFF130E3D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Country',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 12),
              ...countries.map(
                (country) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(country, style: const TextStyle(color: Colors.white70)),
                  trailing: _countryController.text == country
                      ? const Icon(Icons.check, color: Color(0xFFB5A4FF))
                      : null,
                  onTap: () => Navigator.pop(sheetContext, country),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _countryController.text = selected;
    });
  }

  Future<void> _showPhotoOptions() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          decoration: const BoxDecoration(
            color: Color(0xFF130E3D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Profile Photo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pick a photo from your gallery or camera.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 16),
              _photoChoiceTile(
                label: 'Choose from gallery',
                subtitle: 'Select an existing photo from your device',
                icon: Icons.photo_library_outlined,
                onTap: () => Navigator.pop(sheetContext, 'gallery'),
              ),
              const SizedBox(height: 12),
              _photoChoiceTile(
                label: 'Take a photo',
                subtitle: 'Open the camera and capture a new image',
                icon: Icons.photo_camera_outlined,
                onTap: () => Navigator.pop(sheetContext, 'camera'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(sheetContext),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    if (selected == 'gallery') {
      await _pickPhoto(ImageSource.gallery);
      return;
    }

    if (selected == 'camera') {
      await _pickPhoto(ImageSource.camera);
    }
  }

  Widget _photoChoiceTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.04),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B61F6).withOpacity(0.20),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF8B6FFF).withOpacity(0.3), width: 1),
                ),
                child: Icon(icon, color: const Color(0xFFB5A4FF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (!kIsWeb) {
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
        if (!mounted) return;
        _showPermissionDeniedDialog(source == ImageSource.camera ? 'Camera' : 'Photo Library');
        return;
      }
      if (status.isDenied) {
        if (!mounted) return;
        _showMessage('Permission is required to access the ${source == ImageSource.camera ? 'camera' : 'photo library'}.');
        return;
      }
    }

    try {
      await ref.read(signUpViewModelProvider.notifier).pickPhoto(source, onCameraUnsupported: () {
        _showMessage(
          'Camera capture is not supported on web. Please choose from gallery.',
        );
      });
    } catch (error) {
      if (!mounted) return;
      _showMessage('Failed to process the selected photo. Please try again.');
    }
  }

  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Permission Required'),
        content: Text(
          '$permissionName permission is permanently denied. Please enable it in app settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B61F6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
