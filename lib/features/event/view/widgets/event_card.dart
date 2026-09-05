import 'package:flutter/material.dart';
import '../../model/event_model.dart';

const _accent = Color(0xFF0088CC);
const _accentBg = Color(0xFFEFF6FF);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

/// Tappable event card used across the Event hub.
class EventCard extends StatelessWidget {
  final Event event;
  final bool isRegistered;
  final VoidCallback? onTap;
  final VoidCallback? onRegister;
  final bool compact;

  const EventCard({
    super.key,
    required this.event,
    this.isRegistered = false,
    this.onTap,
    this.onRegister,
    this.compact = false,
  });

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    border: Border.all(color: _accent.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    event.category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _accent,
                    ),
                  ),
                ),
                if (event.isOnline) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.2)),
                    ),
                    child: const Text(
                      'Online',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                    ),
                  ),
                ],
                const Spacer(),
                if (event.attendeeCount > 0)
                  Row(
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 14, color: _textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        '${event.attendeeCount}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _textSecondary),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
                height: 1.3,
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 5),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5, color: _textSecondary, height: 1.4),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  event.isOnline ? Icons.videocam_outlined : Icons.location_on_outlined,
                  size: 14,
                  color: _textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: _textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_today_outlined, size: 13, color: _textSecondary),
                const SizedBox(width: 4),
                Text(
                  _formatDate(event.startDate),
                  style: const TextStyle(fontSize: 12, color: _textSecondary),
                ),
              ],
            ),
            if (onRegister != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRegistered ? _textSecondary : _accent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    isRegistered ? 'Registered' : 'Register',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}