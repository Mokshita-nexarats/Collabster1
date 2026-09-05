import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ShareSheet – Modal bottom sheet for sharing a post
// ─────────────────────────────────────────────────────────────────────────────

class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key, this.postLink = 'https://collabster.app/post/1'});

  final String postLink;

  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFF5F3FF);
  static const _kTextDark = Color(0xFF1A1A2E);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kDivider = Color(0xFFE5E7EB);

  static void show(BuildContext context, {String postLink = 'https://collabster.app/post/1'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareSheet(postLink: postLink),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _kDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _kTextDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: _kDivider,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 16, color: _kTextMid),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(color: _kDivider, thickness: 1, height: 1),
          const SizedBox(height: 8),

          // ── Options ──────────────────────────────────────────────────────
          _ShareOption(
            icon: Icons.repeat_rounded,
            iconBg: _kPurpleLight,
            iconColor: _kPurple,
            title: 'Repost',
            subtitle: 'Instantly republish this to your main feed',
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                _snackBar('Post reposted to your feed!'),
              );
            },
          ),

          _ShareOption(
            icon: Icons.chat_bubble_outline_rounded,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF3B82F6),
            title: 'Send in a private message',
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                _snackBar('Opening private messages…'),
              );
            },
          ),

          _ShareOption(
            icon: Icons.link_rounded,
            iconBg: const Color(0xFFF0FDF4),
            iconColor: const Color(0xFF22C55E),
            title: 'Copy link to post',
            onTap: () {
              Clipboard.setData(ClipboardData(text: postLink));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                _snackBar('Link copied to clipboard!'),
              );
            },
          ),

          _ShareOption(
            icon: Icons.ios_share_rounded,
            iconBg: const Color(0xFFFFF7ED),
            iconColor: const Color(0xFFF97316),
            title: 'Share via external applications',
            onTap: () {
              Navigator.of(context).pop();
              // Small delay so the first sheet fully dismisses before the next one appears
              Future.delayed(const Duration(milliseconds: 220), () {
                if (context.mounted) {
                  ExternalShareSheet.show(context, postLink: postLink);
                }
              });
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  SnackBar _snackBar(String message) => SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _kPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _ShareOption – individual row in the share sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ShareOption extends StatefulWidget {
  const _ShareOption({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  State<_ShareOption> createState() => _ShareOptionState();
}

class _ShareOptionState extends State<_ShareOption> {
  bool _pressed = false;

  static const _kTextDark = Color(0xFF1A1A2E);
  static const _kTextMid = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _pressed ? const Color(0xFFF9FAFB) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Icon bubble
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, size: 22, color: widget.iconColor),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _kTextDark,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: _kTextMid,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ExternalShareSheet – iOS-style external share bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class ExternalShareSheet extends StatelessWidget {
  const ExternalShareSheet({
    super.key,
    this.postLink = 'https://collabster.app/post/1',
  });

  final String postLink;

  static const _kPurple = Color(0xFF4338CA);
  static const _kTextDark = Color(0xFF1A1A2E);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kDivider = Color(0xFFE5E7EB);
  static const _kBg = Color(0xFFF8F9FC);

  static void show(BuildContext context,
      {String postLink = 'https://collabster.app/post/1'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExternalShareSheet(postLink: postLink),
    );
  }

  static const _apps = [
    _AppItem('Messages', Icons.message_rounded,     Color(0xFF22C55E)),
    _AppItem('Mail',     Icons.mail_rounded,        Color(0xFF3B82F6)),
    _AppItem('WhatsApp', Icons.tag_rounded,         Color(0xFF7C3AED)),
    _AppItem('X',        Icons.close,               Color(0xFF111827)),
    _AppItem('LinkedIn', Icons.work_rounded,        Color(0xFF0A66C2)),
  ];

  static const _contacts = [
    _ContactItem('Sanjana', Color(0xFF4338CA), 'S'),
    _ContactItem('David',   Color(0xFF059669), 'D'),
    _ContactItem('Elena',   Color(0xFF7C3AED), 'E'),
    _ContactItem('Marcus',  Color(0xFF9CA3AF), 'M'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag handle ──────────────────────────────────────────────────
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _kDivider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Header ───────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Share with',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _kTextDark,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Recent contacts row ───────────────────────────────────────────
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ..._contacts.map(
                  (c) => _ContactBubble(
                    contact: c,
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        _snackBar('Shared with ${c.name}!'),
                      );
                    },
                  ),
                ),
                _MoreBubble(
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      _snackBar('Opening contacts…'),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── App icons row ─────────────────────────────────────────────────
          SizedBox(
            height: 88,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _apps
                  .map(
                    (app) => _AppBubble(
                      app: app,
                      onTap: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          _snackBar('Opening ${app.name}…'),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 12),

          // ── Utility actions ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _kDivider),
              ),
              child: Column(
                children: [
                  _UtilityRow(
                    icon: Icons.link_rounded,
                    iconColor: _kPurple,
                    label: 'Copy Link',
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: postLink));
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        _snackBar('Link copied to clipboard!'),
                      );
                    },
                    showDivider: true,
                  ),
                  _UtilityRow(
                    icon: Icons.save_alt_rounded,
                    iconColor: _kPurple,
                    label: 'Save to Files',
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        _snackBar('Saved to Files!'),
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  SnackBar _snackBar(String msg) => SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _kPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Data classes
// ─────────────────────────────────────────────────────────────────────────────

class _AppItem {
  final String name;
  final IconData icon;
  final Color color;
  const _AppItem(this.name, this.icon, this.color);
}

class _ContactItem {
  final String name;
  final Color color;
  final String initial;
  const _ContactItem(this.name, this.color, this.initial);
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ContactBubble extends StatefulWidget {
  const _ContactBubble({required this.contact, required this.onTap});
  final _ContactItem contact;
  final VoidCallback onTap;

  @override
  State<_ContactBubble> createState() => _ContactBubbleState();
}

class _ContactBubbleState extends State<_ContactBubble> {
  bool _pressed = false;

  static const _kTextDark = Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 72,
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.contact.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.contact.color.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.contact.initial,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: widget.contact.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: _kTextDark,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreBubble extends StatefulWidget {
  const _MoreBubble({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_MoreBubble> createState() => _MoreBubbleState();
}

class _MoreBubbleState extends State<_MoreBubble> {
  bool _pressed = false;

  static const _kTextMid = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 72,
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                  border: Border.all(color: _kBorder, width: 1.5),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  size: 24,
                  color: _kTextMid,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'More',
                style: TextStyle(
                  fontSize: 11.5,
                  color: _kTextMid,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBubble extends StatefulWidget {
  const _AppBubble({required this.app, required this.onTap});
  final _AppItem app;
  final VoidCallback onTap;

  @override
  State<_AppBubble> createState() => _AppBubbleState();
}

class _AppBubbleState extends State<_AppBubble> {
  bool _pressed = false;

  static const _kTextDark = Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 72,
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: widget.app.color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: widget.app.color.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(widget.app.icon, size: 24, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                widget.app.name,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: _kTextDark,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UtilityRow extends StatefulWidget {
  const _UtilityRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    required this.showDivider,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  State<_UtilityRow> createState() => _UtilityRowState();
}

class _UtilityRowState extends State<_UtilityRow> {
  bool _pressed = false;

  static const _kTextDark = Color(0xFF1A1A2E);
  static const _kDivider = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _pressed ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Row(
                children: [
                  Icon(widget.icon, size: 20, color: widget.iconColor),
                  const SizedBox(width: 14),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _kTextDark,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showDivider)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Divider(color: _kDivider, height: 1, thickness: 1),
              ),
          ],
        ),
      ),
    );
  }
}
