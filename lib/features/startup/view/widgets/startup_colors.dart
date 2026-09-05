import 'package:flutter/material.dart';

class StartupColors {
  StartupColors._();

  static const Color founder = Color(0xFF0088CC);
  static const Color cofounder = Color(0xFF0D9488);
  static const Color coreTeam = Color(0xFF2563EB);
  static const Color live = Color(0xFF059669);
  static const Color draft = Color(0xFF6B7280);
  static const Color urgent = Color(0xFFDC2626);
  static const Color defaultBadge = Color(0xFF6B7280);

  static Color colorForStatus(String status) {
    switch (status.toUpperCase()) {
      case 'LIVE':
        return live;
      case 'DRAFT':
        return draft;
      case 'URGENT':
        return urgent;
      default:
        return defaultBadge;
    }
  }
}
