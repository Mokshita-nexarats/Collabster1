import 'package:flutter/material.dart';
import '../../model/event_attendee_model.dart';

/// Circular avatar chip for an event attendee.
class AttendeeChip extends StatelessWidget {
  final EventAttendee attendee;
  final double radius;

  const AttendeeChip({super.key, required this.attendee, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${attendee.name} • ${attendee.role}',
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF229ED9), Color(0xFF0088CC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            attendee.initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: radius * 0.62,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}