import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DirectMessageScreen – 1-on-1 DM screen opened from a user's profile
// Matches the provided design: avatar header, chat bubbles, message input bar
// ─────────────────────────────────────────────────────────────────────────────

class DirectMessageScreen extends StatefulWidget {
  const DirectMessageScreen({
    super.key,
    required this.name,
    required this.handle,
    required this.avatarColor,
    required this.initials,
    this.isOnline = true,
  });

  final String name;
  final String handle;
  final Color avatarColor;
  final String initials;
  final bool isOnline;

  @override
  State<DirectMessageScreen> createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleDark = Color(0xFF3730A3);
  static const _kTextDark = Color(0xFF111827);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kBg = Color(0xFFF8F9FC);
  static const _kInputBg = Color(0xFFF1F5F9);
  static const _kOnline = Color(0xFF22C55E);

  // Seeded chat messages — matching the mockup
  final List<_DmMessage> _messages = [
    _DmMessage(
      text: 'Hello, Good Morning! ☀️',
      isMine: true,
      time: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    _DmMessage(
      text: 'Haha, Good Morning! ✈️',
      isMine: false,
      time: DateTime.now().subtract(const Duration(minutes: 6)),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_DmMessage(text: text, isMine: true, time: DateTime.now()));
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? '12' : '${t.hour % 12}';
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // ── Centered profile intro ──────────────────────────────────
                _ProfileIntroHeader(
                  name: widget.name,
                  handle: widget.handle,
                  avatarColor: widget.avatarColor,
                  initials: widget.initials,
                  isOnline: widget.isOnline,
                ),
                const SizedBox(height: 24),

                // ── Messages ────────────────────────────────────────────────
                ..._messages.map(
                  (msg) => _buildBubble(msg),
                ),
              ],
            ),
          ),

          // ── Input bar ───────────────────────────────────────────────────
          _buildInputBar(context),
        ],
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: _kTextDark,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 4,
      title: Row(
        children: [
          // Avatar in app bar
          Stack(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: widget.avatarColor.withValues(alpha: 0.15),
                child: Text(
                  widget.initials,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: widget.avatarColor,
                  ),
                ),
              ),
              if (widget.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _kOnline,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Text(
            widget.handle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _kTextDark,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam_outlined, size: 22, color: _kTextMid),
          onPressed: () => _showToast(context, 'Video call coming soon'),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline_rounded, size: 20, color: _kTextMid),
          onPressed: () => _showToast(context, 'Profile info coming soon'),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Chat bubble ──────────────────────────────────────────────────────────

  Widget _buildBubble(_DmMessage msg) {
    final isMine = msg.isMine;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.72,
            ),
            margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              gradient: isMine
                  ? const LinearGradient(
                      colors: [_kPurple, _kPurpleDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isMine ? null : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMine ? 18 : 4),
                bottomRight: Radius.circular(isMine ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: isMine
                      ? _kPurple.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isMine ? Colors.white : _kTextDark,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(msg.time),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _kTextMid,
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.done_all_rounded,
                    size: 13,
                    color: _kPurple,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── Message input bar ────────────────────────────────────────────────────

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14,
        8,
        14,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          // Image attachment
          _InputIconBtn(
            icon: Icons.image_outlined,
            onTap: () => _showToast(context, 'Attach image coming soon'),
          ),
          const SizedBox(width: 6),
          // Voice
          _InputIconBtn(
            icon: Icons.mic_none_rounded,
            onTap: () => _showToast(context, 'Voice message coming soon'),
          ),
          const SizedBox(width: 10),

          // Text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _kInputBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: const TextStyle(
                  fontSize: 14,
                  color: _kTextDark,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: _kTextMid,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_kPurple, _kPurpleDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _kPurple.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _kPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile intro header — centered avatar + name + handle + status chip
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileIntroHeader extends StatelessWidget {
  const _ProfileIntroHeader({
    required this.name,
    required this.handle,
    required this.avatarColor,
    required this.initials,
    required this.isOnline,
  });

  final String name;
  final String handle;
  final Color avatarColor;
  final String initials;
  final bool isOnline;

  static const _kTextDark = Color(0xFF111827);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kOnline = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with online dot
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: avatarColor.withValues(alpha: 0.15),
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: avatarColor,
                ),
              ),
            ),
            if (isOnline)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _kOnline,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Name
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _kTextDark,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 3),

        // Handle
        Text(
          handle,
          style: const TextStyle(
            fontSize: 13,
            color: _kTextMid,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),

        // Status chip
        if (isOnline)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Active now',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _kTextMid,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small icon button for the input bar (image / mic)
// ─────────────────────────────────────────────────────────────────────────────

class _InputIconBtn extends StatelessWidget {
  const _InputIconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  static const _kTextMid = Color(0xFF6B7280);
  static const _kInputBg = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _kInputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: _kTextMid),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class _DmMessage {
  final String text;
  final bool isMine;
  final DateTime time;

  _DmMessage({
    required this.text,
    required this.isMine,
    required this.time,
  });
}
