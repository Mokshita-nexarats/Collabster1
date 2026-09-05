import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/providers.dart';
import '../../../model/event_model.dart';
import '../../../view/widgets/attendee_chip.dart';

const _bg = Color(0xFFF8FAFC);
const _accent = Color(0xFF0088CC);
const _accentBg = Color(0xFFEFF6FF);
const _live = Color(0xFFFF3C5C);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

class EventDetailScreen extends ConsumerWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String _formatTime(DateTime dt) {
    var h = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = h >= 12 ? 'PM' : 'AM';
    h = h % 12 == 0 ? 12 : h % 12;
    return '$h:$minute $suffix';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventViewModelProvider);
    final isRegistered = eventState.isRegistered(event.id);
    final attendees =
        ref.read(eventRepositoryProvider).fetchAttendees(event.id);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryRow(),
                    const SizedBox(height: 12),
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'by ${event.organizerName}',
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(),
                    const SizedBox(height: 18),
                    Text(
                      'About this event',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13.5,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildAttendeesSection(attendees),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, ref, isRegistered),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF006699), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Icon(
              event.isOnline
                  ? Icons.videocam_rounded
                  : Icons.event_available_rounded,
              color: Colors.white70,
              size: 64,
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event link copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share_rounded, color: Colors.white, size: 19),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _accentBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _accent.withValues(alpha: 0.25)),
          ),
          child: Text(
            event.category,
            style: const TextStyle(
              color: _accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (event.isOnline) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.25)),
            ),
            child: const Text(
              'Online',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _live.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.circle, color: _live, size: 7),
              const SizedBox(width: 5),
              Text(
                '${event.attendeeCount} going',
                style: const TextStyle(
                  color: _live,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _infoRow(Icons.calendar_today_outlined, 'Date', _formatDate(event.startDate)),
          const SizedBox(height: 12),
          _infoRow(Icons.access_time_rounded, 'Time', '${_formatTime(event.startDate)} – ${_formatTime(event.endDate)}'),
          const SizedBox(height: 12),
          _infoRow(
            event.isOnline ? Icons.videocam_outlined : Icons.location_on_outlined,
            event.isOnline ? 'Platform' : 'Location',
            event.location,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _accentBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _accent, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          '$label  ',
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeesSection(List<EventAttendee> attendees) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendees',
            style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (attendees.isEmpty)
            const Text(
              'Be the first to attend!',
              style: TextStyle(color: _textSecondary, fontSize: 12.5),
            )
          else
            Row(
              children: [
                ...attendees.take(5).map((a) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: AttendeeChip(attendee: a),
                    )),
                const SizedBox(width: 8),
                Text(
                  '${event.attendeeCount}+ going',
                  style: const TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, WidgetRef ref, bool isRegistered) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final notifier = ref.read(eventViewModelProvider.notifier);
          if (isRegistered) {
            notifier.cancelRsvp(event.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration cancelled'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            notifier.rsvpEvent(event.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You are registered for this event!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isRegistered ? _textSecondary : _accent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          isRegistered ? 'Cancel Registration' : 'Register Now',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}