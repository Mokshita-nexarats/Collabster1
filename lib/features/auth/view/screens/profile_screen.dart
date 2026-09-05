import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/enums/app_enums.dart';
import '../sign_in_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<Color> _getHeaderGradient(UserRole role) {
    if (role.isStartupRole) {
      return const [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)]; // Sky blue for Startup
    }
    switch (role) {
      case UserRole.investor:
        return const [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)]; // Sky blue for Investor
      case UserRole.student:
      case UserRole.professional:
      case UserRole.mentor:
        return const [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)]; // Sky blue for Career
      case UserRole.creator:
      case UserRole.influencer:
        return const [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)]; // Sky blue for Community
      case UserRole.serviceProvider:
        return const [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)]; // Sky blue for Event
      default:
        return const [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)];
    }
  }

  Color _getPrimaryAccentColor(UserRole role) {
    if (role.isStartupRole) {
      return const Color(0xFF0088CC);
    }
    switch (role) {
      case UserRole.investor:
        return const Color(0xFF0088CC);
      case UserRole.student:
      case UserRole.professional:
      case UserRole.mentor:
        return const Color(0xFF0088CC); // Sky blue for Career
      case UserRole.creator:
      case UserRole.influencer:
        return const Color(0xFF0088CC); // Sky blue for Community
      case UserRole.serviceProvider:
        return const Color(0xFF0088CC);
      default:
        return const Color(0xFF0088CC);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeUserRole = session?.activeUserRole ?? UserRole.professional;
    final name = session?.fullName ?? 'User';
    final email = session?.email ?? '';
    final username = session?.username ?? '';
    final phone = session?.phone ?? '';
    final role = activeUserRole.label;
    final photoPath = session?.profilePhotoPath;
    final initials = _getInitials(name);
    final headerGradient = _getHeaderGradient(activeUserRole);
    final primaryAccent = _getPrimaryAccentColor(activeUserRole);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Profile Header ──
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: headerGradient,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // App bar row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Profile',
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
                    // Avatar
                    _buildProfileAvatar(photoPath, initials, isDark, primaryAccent),
                    const SizedBox(height: 16),
                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                    if (role.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          role,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // ── Account Info ──
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'ACCOUNT INFORMATION',
              isDark: isDark,
              children: [
                _buildInfoRow(Icons.person_outline_rounded, 'Full Name', name, isDark, primaryAccent),
                _divider(isDark),
                _buildInfoRow(Icons.email_outlined, 'Email', email, isDark, primaryAccent),
                if (username.isNotEmpty) ...[
                  _divider(isDark),
                  _buildInfoRow(Icons.alternate_email, 'Username', '@$username', isDark, primaryAccent),
                ],
                _divider(isDark),
                _buildInfoRow(Icons.phone_outlined, 'Phone', phone, isDark, primaryAccent),
                _divider(isDark),
                _buildInfoRow(Icons.badge_outlined, 'Role', role, isDark, primaryAccent),
              ],
            ),
          ),

          // ── Preferences ──
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'PREFERENCES',
              isDark: isDark,
              children: [
                _buildMenuTile(
                  Icons.help_outline_rounded,
                  'Help & Support',
                  'FAQ, contact us',
                  isDark,
                  primaryAccent,
                  () => _showHelpSheet(context, isDark),
                ),
                _divider(isDark),
                _buildMenuTile(
                  Icons.info_outline_rounded,
                  'About',
                  'v1.0.0',
                  isDark,
                  primaryAccent,
                  () => _showAboutDialog(context, isDark),
                ),
              ],
            ),
          ),

          // ── Legal ──
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'LEGAL',
              isDark: isDark,
              children: [
                _buildMenuTile(
                  Icons.description_outlined,
                  'Terms & Conditions',
                  '',
                  isDark,
                  primaryAccent,
                  () => _showTermsSheet(context, isDark),
                ),
                _divider(isDark),
                _buildMenuTile(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  '',
                  isDark,
                  primaryAccent,
                  () => _showPrivacySheet(context, isDark),
                ),
              ],
            ),
          ),

          // ── Sign Out ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: GestureDetector(
                onTap: () async {
                  final nav = Navigator.of(context);
                  await ref.read(authViewModelProvider.notifier).logout();
                  if (!mounted) return;
                  nav.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (_) => false,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.red.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: AppColors.red, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String? photoPath, String initials, bool isDark, Color primaryAccent) {
    final hasPhoto = photoPath != null && File(photoPath).existsSync();
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white.withOpacity(0.15),
            backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
            child: hasPhoto
                ? null
                : Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: GestureDetector(
            onTap: _showPhotoOptions,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: primaryAccent,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

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
              'Change Profile Photo',
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
            content: Text('Permission permanently denied. Please enable it in Settings.'),
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
      final fileName = 'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      await ref.read(authViewModelProvider.notifier).updateProfilePhoto(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated'), behavior: SnackBarBehavior.floating),
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

  // ── Section Builder ──
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

  // ── Info Row ──
  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: accentColor),
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
                  value.isEmpty ? '—' : value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Menu Tile ──
  Widget _buildMenuTile(IconData icon, String label, String subtitle, bool isDark, Color accentColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: accentColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ],
        ),
      ),
    );
  }


  // ── Help Sheet ──
  void _showHelpSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 16),
              const Text('Help & Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _helpItem(Icons.question_answer_rounded, 'FAQ', 'Find answers to commonly asked questions', isDark),
                    _helpItem(Icons.email_rounded, 'Contact Support', 'support@collabster.io', isDark),
                    _helpItem(Icons.book_rounded, 'User Guide', 'Learn how to use Collabster', isDark),
                    _helpItem(Icons.bug_report_rounded, 'Report a Bug', 'Help us improve by reporting issues', isDark),
                    _helpItem(Icons.star_rounded, 'Rate Us', 'Rate Collabster on the app store', isDark),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _helpItem(IconData icon, String title, String subtitle, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
        ],
      ),
    );
  }

  // ── About Dialog ──
  void _showAboutDialog(BuildContext context, bool isDark) {
    showAboutDialog(
      context: context,
      applicationName: 'Collabster',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF229ED9)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 24),
      ),
      children: const [
        Text(
          'Collabster is a collaborative platform for startups, investors, and professionals to connect and grow together.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  // ── Terms Sheet ──
  void _showTermsSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 16),
              const Text('Terms & Conditions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    Text('Terms of Service', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('Welcome to Collabster. By using our platform, you agree to the following terms and conditions...', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('1. Acceptance of Terms', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('By accessing and using Collabster, you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the platform.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('2. User Accounts', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('You are responsible for maintaining the confidentiality of your account credentials. You agree to provide accurate and complete information during registration.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('3. Platform Usage', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('Collabster is designed for professional networking and collaboration. Users must use the platform in a manner consistent with applicable laws.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('4. Intellectual Property', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('All content, features, and functionality are owned by us and protected by international copyright, trademark, and other intellectual property laws.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('5. Limitation of Liability', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('In no event shall Collabster be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the platform.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Privacy Sheet ──
  void _showPrivacySheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 16),
              const Text('Privacy Policy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    Text('Privacy Policy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('Your privacy is important to us. This Privacy Policy explains how Collabster collects, uses, and protects your personal information.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('1. Information We Collect', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('We collect information you provide directly, including your name, email address, phone number, profile photo, and professional details.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('2. How We Use Your Information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('We use your information to provide and improve our services, personalize your experience, communicate with you, and ensure platform security.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('3. Data Protection', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('We implement appropriate technical and organizational measures to protect your personal data against unauthorized access or destruction.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('4. Data Sharing', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('We do not sell your personal information. We may share your data with trusted third-party service providers who assist us in operating our platform.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 16),
                    Text('5. Your Rights', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('You have the right to access, correct, or delete your personal data. Contact us to exercise these rights.', style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF4B5563))),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
