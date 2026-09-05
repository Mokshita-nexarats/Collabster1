import 'package:flutter/material.dart';

/// Plain, shared search bar used on every community-mode screen.
///
/// Just one [TextField] — no [Container] wrappers at all, so there is no
/// nested-box look. Height comes only from [contentPadding] plus fixed
/// icon constraints, so it can never throw a bottom-overflow error at
/// any font scale.
class CommunitySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool showClear;
  final VoidCallback onClear;
  final EdgeInsetsGeometry margin;

  const CommunitySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search',
    this.showClear = false,
    required this.onClear,
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 8),
  });

  static const _bg = Color(0xFFF1F3F5);
  static const _sub = Color(0xFF707579);
  static const _muted = Color(0xFFA8ADB3);
  static const _text = Color(0xFF111111);

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  );

  static const _iconConstraints = BoxConstraints(
    minWidth: 40,
    minHeight: 42,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 15, color: _text),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: _sub, fontSize: 15),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _sub,
            size: 20,
          ),
          prefixIconConstraints: _iconConstraints,
          suffixIcon: showClear
              ? GestureDetector(
                  onTap: onClear,
                  behavior: HitTestBehavior.opaque,
                  child: const Icon(
                    Icons.cancel_rounded,
                    color: _muted,
                    size: 18,
                  ),
                )
              : null,
          suffixIconConstraints: _iconConstraints,
          filled: true,
          fillColor: _bg,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          errorBorder: _border,
          disabledBorder: _border,
          isDense: true,
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }
}
