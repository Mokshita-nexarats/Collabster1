import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SavedItemsScreen – Matches the exact design of the Saved Screen
// ─────────────────────────────────────────────────────────────────────────────

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All Items', 'Posts', 'Articles', 'Media'];

  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark = Color(0xFF111827);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kBg = Color(0xFFFFFFFF);

  final List<_SavedItem> _allSavedItems = [
    _SavedItem(
      id: '1',
      authorName: 'Sarah Jenkins',
      savedAgo: 'Saved 2 hours ago',
      type: 'Articles',
      title: 'The Future of Remote Collaboration in Soft Tech Environments',
      subtitle:
          'Exploring how minimalist, soft-toned UI design impacts cognitive load during extended...',
      imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600&auto=format&fit=crop&q=80',
      isVideo: false,
    ),
    _SavedItem(
      id: '2',
      authorName: 'Alex Rivera',
      savedAgo: 'Saved 1 day ago',
      type: 'Posts',
      title: '10 CSS Grid Tricks for Fluid Layouts',
      subtitle:
          'Mastering the grid is essential for modern web design. Here are ten practical tips for creating flexible, responsive interfaces without relying on...',
      isVideo: false,
    ),
    _SavedItem(
      id: '3',
      authorName: 'Collabster Official',
      savedAgo: 'Saved 3 days ago',
      type: 'Media',
      title: 'Introduction to Tonal Layers',
      imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&auto=format&fit=crop&q=80',
      isVideo: true,
    ),
  ];

  late Set<String> _savedIds;

  @override
  void initState() {
    super.initState();
    _savedIds = _allSavedItems.map((e) => e.id).toSet();
  }

  void _toggleSave(String id, String title) {
    setState(() {
      if (_savedIds.contains(id)) {
        _savedIds.remove(id);
      } else {
        _savedIds.add(id);
      }
    });

    final isSaved = _savedIds.contains(id);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved ? 'Saved to bookmarks' : 'Removed from saved items',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: isSaved ? _kPurple : Colors.grey.shade800,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<_SavedItem> get _filteredItems {
    final filter = _filters[_selectedFilterIndex];
    if (filter == 'All Items') {
      return _allSavedItems;
    }
    return _allSavedItems.where((item) => item.type == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Bar (Back arrow + Help) ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: _kPurple,
                        size: 24,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text('Saved Items Help'),
                          content: const Text(
                            'Here you can find all your saved posts, articles, and media. Tap the bookmark icon to remove items from your collection.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Got it', style: TextStyle(color: _kPurple)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Help',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kTextMid,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Header Title ──────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(
                'Saved',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _kPurple,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Horizontal Filter Chips ───────────────────────────────────
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? _kPurple : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? _kPurple : _kBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                          color: selected ? Colors.white : _kTextMid,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // ── Items List ────────────────────────────────────────────────
            Expanded(
              child: _filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      itemCount: _filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSaved = _savedIds.contains(item.id);
                        return _buildSavedCard(item, isSaved);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card Widget ────────────────────────────────────────────────────────────

  Widget _buildSavedCard(_SavedItem item, bool isSaved) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder.withValues(alpha: 0.8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _kPurpleLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.isVideo ? Icons.play_circle_fill_rounded : Icons.person_rounded,
                  color: _kPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.authorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kTextDark,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.savedAgo,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: _kTextMid,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Bookmark Icon Ribbon
              GestureDetector(
                onTap: () => _toggleSave(item.id, item.title),
                child: Icon(
                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isSaved ? _kPurple : Colors.grey.shade400,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _kTextDark,
              height: 1.3,
            ),
          ),

          // Subtitle if available
          if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.subtitle!,
              style: const TextStyle(
                fontSize: 12.5,
                color: _kTextMid,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Media / Image preview if present
          if (item.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    item.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _kPurpleLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 36, color: _kPurple),
                          SizedBox(height: 6),
                          Text('Image Preview', style: TextStyle(fontSize: 12, color: _kPurple, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  if (item.isVideo)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: _kPurple,
                        size: 32,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: _kPurpleLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_outline_rounded, size: 36, color: _kPurple),
          ),
          const SizedBox(height: 16),
          const Text(
            'No saved items here',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kTextDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Items you save will appear in this category',
            style: TextStyle(fontSize: 13, color: _kTextMid),
          ),
        ],
      ),
    );
  }
}

class _SavedItem {
  final String id;
  final String authorName;
  final String savedAgo;
  final String type; // 'Posts', 'Articles', 'Media'
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final bool isVideo;

  _SavedItem({
    required this.id,
    required this.authorName,
    required this.savedAgo,
    required this.type,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.isVideo = false,
  });
}
