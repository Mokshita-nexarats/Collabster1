import 'package:flutter/material.dart';

/// Golden yellow & white palette used across the Investor mode.
class InvestorColors {
  InvestorColors._();

  // ─── Gold core (sky-blue scale, matching Community mode) ───────────────
  static const Color gold = Color(0xFF229ED9);
  static const Color goldPrimary = Color(0xFF0088CC);
  static const Color goldDeep = Color(0xFF006699);
  static const Color goldDark = Color(0xFF006699);
  static const Color goldLight = Color(0xFFBAE6FD);
  static const Color goldSoft = Color(0xFFE8F4FB);
  static const Color goldMist = Color(0xFFF0F9FF);
  static const Color goldBg = Color(0xFFF8FAFC);

  // ─── Neutrals (cool whites) ──────────────────────────────────────────────
  static const Color ink = Color(0xFF0F172A);
  static const Color inkSoft = Color(0xFF334155);
  static const Color textMuted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color card = Colors.white;

  // ─── Accents for charts / tags ────────────────────────────────────────────
  static const Color green = Color(0xFF0E9F6E);
  static const Color greenSoft = Color(0xFFE7F8F0);
  static const Color red = Color(0xFFE04444);
  static const Color redSoft = Color(0xFFFDEBEB);
  static const Color blue = Color(0xFF2563EB);
  static const Color blueSoft = Color(0xFFE8F0FE);
  static const Color purple = Color(0xFF229ED9);
  static const Color purpleSoft = Color(0xFFE8F4FB);
  static const Color orange = Color(0xFF0088CC);
  static const Color orangeSoft = Color(0xFFE8F4FB);
  static const Color teal = Color(0xFF0088CC);
  static const Color tealSoft = Color(0xFFE8F4FB);

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0088CC), Color(0xFF229ED9)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)],
  );

  static const LinearGradient goldShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0088CC), Color(0xFF7DD3FC)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)],
  );

  static const List<Color> chartPalette = [
    Color(0xFF229ED9),
    Color(0xFF0E9F6E),
    Color(0xFF2563EB),
    Color(0xFF006699),
    Color(0xFF38BDF8),
    Color(0xFF0088CC),
  ];

  static const Map<String, Color> _colorKeys = {
    'gold': gold,
    'green': green,
    'blue': blue,
    'purple': purple,
    'orange': orange,
    'teal': teal,
    'red': red,
  };

  static const Map<String, Color> _softKeys = {
    'gold': goldSoft,
    'green': greenSoft,
    'blue': blueSoft,
    'purple': purpleSoft,
    'orange': orangeSoft,
    'teal': tealSoft,
    'red': redSoft,
  };

  static Color colorForKey(String key) => _colorKeys[key] ?? gold;

  static Color softForKey(String key) => _softKeys[key] ?? goldSoft;
}