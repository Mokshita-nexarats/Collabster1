import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/di/providers.dart';
import '../../model/startup_models.dart';
import '../../model/team_chat_message.dart';
import 'team_member_profile_screen.dart';
import '../widgets/startup_color_helper.dart';

class TeamChatScreen extends ConsumerStatefulWidget {
  const TeamChatScreen({
    super.key,
    required this.member,
    this.startupName = 'Collabster',
  });

  final TeamMember member;
  final String startupName;

  @override
  ConsumerState<TeamChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends ConsumerState<TeamChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmoji = false;

  static const _emojis = ['👍', '❤️', '😂', '😮', '😢', '🙌'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamViewModelProvider.notifier).markAsRead(widget.member.name);
      ref.read(teamViewModelProvider.notifier).getMessagesFor(widget.member.name);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeamMemberProfileScreen(
          member: widget.member,
          startupName: widget.startupName,
        ),
      ),
    );
  }

  void _handleSend() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    ref.read(teamViewModelProvider.notifier).sendMessage(widget.member.name, text);
    _msgController.clear();
    setState(() => _showEmoji = false);
    _focusNode.requestFocus();
    Future.delayed(const Duration(milliseconds: 120), _scrollToBottom);
    Future.delayed(const Duration(milliseconds: 2200), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _showReactionPicker(int index) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'React to this message',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _emojis.map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(teamViewModelProvider.notifier).addReaction(
                            widget.member.name, index, emoji);
                        Navigator.pop(context);
                      },
                      child: AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 120),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F9FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(emoji, style: const TextStyle(fontSize: 26)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionBtn(Icons.copy_rounded, 'Copy', () {
                      Navigator.pop(context);
                      final msgs = ref
                          .read(teamViewModelProvider)
                          .chatMessages[widget.member.name] ?? [];
                      if (index < msgs.length) {
                        Clipboard.setData(ClipboardData(text: msgs[index].text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }
                    }),
                    _actionBtn(Icons.reply_rounded, 'Reply', () {
                      Navigator.pop(context);
                    }),
                    _actionBtn(Icons.delete_outline_rounded, 'Delete', () {
                      Navigator.pop(context);
                    }, isDestructive: true),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap,
      {bool isDestructive = false}) {
    final color =
        isDestructive ? const Color(0xFFEF4444) : const Color(0xFF0088CC);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamViewModelProvider);
    final messages = ref.read(teamViewModelProvider.notifier).getMessagesFor(widget.member.name);
    final isTyping = state.isTypingFor(widget.member.name);

    return Scaffold(
      backgroundColor: const Color(0xFFF0EBF8),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Messages list ────────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
                setState(() => _showEmoji = false);
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isTyping && index == messages.length) {
                    return _typingBubble();
                  }
                  final msg = messages[index];
                  final prevIsMe = index > 0 ? messages[index - 1].isMe : null;
                  final showHeader = prevIsMe == null || prevIsMe != msg.isMe;
                  return _chatBubble(msg, index, showHeader);
                },
              ),
            ),
          ),

          // ── Input box ────────────────────────────────────────────────
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF229ED9), Color(0xFF006699)],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: GestureDetector(
        onTap: _openProfile,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    widget.member.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.member.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Active now · ${widget.member.role}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline_rounded, color: Colors.white),
          onPressed: _openProfile,
          tooltip: 'View Profile',
        ),
      ],
    );
  }



  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg', 'gif'],
    );
    if (result == null || result.files.isEmpty || result.files.first.path == null) return;
    if (!mounted) return;
    final fileName = result.files.first.name;
    final fileSize = (result.files.first.size / 1024).toStringAsFixed(1);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attached: $fileName ($fileSize KB)'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji panel
            if (_showEmoji)
              Container(
                height: 200,
                color: const Color(0xFFF9FAFB),
                child: GridView.count(
                  crossAxisCount: 8,
                  padding: const EdgeInsets.all(12),
                  children: [
                    '😀','😁','😂','🤣','😃','😄','😅','😆',
                    '😇','🥰','😍','🤩','😘','😗','☺️','😚',
                    '🙂','🤗','🤔','🤐','😐','😑','😶','😏',
                    '👍','👏','🙌','🤝','👌','✌️','🤞','🙏',
                    '🔥','💯','⭐','🎉','🚀','💡','📊','✅',
                  ]
                      .map((e) => GestureDetector(
                            onTap: () {
                              _msgController.text += e;
                              _msgController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _msgController.text.length),
                              );
                            },
                            child: Center(
                              child: Text(e,
                                  style: const TextStyle(fontSize: 22)),
                            ),
                          ))
                      .toList(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Emoji toggle
                  IconButton(
                    icon: Icon(
                      _showEmoji
                          ? Icons.keyboard_alt_outlined
                          : Icons.emoji_emotions_outlined,
                      color: const Color(0xFF0088CC),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() => _showEmoji = !_showEmoji);
                      if (_showEmoji) {
                        _focusNode.unfocus();
                      } else {
                        _focusNode.requestFocus();
                      }
                    },
                  ),

                  // Attachment button
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded,
                        color: Color(0xFF0088CC), size: 22),
                    onPressed: _pickFile,
                  ),

                  // Text field
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _msgController,
                        focusNode: _focusNode,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        onTap: () => setState(() => _showEmoji = false),
                        decoration: InputDecoration(
                          hintText:
                              'Message ${widget.member.name.split(' ').first}...',
                          hintStyle: const TextStyle(
                              color: Color(0xFF9CA3AF), fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send button
                  GestureDetector(
                    onTap: _handleSend,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF229ED9), Color(0xFF006699)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF0088CC).withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Chat Bubble ──────────────────────────────────────────────────────────
  Widget _chatBubble(TeamChatMessage msg, int index, bool showHeader) {
    final isMe = msg.isMe;

    return GestureDetector(
      onLongPress: () => _showReactionPicker(index),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showHeader && !isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4, top: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: StartupColorHelper.fromKey(widget.member.badgeColorKey)
                        .withValues(alpha: 0.15),
                    child: Text(
                      widget.member.initials[0],
                      style: TextStyle(
                        color: StartupColorHelper.fromKey(widget.member.badgeColorKey),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.member.name.split(' ').first,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                bottom: msg.reactions.isEmpty ? 8 : 4,
                left: isMe ? 40 : 0,
                right: isMe ? 0 : 40,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.74,
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Bubble
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF0088CC) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isMe
                                  ? const Color(0xFF0088CC)
                                  : Colors.black)
                              .withValues(alpha: isMe ? 0.25 : 0.05),
                          blurRadius: isMe ? 12 : 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : const Color(0xFF12233D),
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg.time,
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white.withValues(alpha: 0.65)
                                    : const Color(0xFF9CA3AF),
                                fontSize: 10,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              Icon(
                                msg.status == MessageStatus.seen
                                    ? Icons.done_all_rounded
                                    : Icons.done_rounded,
                                size: 13,
                                color: msg.status == MessageStatus.seen
                                    ? const Color(0xFF93C5FD)
                                    : Colors.white
                                        .withValues(alpha: 0.6),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Reactions row
                  if (msg.reactions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: msg.reactions
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  child: Text(e,
                                      style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Typing bubble ────────────────────────────────────────────────────────
  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BouncingDot(delay: 0),
            const SizedBox(width: 4),
            _BouncingDot(delay: 200),
            const SizedBox(width: 4),
            _BouncingDot(delay: 400),
          ],
        ),
      ),
    );
  }
}

// ── Animated bouncing dot ─────────────────────────────────────────────────
class _BouncingDot extends StatefulWidget {
  final int delay;
  const _BouncingDot({required this.delay});

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF0088CC).withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
