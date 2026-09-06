import 'package:flutter/material.dart';

/// Fixed bottom nav: Home | Explore | Post(+) | Messages | Switch.
/// Home active in blue. Center (+) opens create.
class HomeBottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final VoidCallback onCreate;

  const HomeBottomNav({
    super.key,
    required this.selected,
    required this.onTap,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom,
      ),
      child: SizedBox(
        height: 62,
        child: Row(
          children: [
            _tab(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
            _tab(1, Icons.explore_outlined, Icons.explore_rounded,
                'Explore'),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: onCreate,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
            _tab(3, Icons.chat_bubble_outline_rounded,
                Icons.chat_bubble_rounded, 'Messages'),
            _tab(4, Icons.swap_horiz_rounded, Icons.swap_horiz_rounded,
                'Switch'),
          ],
        ),
      ),
    );
  }

  Widget _tab(int index, IconData icon, IconData activeIcon, String label) {
    final active = selected == index;
    const blue = Color(0xFF2563EB);
    const grey = Color(0xFF9CA3AF);
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : icon,
                size: 24, color: active ? blue : grey),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? blue : grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
