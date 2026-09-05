import 'package:flutter/material.dart';

/// One tab inside [ModeMenuBar].
class ModeMenuItem {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badge;

  const ModeMenuItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge = 0,
  });
}

/// Shared bottom menu bar — the same flat design as Community mode:
/// full-width bar, 1px top divider, icon + label tabs, gradient center FAB.
///
/// Each mode keeps its own [selectedColor], [fabGradient], tab [items] and
/// tap behavior — only the shape is unified, colors and logic stay per-mode.
///
/// [items] must hold exactly 4 entries: the first two render left of the
/// FAB, the last two render right of it.
class ModeMenuBar extends StatelessWidget {
  const ModeMenuBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    required this.selectedColor,
    required this.fabGradient,
    this.onFabTap,
    this.backgroundColor,
    this.darkBackgroundColor,
    this.borderColor,
    this.darkBorderColor,
    this.unselectedColor,
    this.darkUnselectedColor,
  }) : assert(items.length == 4, 'ModeMenuBar needs exactly 4 items');

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<ModeMenuItem> items;
  final Color selectedColor;
  final List<Color> fabGradient;
  final VoidCallback? onFabTap;
  final Color? backgroundColor;
  final Color? darkBackgroundColor;
  final Color? borderColor;
  final Color? darkBorderColor;
  final Color? unselectedColor;
  final Color? darkUnselectedColor;

  static const _defaultUnselected = Color(0xFF9CA3AF);
  static const _defaultDarkUnselected = Color(0xFF64748B);
  static const _defaultBorder = Color(0xFFE2E8F0);
  static const _defaultDarkBorder = Color(0xFF2D3352);
  static const _defaultDarkBg = Color(0xFF1A1D35);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark
        ? (darkBackgroundColor ?? _defaultDarkBg)
        : (backgroundColor ?? Colors.white);
    final navBorder = isDark
        ? (darkBorderColor ?? _defaultDarkBorder)
        : (borderColor ?? _defaultBorder);
    final inactive = isDark
        ? (darkUnselectedColor ?? _defaultDarkUnselected)
        : (unselectedColor ?? _defaultUnselected);

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        border: Border(top: BorderSide(color: navBorder, width: 1)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 62,
        child: Row(
          children: [
            _item(items[0], inactive),
            _item(items[1], inactive),
            _centerFab(),
            _item(items[2], inactive),
            _item(items[3], inactive),
          ],
        ),
      ),
    );
  }

  Widget _item(ModeMenuItem item, Color inactive) {
    final selected = selectedIndex == item.index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(item.index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  selected ? item.activeIcon : item.icon,
                  color: selected ? selectedColor : inactive,
                  size: 24,
                ),
                if (item.badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        item.badge > 9 ? '9+' : '${item.badge}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? selectedColor : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _centerFab() {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onFabTap ?? () => onTap(2),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: fabGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: fabGradient.first.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
