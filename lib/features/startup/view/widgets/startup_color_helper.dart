import 'package:flutter/material.dart';

class StartupColorHelper {
  static Color fromKey(String key) {
    switch (key) {
      case 'primary':
        return const Color(0xFF0088CC);
      case 'live':
        return const Color(0xFF059669);
      case 'beta':
        return const Color(0xFFF59E0B);
      case 'draft':
        return const Color(0xFF6B7280);
      case 'founder':
        return const Color(0xFF0088CC);
      case 'cofounder':
        return const Color(0xFF0D9488);
      case 'coreTeam':
        return const Color(0xFF2563EB);
      case 'indigo':
        return const Color(0xFF229ED9);
      case 'teal':
        return const Color(0xFF0D9488);
      case 'amber':
        return const Color(0xFFF59E0B);
      case 'blue':
        return const Color(0xFF2563EB);
      case 'purple':
        return const Color(0xFF229ED9);
      case 'muted':
        return const Color(0xFF9CA3AF);
      case 'red':
        return const Color(0xFFDC2626);
      case 'cyan':
        return const Color(0xFF0088CC);
      case 'green':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  static IconData iconFromKey(String key) {
    switch (key) {
      case 'rocket':
        return Icons.rocket_launch_outlined;
      case 'group':
        return Icons.group_add_outlined;
      case 'task':
        return Icons.task_alt;
      case 'urgent':
        return Icons.warning_amber_rounded;
      case 'document':
        return Icons.description_outlined;
      case 'milestone':
        return Icons.flag_outlined;
      case 'video':
        return Icons.video_call_rounded;
      case 'document_pdf':
        return Icons.picture_as_pdf_rounded;
      default:
        return Icons.help_outline;
    }
  }

  static String colorKeyForStatus(String status) {
    switch (status) {
      case 'LIVE':
        return 'live';
      case 'BETA':
        return 'beta';
      case 'COMING SOON':
      case 'IN DEV':
        return 'draft';
      default:
        return 'primary';
    }
  }
}
