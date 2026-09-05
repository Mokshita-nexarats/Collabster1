import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/startup_models.dart';
import 'join_startup_status_screen.dart';

class JoinStartupVerificationScreen extends StatefulWidget {
  const JoinStartupVerificationScreen({super.key, required this.startup});

  final SuggestedStartup startup;

  @override
  State<JoinStartupVerificationScreen> createState() =>
      _JoinStartupVerificationScreenState();
}

class _JoinStartupVerificationScreenState
    extends State<JoinStartupVerificationScreen> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, File?> _uploads = {};
  final Map<String, List<File>> _multiUploads = {};

  Future<void> _pickDocument(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
    );
    if (result == null || result.files.isEmpty || result.files.first.path == null) return;
    if (!mounted) return;
    setState(() {
      _uploads[type] = File(result.files.first.path!);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$type uploaded'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _pickImage(String type) async {
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 20),
            const Text('Choose Source', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _sourceOption(Icons.photo_library_outlined, 'Gallery', ImageSource.gallery),
            _sourceOption(Icons.camera_alt_outlined, 'Camera', ImageSource.camera),
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
          const SnackBar(content: Text('Permission required to access photos. Please enable it in Settings.'), behavior: SnackBarBehavior.floating),
        );
        return;
      }
    }

    final picked = await _picker.pickImage(source: source, imageQuality: 85, maxWidth: 1200);
    if (picked == null || !mounted) return;
    setState(() {
      _uploads[type] = File(picked.path);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$type uploaded'), behavior: SnackBarBehavior.floating),
      );
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

  Future<void> _pickMultipleDocuments(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;
    if (!mounted) return;
    final files = result.files.where((f) => f.path != null).map((f) => File(f.path!)).toList();
    setState(() {
      _multiUploads[type] = [...(_multiUploads[type] ?? []), ...files];
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${files.length} file(s) uploaded'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Widget _sourceOption(IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0088CC).withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0088CC), size: 22),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0088CC)),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Identity & Employment Verification',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please verify your identity before joining this startup.',
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: Color(0xFF5D6472),
                ),
              ),
              const SizedBox(height: 18),
              _verificationCard(
                title: 'Government ID',
                subtitle: 'Passport, National ID, Driving License',
                buttonLabel: _uploads['Government ID'] != null ? 'Replace' : 'Upload',
                statusLabel: _uploads['Government ID'] != null ? 'Uploaded' : null,
                icon: Icons.badge_outlined,
                onPressed: () => _pickDocument('Government ID'),
              ),
              _verificationCard(
                title: 'Employment Proof',
                subtitle: 'Offer Letter, Appointment Letter, Employee ID',
                buttonLabel: _uploads['Employment Proof'] != null ? 'Replace' : 'Upload Document',
                statusLabel: _uploads['Employment Proof'] != null ? 'Uploaded' : null,
                icon: Icons.work_outline,
                onPressed: () => _pickDocument('Employment Proof'),
              ),
              _verificationCard(
                title: 'Professional Verification',
                subtitle: 'LinkedIn Profile, Portfolio, Resume',
                buttonLabel: _uploads['Professional Verification'] != null ? 'Replace' : 'Add Information',
                statusLabel: _uploads['Professional Verification'] != null ? 'Uploaded' : null,
                icon: Icons.link_outlined,
                onPressed: () => _pickDocument('Professional Verification'),
              ),
              _verificationCard(
                title: 'Education Verification',
                subtitle: 'Degree Certificate, Student ID',
                buttonLabel: _uploads['Education Verification'] != null ? 'Replace' : 'Upload',
                statusLabel: _uploads['Education Verification'] != null ? 'Uploaded' : null,
                icon: Icons.school_outlined,
                optional: true,
                onPressed: () => _pickDocument('Education Verification'),
              ),
              _verificationCard(
                title: 'Profile Selfie',
                subtitle: 'Capture Live Photo, Face Verification',
                buttonLabel: _uploads['Profile Selfie'] != null ? 'Retake' : 'Open Camera',
                statusLabel: _uploads['Profile Selfie'] != null ? 'Uploaded' : null,
                icon: Icons.camera_alt_outlined,
                onPressed: () => _pickImage('Profile Selfie'),
              ),
              _verificationCard(
                title: 'Additional Documents',
                subtitle: 'Supporting identity or work proof',
                buttonLabel: _multiUploads['Additional Documents'] != null
                    ? 'Add More (${_multiUploads['Additional Documents']!.length})'
                    : 'Add More',
                statusLabel: _multiUploads['Additional Documents'] != null
                    ? '${_multiUploads['Additional Documents']!.length} file(s)'
                    : null,
                icon: Icons.folder_open_outlined,
                optional: true,
                onPressed: () => _pickMultipleDocuments('Additional Documents'),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'By submitting, you agree to our Security Policies.',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFD9D5E9))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: const BorderSide(color: Color(0xFFB7B5C9)),
                    foregroundColor: const Color(0xFF3B3B4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            JoinStartupStatusScreen(startup: widget.startup),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    backgroundColor: const Color(0xFF0088CC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Submit Verification',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verificationCard({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData icon,
    required VoidCallback onPressed,
    String? statusLabel,
    bool optional = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF0088CC), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D),
                            ),
                          ),
                        ),
                        if (statusLabel != null)
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF5D6472),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      optional ? 'Optional' : 'Required',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: optional
                            ? const Color(0xFF8C8FA0)
                            : const Color(0xFF0088CC),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              foregroundColor: const Color(0xFF0088CC),
              side: const BorderSide(color: Color(0xFF0088CC)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
