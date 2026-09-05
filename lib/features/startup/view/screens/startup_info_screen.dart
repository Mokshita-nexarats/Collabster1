import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/providers.dart';

class StartupInfoScreen extends ConsumerStatefulWidget {
  const StartupInfoScreen({super.key});

  @override
  ConsumerState<StartupInfoScreen> createState() => _StartupInfoScreenState();
}

class _StartupInfoScreenState extends ConsumerState<StartupInfoScreen> {

  void _showPhotoOptions() {
    showModalBottomSheet(
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
              'Update Founder Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
            ),
            const SizedBox(height: 16),
            _photoOption(Icons.photo_library_outlined, 'Choose from Gallery', () => _pickPhoto(ImageSource.gallery)),
            _photoOption(Icons.camera_alt_outlined, 'Take a Photo', () => _pickPhoto(ImageSource.camera)),
          ],
        ),
      ),
    );
  }

  Widget _photoOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    Navigator.pop(context);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permission permanently denied. Please enable it in Settings.'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return;
      }
      if (status.isDenied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission is required to access the photo library.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 1200);
      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();
      final dir = await getApplicationDocumentsDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = 'founder_photo_$ts.jpg';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      await ref.read(authViewModelProvider.notifier).updateFounderPhoto(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Founder photo updated'), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process the selected photo. Please try again.'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final startupName = session?.startupName ?? 'My Startup';
    final tagline = session?.startupTagline ?? '';
    final industry = session?.startupIndustry ?? '';
    final stage = session?.startupStage ?? '';
    final city = session?.startupCity ?? '';
    final country = session?.startupCountry ?? '';
    final description = session?.startupDescription ?? '';
    final problem = session?.startupProblem ?? '';
    final solution = session?.startupSolution ?? '';
    final mission = session?.startupMission ?? '';
    final vision = session?.startupVision ?? '';
    final website = session?.startupWebsite ?? '';
    final incorporationDate = session?.startupIncorporationDate ?? '';
    final founderName = session?.startupFounderName ?? '';
    final founderDesignation = session?.startupFounderDesignation ?? '';
    final founderEmail = session?.startupFounderEmail ?? '';
    final founderPhone = session?.startupFounderPhone ?? '';
    final founderLinkedin = session?.startupFounderLinkedin ?? '';
    final founderBio = session?.startupFounderBio ?? '';
    final socialWebsite = session?.startupSocialWebsite ?? '';
    final socialLinkedin = session?.startupSocialLinkedin ?? '';
    final socialProductHunt = session?.startupSocialProductHunt ?? '';
    final useOfFunds = session?.startupUseOfFunds ?? '';
    final teamSize = session?.startupTeamSize ?? '';
    final fundingStage = session?.startupFundingStage ?? '';
    final currentlyRaising = session?.startupCurrentlyRaising ?? false;
    final visibility = session?.startupVisibility ?? '';

    final logoPath = session?.startupLogoPath ?? '';
    final hasLogo = logoPath.isNotEmpty && File(logoPath).existsSync();
    final founderPhotoPath = session?.startupFounderPhotoPath ?? '';
    final hasFounderPhoto = founderPhotoPath.isNotEmpty && File(founderPhotoPath).existsSync();

    final initials = startupName.isNotEmpty
        ? startupName.substring(0, 1).toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF0088CC)],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // App bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Startup Info',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Startup icon / logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      child: hasLogo
                          ? ClipOval(
                              child: Image.file(
                                File(logoPath),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    // Name
                    Text(
                      startupName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    if (tagline.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          tagline,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                    // Badges row
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        if (industry.isNotEmpty) _badge(industry),
                        if (stage.isNotEmpty) _badge(stage),
                        if (city.isNotEmpty || country.isNotEmpty)
                          _badge([city, country].where((e) => e.isNotEmpty).join(', ')),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // ── About Section ──
          if (description.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'ABOUT',
                isDark: isDark,
                children: [
                  _buildTextBlock(description, isDark),
                ],
              ),
            ),

          // ── Problem & Solution ──
          if (problem.isNotEmpty || solution.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'PROBLEM & SOLUTION',
                isDark: isDark,
                children: [
                  if (problem.isNotEmpty) ...[
                    _buildLabelRow('Problem', problem, isDark),
                    if (solution.isNotEmpty) _divider(isDark),
                  ],
                  if (solution.isNotEmpty)
                    _buildLabelRow('Solution', solution, isDark),
                ],
              ),
            ),

          // ── Mission & Vision ──
          if (mission.isNotEmpty || vision.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'MISSION & VISION',
                isDark: isDark,
                children: [
                  if (mission.isNotEmpty) ...[
                    _buildLabelRow('Mission', mission, isDark),
                    if (vision.isNotEmpty) _divider(isDark),
                  ],
                  if (vision.isNotEmpty)
                    _buildLabelRow('Vision', vision, isDark),
                ],
              ),
            ),

          // ── Company Details ──
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'COMPANY DETAILS',
              isDark: isDark,
              children: [
                if (incorporationDate.isNotEmpty) ...[
                  _buildInfoRow(Icons.calendar_today_rounded, 'Incorporated', incorporationDate, isDark),
                  _divider(isDark),
                ],
                if (website.isNotEmpty) ...[
                  _buildInfoRow(Icons.language_rounded, 'Website', website, isDark),
                  _divider(isDark),
                ],
                _buildInfoRow(Icons.visibility_rounded, 'Visibility', visibility.isNotEmpty ? visibility : 'Public', isDark),
              ],
            ),
          ),

          // ── Founder ──
          if (founderName.isNotEmpty || founderEmail.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        'FOUNDER',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Founder photo with camera badge — always visible
                          const SizedBox(height: 20),
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF0088CC).withValues(alpha: 0.35),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0088CC).withValues(alpha: 0.15),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: isDark ? AppColors.darkSurface : const Color(0xFFF3F0FF),
                                  ),
                                  child: hasFounderPhoto
                                      ? ClipOval(
                                          child: Image.file(
                                            File(founderPhotoPath),
                                            width: 88,
                                            height: 88,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person_rounded,
                                          size: 44,
                                          color: Color(0xFF0088CC),
                                        ),
                                ),
                                // Camera badge
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _showPhotoOptions,
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0088CC),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.18),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),

                          if (founderName.isNotEmpty) ...[
                            _buildInfoRow(Icons.person_outline_rounded, 'Name', founderName, isDark),
                            _divider(isDark),
                          ],
                          if (founderDesignation.isNotEmpty) ...[
                            _buildInfoRow(Icons.badge_outlined, 'Designation', founderDesignation, isDark),
                            _divider(isDark),
                          ],
                          if (founderEmail.isNotEmpty) ...[
                            _buildInfoRow(Icons.email_outlined, 'Email', founderEmail, isDark),
                            _divider(isDark),
                          ],
                          if (founderPhone.isNotEmpty) ...[
                            _buildInfoRow(Icons.phone_outlined, 'Phone', founderPhone, isDark),
                            _divider(isDark),
                          ],
                          if (founderLinkedin.isNotEmpty) ...[
                            _buildInfoRow(Icons.link_rounded, 'LinkedIn', founderLinkedin, isDark),
                            _divider(isDark),
                          ],
                          if (founderBio.isNotEmpty)
                            _buildLabelRow('Bio', founderBio, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


          // ── Social Links ──
          if (socialWebsite.isNotEmpty || socialLinkedin.isNotEmpty || socialProductHunt.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'SOCIAL LINKS',
                isDark: isDark,
                children: [
                  if (socialWebsite.isNotEmpty) ...[
                    _buildInfoRow(Icons.language_rounded, 'Website', socialWebsite, isDark),
                    _divider(isDark),
                  ],
                  if (socialLinkedin.isNotEmpty) ...[
                    _buildInfoRow(Icons.work_outline_rounded, 'LinkedIn', socialLinkedin, isDark),
                    _divider(isDark),
                  ],
                  if (socialProductHunt.isNotEmpty)
                    _buildInfoRow(Icons.rocket_launch_rounded, 'Product Hunt', socialProductHunt, isDark),
                ],
              ),
            ),

          // ── Funding ──
          if (fundingStage.isNotEmpty || useOfFunds.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'FUNDING',
                isDark: isDark,
                children: [
                  _buildInfoRow(Icons.account_balance_wallet_rounded, 'Funding Stage', fundingStage, isDark),
                  if (teamSize.isNotEmpty) ...[
                    _divider(isDark),
                    _buildInfoRow(Icons.group_rounded, 'Team Size', teamSize, isDark),
                  ],
                  _divider(isDark),
                  _buildInfoRow(
                    currentlyRaising ? Icons.trending_up_rounded : Icons.pause_circle_outline_rounded,
                    'Currently Raising',
                    currentlyRaising ? 'Yes' : 'No',
                    isDark,
                  ),
                  if (useOfFunds.isNotEmpty) ...[
                    _divider(isDark),
                    _buildLabelRow('Use of Funds', useOfFunds, isDark),
                  ],
                ],
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border, width: 0.5),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(height: 1, indent: 52, color: isDark ? AppColors.darkBorder : AppColors.border);
  }

  Widget _buildTextBlock(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
