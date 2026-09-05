import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/di/providers.dart';
import '../../../viewmodel/event_create_state.dart';
import '../../../model/event_category_model.dart';
import 'event_detail_screen.dart';

// ─── Color Tokens (Event hub — light green / white) ───────────────
const _accent = Color(0xFF0088CC);
const _accentBg = Color(0xFFEFF6FF);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);
const _bg = Color(0xFFF8FAFC);
const _danger = Color(0xFFDC2626);

IconData _categoryIcon(String iconKey) {
  return switch (iconKey) {
    'code' => Icons.code_rounded,
    'workshop' => Icons.workspaces_outlined,
    'groups' => Icons.groups_rounded,
    'mic' => Icons.mic_rounded,
    'webinar' => Icons.videocam_outlined,
    'handshake' => Icons.handshake_outlined,
    _ => Icons.event_rounded,
  };
}

class EventCreateScreen extends ConsumerStatefulWidget {
  const EventCreateScreen({super.key});

  @override
  ConsumerState<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends ConsumerState<EventCreateScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _titleError;
  String? _descriptionError;
  String? _locationError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      ref.read(eventCreateViewModelProvider.notifier).setTitle(_titleController.text);
    });
    _descriptionController.addListener(() {
      ref
          .read(eventCreateViewModelProvider.notifier)
          .setDescription(_descriptionController.text);
    });
    _locationController.addListener(() {
      ref
          .read(eventCreateViewModelProvider.notifier)
          .setLocation(_locationController.text);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ── Cover image ─────────────────────────────────────────────────────────
  Future<void> _showImageOptions() async {
    final picker = ImagePicker();

    final option = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Event cover image',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'A great cover makes your event stand out',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                _ImageOptionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from gallery',
                  subtitle: 'Pick an existing photo',
                  onTap: () => Navigator.pop(sheetContext, 'gallery'),
                ),
                _ImageOptionTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Take a photo',
                  subtitle: 'Capture the moment live',
                  onTap: () => Navigator.pop(sheetContext, 'camera'),
                ),
                if (ref.read(eventCreateViewModelProvider).imageUrl != null)
                  _ImageOptionTile(
                    icon: Icons.delete_outline_rounded,
                    title: 'Remove image',
                    subtitle: 'Use a plain gradient cover',
                    isDestructive: true,
                    onTap: () => Navigator.pop(sheetContext, 'remove'),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (option == null) return;

    if (option == 'remove') {
      ref.read(eventCreateViewModelProvider.notifier).setImageUrl(null);
      return;
    }

    try {
      final picked = await picker.pickImage(
        source: option == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        ref.read(eventCreateViewModelProvider.notifier).setImageUrl(picked.path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access the photo library'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ── Date & time ─────────────────────────────────────────────────────────
  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Select start date',
    );
    if (picked == null || !mounted) return;

    final notifier = ref.read(eventCreateViewModelProvider.notifier);
    final state = ref.read(eventCreateViewModelProvider);
    final combined = _combine(picked, _startTime);
    notifier.setStartDate(combined);
    if (state.endDate == null || state.endDate!.isBefore(combined)) {
      notifier.setEndDate(_combine(picked, _endTime ?? _startTime ?? const TimeOfDay(hour: 18, minute: 0)));
    }
  }

  Future<void> _pickEndDate() async {
    final state = ref.read(eventCreateViewModelProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: state.endDate ?? state.startDate ?? DateTime.now(),
      firstDate: state.startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      helpText: 'Select end date',
    );
    if (picked == null || !mounted) return;
    ref.read(eventCreateViewModelProvider.notifier).setEndDate(_combine(picked, _endTime));
  }

  Future<void> _pickTime({required bool isStart}) async {
    final current = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? const TimeOfDay(hour: 10, minute: 0),
      helpText: isStart ? 'Select start time' : 'Select end time',
    );
    if (picked == null || !mounted) return;

    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });

    final state = ref.read(eventCreateViewModelProvider);
    if (isStart && state.startDate != null) {
      ref.read(eventCreateViewModelProvider.notifier).setStartDate(_combine(state.startDate!, picked));
    }
    if (!isStart && state.endDate != null) {
      ref.read(eventCreateViewModelProvider.notifier).setEndDate(_combine(state.endDate!, picked));
    }
  }

  DateTime _combine(DateTime date, TimeOfDay? time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 10,
      time?.minute ?? 0,
    );
  }

  // ── Submit ───────────────────────────────────────────────────────────────
  void _submit() {
    FocusScope.of(context).unfocus();
    final notifier = ref.read(eventCreateViewModelProvider.notifier);
    final state = ref.read(eventCreateViewModelProvider);

    setState(() {
      _titleError = state.title.trim().isEmpty ? 'Enter an event title' : null;
      _descriptionError = state.description.trim().isEmpty ? 'Write a short description' : null;
      _locationError = state.location.trim().isEmpty ? (state.isOnline ? 'Add the meeting link' : 'Add the venue location') : null;
      if (state.startDate == null || state.endDate == null) {
        _dateError = 'Pick start and end dates';
      } else if (state.endDate!.isBefore(state.startDate!)) {
        _dateError = 'End date must be after start date';
      } else {
        _dateError = null;
      }
    });

    if (_titleError != null ||
        _descriptionError != null ||
        _locationError != null ||
        _dateError != null) {
      return;
    }

    final event = notifier.createEvent();
    if (event == null) return;

    ref.read(eventViewModelProvider.notifier).addEvent(event);
    notifier.reset();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event published! 🎉'),
        backgroundColor: _accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(eventCreateViewModelProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroHeader(),
                    const SizedBox(height: 18),
                    _buildLivePreview(createState),
                    const SizedBox(height: 22),
                    _sectionLabel(Icons.photo_library_outlined, 'Cover Image'),
                    _buildCoverSection(createState),
                    const SizedBox(height: 22),
                    _sectionLabel(Icons.description_outlined, 'Event Details'),
                    _buildField(
                      controller: _titleController,
                      hint: 'e.g. Flutter Performance Masterclass',
                      icon: Icons.title_rounded,
                      error: _titleError,
                      maxLength: 80,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _descriptionController,
                      hint: 'What is this event about?',
                      icon: Icons.notes_rounded,
                      error: _descriptionError,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel(Icons.category_outlined, 'Category'),
                    _buildCategoryChips(createState),
                    const SizedBox(height: 22),
                    _sectionLabel(Icons.schedule_rounded, 'Date & Time'),
                    _buildScheduleRow(createState),
                    if (_dateError != null) ...[
                      const SizedBox(height: 8),
                      _errorText(_dateError!),
                    ],
                    const SizedBox(height: 22),
                    _sectionLabel(
                      createState.isOnline
                          ? Icons.videocam_rounded
                          : Icons.place_outlined,
                      createState.isOnline ? 'Meeting Link' : 'Location',
                    ),
                    _buildOnlineCard(createState),
                    if (!createState.isOnline) ...[
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _locationController,
                        hint: 'e.g. Bangalore Tech Park, 4th Floor',
                        icon: Icons.location_on_outlined,
                        error: _locationError,
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _locationController,
                        hint: 'Paste the Zoom / Meet link',
                        icon: Icons.link_rounded,
                        error: _locationError,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 19),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Create Event',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            'Publish & go live',
            style: TextStyle(
              color: _textSecondary.withValues(alpha: 0.8),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_accent, Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -28,
            right: -24,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -34,
            left: 90,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Row(
            children: [
              Icon(Icons.event_rounded, color: Colors.white, size: 30),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Host something amazing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'A few details and your event is ready for the community.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLivePreview(EventCreateState state) {
    final hasBasics = state.title.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  state.category,
                  style: const TextStyle(
                    color: _accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (state.isOnline)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Online',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const Spacer(),
              const Icon(Icons.visibility_outlined, size: 14, color: _textSecondary),
              const SizedBox(width: 4),
              const Text(
                'Preview',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasBasics ? state.title : 'Your event title appears here',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: hasBasics ? _textPrimary : _textSecondary.withValues(alpha: 0.7),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            state.description.isEmpty
                ? 'Write a short description to help people decide.'
                : state.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                state.isOnline ? Icons.videocam_outlined : Icons.location_on_outlined,
                size: 14,
                color: _textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  state.isOnline
                      ? (state.location.isEmpty ? 'Meeting link' : state.location)
                      : (state.location.isEmpty ? 'Venue location' : state.location),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_today_outlined, size: 13, color: _textSecondary),
              const SizedBox(width: 4),
              Text(
                state.startDate == null
                    ? 'Pick date'
                    : '${state.startDate!.day}/${state.startDate!.month}/${state.startDate!.year}',
                style: const TextStyle(color: _textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoverSection(EventCreateState state) {
    final hasImage = state.imageUrl != null;
    return GestureDetector(
      onTap: _showImageOptions,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                Image.file(
                  File(state.imageUrl!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _coverPlaceholder(),
                )
              else
                _coverPlaceholder(),
              if (hasImage)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      _CoverChip(
                        icon: Icons.edit_rounded,
                        label: 'Change',
                        onTap: _showImageOptions,
                      ),
                      const SizedBox(width: 8),
                      _CoverChip(
                        icon: Icons.close_rounded,
                        label: '',
                        onTap: () =>
                            ref.read(eventCreateViewModelProvider.notifier).setImageUrl(null),
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

  Widget _coverPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006699), Color(0xFF0F766E)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: const Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add cover image',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Recommended 1200 × 600 · JPG or PNG',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(EventCreateState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: eventCategories.map((cat) {
          final isSelected = state.category == cat.label;
          return GestureDetector(
            onTap: () => ref
                .read(eventCreateViewModelProvider.notifier)
                .setCategory(cat.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _accent : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? _accent : _borderColor,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _categoryIcon(cat.iconKey),
                    color: isSelected ? Colors.white : _textSecondary,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScheduleRow(EventCreateState state) {
    return Row(
      children: [
        Expanded(
          child: _buildDateTimeCard(
            label: 'Start',
            date: state.startDate,
            time: _startTime,
            icon: Icons.event_available_rounded,
            onDateTap: _pickStartDate,
            onTimeTap: () => _pickTime(isStart: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDateTimeCard(
            label: 'End',
            date: state.endDate,
            time: _endTime,
            icon: Icons.event_busy_rounded,
            onDateTap: _pickEndDate,
            onTimeTap: () => _pickTime(isStart: false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeCard({
    required String label,
    required DateTime? date,
    required TimeOfDay? time,
    required IconData icon,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    String two(int v) => v.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _dateError != null ? _danger : _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _accent, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: _textSecondary, fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onDateTap,
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 13, color: _textSecondary),
                const SizedBox(width: 5),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      date == null
                          ? 'Pick date'
                          : '${date.day} ${_month(date.month)} ${date.year}',
                      style: TextStyle(
                        color: date == null ? _textSecondary : _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 16, color: _textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onTimeTap,
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 13, color: _textSecondary),
                const SizedBox(width: 5),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      time == null ? 'Pick time' : '${two(time.hour)}:${two(time.minute)}',
                      style: TextStyle(
                        color: time == null ? _textSecondary : _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 16, color: _textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }

  Widget _buildOnlineCard(EventCreateState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              state.isOnline ? Icons.videocam_rounded : Icons.place_rounded,
              color: _accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isOnline ? 'Online event' : 'In-person event',
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.isOnline
                      ? 'Attendees join via a meeting link'
                      : 'Add the venue so people can find you',
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Switch(
            value: state.isOnline,
            onChanged: (v) {
              ref.read(eventCreateViewModelProvider.notifier).setIsOnline(v);
              if (v) {
                ref.read(eventCreateViewModelProvider.notifier).setLocation(_locationController.text);
              }
            },
            activeTrackColor: _accent,
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? error,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: error != null ? _danger : _borderColor,
              width: error != null ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            style: const TextStyle(fontSize: 13.5, color: _textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
              prefixIcon: Icon(icon, color: _textSecondary, size: 19),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              counterText: maxLength != null ? '' : null,
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          _errorText(error),
        ],
      ],
    );
  }

  Widget _sectionLabel(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 17, color: _accent),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorText(String message) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, size: 14, color: _danger),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: _danger, fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final state = ref.watch(eventCreateViewModelProvider);
    final ready = state.isValid && state.startDate != null && state.endDate != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ready ? _accentBg : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    ready ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                    color: ready ? _accent : _textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ready ? 'Ready to publish' : 'Complete the details',
                    style: TextStyle(
                      color: ready ? _accent : _textSecondary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.rocket_launch_rounded, size: 17, color: Colors.white),
                label: const Text(
                  'Publish Event',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image option tile ─────────────────────────────────────────────────────
class _ImageOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ImageOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFDC2626) : const Color(0xFF0088CC);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Cover chip ────────────────────────────────────────────────────────────
class _CoverChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CoverChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 10 : 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}