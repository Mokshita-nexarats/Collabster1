import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/activity_model.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();
  String _selectedCommunity = 'Flutter Developers';

  static const _accent = Color(0xFF229ED9);
  static const _accentLight = Color(0xFF0088CC);

  final List<String> _communities = const [
    'Flutter Developers',
    'Startup Founders',
    'UI/UX Designers',
    'AI Engineers',
    'Product Managers',
  ];

  final List<_PostTypeOption> _postTypes = const [
    _PostTypeOption(
      icon: Icons.forum_rounded,
      label: 'Discussion',
      color: Color(0xFF229ED9),
    ),
    _PostTypeOption(
      icon: Icons.help_outline_rounded,
      label: 'Question',
      color: Color(0xFF2563EB),
    ),
    _PostTypeOption(
      icon: Icons.article_outlined,
      label: 'Article',
      color: Color(0xFF059669),
    ),
    _PostTypeOption(
      icon: Icons.poll_rounded,
      label: 'Poll',
      color: Color(0xFF7C3AED),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      ref
          .read(postViewModelProvider.notifier)
          .updateTitle(_titleController.text.trim());
    });
    _contentController.addListener(() {
      ref
          .read(postViewModelProvider.notifier)
          .updateContent(_contentController.text.trim());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _closeScreen() {
    FocusScope.of(context).unfocus();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitPost() {
    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      _showError('Give your post a title first');
      return;
    }
    if (content.isEmpty) {
      _showError('Write something to share with your community');
      return;
    }

    final session = ref.read(authViewModelProvider).session;
    final authorName = session?.fullName ?? 'You';

    ref
        .read(postViewModelProvider.notifier)
        .submitPost(title, content, _selectedCommunity, authorName: authorName);

    ref
        .read(activityViewModelProvider.notifier)
        .addActivity(
          type: ActivityType.postCreated,
          title: 'You published a post',
          subtitle: title,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post published successfully!'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _closeScreen();
  }

  // ── UI helpers ───────────────────────────────────────────────────────────
  Widget _sectionLabel(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Row(
        children: [
          Icon(icon, size: 17, color: _accent),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: child,
    );
  }

  Widget _buildCommunitySelector() {
    return GestureDetector(
      onTap: _showCommunityPicker,
      child: _inputCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_accent, _accentLight],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.widgets_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCommunity,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Posting to this community',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF64748B),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommunityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _CommunityPickerSheet(
        communities: _communities,
        selected: _selectedCommunity,
        onSelected: (c) {
          setState(() => _selectedCommunity = c);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Widget _buildPostTypeSelector(String selectedPostType) {
    return _inputCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.6,
          children: _postTypes.map((type) {
            final isSelected = selectedPostType == type.label;
            return GestureDetector(
              onTap: () => ref
                  .read(postViewModelProvider.notifier)
                  .setPostType(type.label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? type.color.withValues(alpha: 0.08)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? type.color : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type.icon,
                      size: 19,
                      color: isSelected ? type.color : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isSelected
                            ? type.color
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return _inputCard(
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocus,
        maxLength: 80,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => _contentFocus.requestFocus(),
        style: const TextStyle(
          fontSize: 16.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E293B),
          height: 1.3,
        ),
        decoration: InputDecoration(
          hintText: 'Give your post a clear title',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Icon(Icons.title_rounded, color: _accent, size: 21),
          ),
          counterStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return _inputCard(
      child: TextField(
        controller: _contentController,
        focusNode: _contentFocus,
        maxLines: null,
        minLines: 7,
        maxLength: 2000,
        textInputAction: TextInputAction.newline,
        style: const TextStyle(
          fontSize: 14.5,
          height: 1.6,
          color: Color(0xFF334155),
        ),
        decoration: InputDecoration(
          hintText:
              'Share your thoughts, ideas, or questions with the community...',
          hintStyle: TextStyle(
            fontSize: 14.5,
            color: Colors.grey.shade400,
            height: 1.6,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Icon(Icons.edit_note_rounded, color: _accent, size: 22),
          ),
          counterStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final canPost =
        _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.viewInsetsOf(context).bottom.clamp(0.0, 16.0),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
      ),
      child: Row(
        children: [
          _buildAttachmentButton(
            Icons.image_outlined,
            'Image',
            const Color(0xFF059669),
          ),
          const SizedBox(width: 12),
          _buildAttachmentButton(
            Icons.link_rounded,
            'Link',
            const Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          _buildAttachmentButton(
            Icons.tag_rounded,
            'Tag',
            const Color(0xFF7C3AED),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _submitPost,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
              decoration: BoxDecoration(
                gradient: canPost
                    ? const LinearGradient(
                        colors: [_accent, _accentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: canPost ? null : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(22),
                boxShadow: canPost
                    ? [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.rocket_launch_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Publish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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

  Widget _buildAttachmentButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label attachments are coming soon'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postViewModelProvider);
    final selectedPostType = postState.selectedPostType;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF1E293B)),
          onPressed: _closeScreen,
        ),
        title: const Text(
          'New Post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Community', Icons.groups_outlined),
            _buildCommunitySelector(),
            const SizedBox(height: 26),
            _sectionLabel('Post type', Icons.category_outlined),
            _buildPostTypeSelector(selectedPostType),
            const SizedBox(height: 26),
            _sectionLabel('Share your thoughts', Icons.edit_note_rounded),
            _buildTitleField(),
            const SizedBox(height: 6),
            _buildContentField(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}

class _PostTypeOption {
  final IconData icon;
  final String label;
  final Color color;
  const _PostTypeOption({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _CommunityPickerSheet extends StatelessWidget {
  final List<String> communities;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CommunityPickerSheet({
    required this.communities,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Community',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose where to share your post',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...communities.map((c) {
            final isSelected = c == selected;
            return GestureDetector(
              onTap: () => onSelected(c),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF229ED9).withValues(alpha: 0.06)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF229ED9).withValues(alpha: 0.2)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(
                              const Color(0xFF229ED9),
                              const Color(0xFF7C3AED),
                              communities.indexOf(c) / communities.length,
                            )!,
                            Color.lerp(
                              const Color(0xFF0088CC),
                              const Color(0xFFA78BFA),
                              communities.indexOf(c) / communities.length,
                            )!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          c[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        c,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF229ED9),
                        size: 22,
                      )
                    else
                      Icon(
                        Icons.radio_button_unchecked_rounded,
                        color: Colors.grey.shade300,
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }
}
