import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../model/startup_models.dart';

class StartupPostUpdateScreen extends StatefulWidget {
  const StartupPostUpdateScreen({super.key, required this.startupName});
  final String startupName;

  @override
  State<StartupPostUpdateScreen> createState() =>
      _StartupPostUpdateScreenState();
}

class _StartupPostUpdateScreenState extends State<StartupPostUpdateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  String _selectedType = 'Company News';
  File? _selectedImage;
  bool _isPublishing = false;

  static const Map<String, _PostTypeOption> _postTypes = {
    'Company News': _PostTypeOption(
      icon: Icons.campaign_rounded,
      color: Color(0xFF0088CC),
      description: 'Share company announcements and updates',
    ),
    'Product Launch': _PostTypeOption(
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF2563EB),
      description: 'Announce a new product or feature release',
    ),
    'Milestone': _PostTypeOption(
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFD97706),
      description: 'Celebrate a key achievement or milestone',
    ),
    'Team Update': _PostTypeOption(
      icon: Icons.group_add_rounded,
      color: Color(0xFF059669),
      description: 'Share team growth or new hires',
    ),
    'Fundraising': _PostTypeOption(
      icon: Icons.trending_up_rounded,
      color: Color(0xFF0088CC),
      description: 'Share funding rounds or investment news',
    ),
    'Hiring': _PostTypeOption(
      icon: Icons.work_rounded,
      color: Color(0xFFE11D48),
      description: 'Announce open positions at your startup',
    ),
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
            const Text(
              'Add Media',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            const SizedBox(height: 16),
            _mediaOption(
              ctx,
              Icons.photo_library_outlined,
              'Choose from Gallery',
              'Select an existing photo',
              ImageSource.gallery,
            ),
            const SizedBox(height: 10),
            _mediaOption(
              ctx,
              Icons.photo_camera_outlined,
              'Take a Photo',
              'Capture a new image',
              ImageSource.camera,
            ),
            const SizedBox(height: 12),
            if (_selectedImage != null)
              _mediaOption(
                ctx,
                Icons.delete_outline_rounded,
                'Remove Photo',
                'Remove the selected image',
                ImageSource.gallery,
              ),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (_selectedImage != null && source == ImageSource.gallery) {
      setState(() => _selectedImage = null);
      return;
    }

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
      if (status.isPermanentlyDenied || status.isDenied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission required to access photos. Please enable it in Settings.'), behavior: SnackBarBehavior.floating),
        );
        return;
      }
    }

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (_) {}
  }

  Widget _mediaOption(
    BuildContext ctx,
    IconData icon,
    String title,
    String subtitle,
    ImageSource source,
  ) {
    final isDelete = title == 'Remove Photo';
    return GestureDetector(
      onTap: () => Navigator.pop(ctx, source),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDelete
              ? const Color(0xFFFEF2F2)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDelete
                ? const Color(0xFFFECACA)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDelete
                    ? const Color(0xFFDC2626).withValues(alpha: 0.1)
                    : const Color(0xFF0088CC).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                    isDelete ? const Color(0xFFDC2626) : const Color(0xFF0088CC),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDelete
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDelete
                  ? const Color(0xFFDC2626).withValues(alpha: 0.5)
                  : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _publish() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      _showSnack('Please enter a title for your update.');
      return;
    }
    if (description.isEmpty) {
      _showSnack('Please add a description for your update.');
      return;
    }

    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final post = StartupPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      title: title,
      description: description,
      createdAt: DateTime.now(),
      tags: [_selectedType],
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context, post);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final option = _postTypes[_selectedType] ?? _postTypes.values.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0088CC),
                    Color(0xFF229ED9),
                    Color(0xFF0088CC),
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
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
                      const SizedBox(width: 12),
                      const Text(
                        'Add Posts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share news with your network about ${widget.startupName}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: option.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: option.color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: option.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(option.icon, color: option.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedType,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: option.color,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              option.description,
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
                ),
                const SizedBox(height: 20),
                const Text(
                  'POST TYPE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _postTypes.keys.map((type) {
                    final isSelected = _selectedType == type;
                    final t = _postTypes[type]!;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? t.color.withValues(alpha: 0.12)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isSelected
                                ? t.color
                                : const Color(0xFFE5E7EB),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              t.icon,
                              size: 16,
                              color: isSelected
                                  ? t.color
                                  : const Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? t.color
                                    : const Color(0xFF374151),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'TITLE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _titleController,
                  maxLength: 120,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF12233D),
                  ),
                  decoration: InputDecoration(
                    hintText: 'What\'s the headline?',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterStyle: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF0088CC),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  maxLines: 6,
                  maxLength: 2000,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.5,
                    color: Color(0xFF12233D),
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Tell your audience more about this update...\n\nTip: Mention the impact, who it helps, and what\'s next.',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterStyle: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF0088CC),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ADD MEDIA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: _selectedImage != null ? 200 : 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedImage != null
                            ? const Color(0xFF0088CC)
                            : const Color(0xFFE5E7EB),
                        width: _selectedImage != null ? 2 : 1,
                      ),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: const Color(0xFFE8F4FB),
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Color(0xFF0088CC),
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedImage = null),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0088CC)
                                      .withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Color(0xFF0088CC),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Tap to add a photo',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'JPG, PNG up to 5 MB',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'LINK (OPTIONAL)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _linkController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF12233D),
                  ),
                  decoration: InputDecoration(
                    hintText: 'https://...',
                    hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                    prefixIcon: const Icon(
                      Icons.link_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF0088CC),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Updates with images get 3x more engagement. Consider adding a relevant visual to your post.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isPublishing ? null : _publish,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF0088CC),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF0088CC).withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _isPublishing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Publish Update',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostTypeOption {
  const _PostTypeOption({
    required this.icon,
    required this.color,
    required this.description,
  });
  final IconData icon;
  final Color color;
  final String description;
}
