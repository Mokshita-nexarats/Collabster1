import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/startup_models.dart';
import '../../../../core/di/providers.dart';
import '../widgets/startup_color_helper.dart';

class StartupProductsScreen extends ConsumerStatefulWidget {
  const StartupProductsScreen({
    super.key,
    required this.startupName,
    this.autoOpenAddProductSheet = false,
  });
  final String startupName;
  final bool autoOpenAddProductSheet;

  @override
  ConsumerState<StartupProductsScreen> createState() => _StartupProductsScreenState();
}

class _StartupProductsScreenState extends ConsumerState<StartupProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.autoOpenAddProductSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddProductSheet();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF12233D),
      ),
    );
  }

  void _showAddProductSheet() {
    _openProductForm(existing: null, index: null);
  }

  void _showEditSheet(StartupProduct product, int index) {
    _openProductForm(existing: product, index: index);
  }

  void _openProductForm({StartupProduct? existing, int? index}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final versionCtrl = TextEditingController(text: existing?.version ?? 'v1.0');

    final isEditing = existing != null;

    final statuses = ['LIVE', 'BETA', 'IN DEV', 'COMING SOON'];
    final categories = ['AI / ML', 'SaaS', 'Mobile App', 'Enterprise', 'BioTech', 'HealthTech'];

    String selectedStatus = existing?.status ?? 'LIVE';
    String selectedCategory = 'AI / ML';

    String colorKeyForStatus(String st) {
      if (st == 'LIVE') return 'live';
      if (st == 'BETA') return 'beta';
      if (st == 'COMING SOON') return 'draft';
      return 'blue';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF229ED9).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isEditing ? Icons.edit_rounded : Icons.inventory_2_rounded,
                          color: const Color(0xFF229ED9),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEditing ? 'Edit Product' : 'Add New Product',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _field(
                    controller: nameCtrl,
                    label: 'Product Name *',
                    hint: 'e.g. MedVision Diagnostic AI',
                    icon: Icons.title_rounded,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: descCtrl,
                    label: 'Short Description *',
                    hint: 'e.g. AI platform for early disease detection',
                    icon: Icons.description_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: versionCtrl,
                    label: 'Version',
                    hint: 'e.g. v1.0',
                    icon: Icons.commit_outlined,
                  ),
                  const SizedBox(height: 14),
                  _chipSection(
                    label: 'Status',
                    items: statuses,
                    selected: selectedStatus,
                    accentColor: const Color(0xFF229ED9),
                    onSelect: (s) => setModalState(() => selectedStatus = s),
                  ),
                  const SizedBox(height: 14),
                  _chipSection(
                    label: 'Category',
                    items: categories,
                    selected: selectedCategory,
                    accentColor: const Color(0xFF0088CC),
                    onSelect: (s) => setModalState(() => selectedCategory = s),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        final desc = descCtrl.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(content: Text('Please enter a product name')),
                          );
                          return;
                        }
                        final statusKey = colorKeyForStatus(selectedStatus);
                        final newProduct = StartupProduct(
                          name: name,
                          description: desc.isNotEmpty ? desc : 'A $selectedCategory product.',
                          status: selectedStatus,
                          statusColorKey: statusKey,
                          version: versionCtrl.text.trim().isNotEmpty
                              ? versionCtrl.text.trim()
                              : 'v1.0',
                          rating: existing?.rating ?? 5.0,
                          saves: existing?.saves ?? 0,
                          downloads: existing?.downloads ?? 0,
                          tagColorKey: statusKey,
                        );
                        if (isEditing && index != null) {
                          ref.read(productsViewModelProvider.notifier).updateProduct(index, newProduct);
                        } else {
                          ref.read(productsViewModelProvider.notifier).addProduct(newProduct);
                        }
                        Navigator.pop(ctx);
                        _showSnack(isEditing
                            ? '"$name" updated successfully!'
                            : '"$name" product published & live!');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF229ED9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        isEditing ? Icons.check_rounded : Icons.check_circle_rounded,
                        size: 18,
                      ),
                      label: Text(
                        isEditing ? 'Save Changes' : 'Publish Product',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ref.read(productsViewModelProvider.notifier).removeProduct(index!);
                          _showSnack('Product removed.');
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text('Remove Product',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF0F9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _chipSection({
    required String label,
    required List<String> items,
    required String selected,
    required Color accentColor,
    required ValueChanged<String> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = item == selected;
            return GestureDetector(
              onTap: () => onSelect(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? accentColor : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showProductDetail(StartupProduct product, int index) {
    final statusIcon = product.status == 'LIVE'
        ? Icons.check_circle_rounded
        : product.status == 'BETA'
            ? Icons.science_rounded
            : Icons.code_rounded;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.82),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header image area
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0088CC).withValues(alpha: 0.85),
                    const Color(0xFF0088CC),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.biotech,
                        size: 60, color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  Positioned(
                    top: 12,
                    left: 16,
                    child: Row(
                      children: [
                        _statusBadge(product.status, StartupColorHelper.fromKey(product.tagColorKey)),
                        const SizedBox(width: 8),
                        _versionBadge(product.version),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12233D)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: StartupColorHelper.fromKey(product.tagColorKey).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              Icon(statusIcon,
                                  color: StartupColorHelper.fromKey(product.tagColorKey), size: 13),
                              const SizedBox(width: 4),
                              Text(
                                product.status,
                                style: TextStyle(
                                  color: StartupColorHelper.fromKey(product.tagColorKey),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF6B7280), height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    // Stats row
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statBlock(Icons.star_rounded,
                              product.rating.toStringAsFixed(1),
                              'Rating', const Color(0xFFF59E0B)),
                          _vertDivider(),
                          _statBlock(Icons.bookmark_outline,
                              _formatK(product.saves), 'Saves',
                              const Color(0xFF229ED9)),
                          _vertDivider(),
                          _statBlock(Icons.download_outlined,
                              _formatK(product.downloads), 'Downloads',
                              const Color(0xFF0088CC)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Info rows
                    _infoRow(Icons.commit_outlined, 'Version', product.version),
                    const SizedBox(height: 10),
                    _infoRow(Icons.label_outline, 'Status', product.status),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _showEditSheet(product, index);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF229ED9),
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.edit_rounded, size: 16),
                            label: const Text('Edit Product',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ref.read(productsViewModelProvider.notifier).removeProduct(index);
                            _showSnack('Product removed.');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 16),
                          label: const Text('Remove',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBlock(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D))),
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
      ],
    );
  }

  Widget _vertDivider() => Container(
        width: 1,
        height: 40,
        color: const Color(0xFFE5E7EB),
      );

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF9CA3AF))),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF12233D))),
      ],
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(status,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }

  Widget _versionBadge(String version) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(version,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsViewModelProvider);
    final filtered = productsState.filteredProducts;
    final liveCount = productsState.products.where((p) => p.status == 'LIVE').length;
    final totalDownloads = productsState.products.fold<int>(0, (sum, p) => sum + p.downloads);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0088CC),
                    Color(0xFF229ED9),
                    Color(0xFF0088CC),
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Our Products',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      Text(
                        '${productsState.products.length} products',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _headerChip(Icons.check_circle_outline, '$liveCount Live',
                          const Color(0xFF059669)),
                      const SizedBox(width: 8),
                      _headerChip(Icons.download_outlined,
                          '${_formatK(totalDownloads)} Downloads',
                          const Color(0xFF0088CC)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => ref
                        .read(productsViewModelProvider.notifier)
                        .setSearchQuery(value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      prefixIcon: Icon(Icons.search,
                          color: Colors.white.withValues(alpha: 0.7)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          filtered.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 64,
                            color: const Color(0xFF9CA3AF).withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No products found',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9CA3AF)),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _showAddProductSheet,
                          child: const Text(
                            'Tap + to add your first product',
                            style: TextStyle(
                                color: Color(0xFF229ED9),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ProductCard(
                          product: filtered[index],
                          realIndex: productsState.products.indexOf(filtered[index]),
                          onTap: () => _showProductDetail(
                              filtered[index], productsState.products.indexOf(filtered[index])),
                          onEdit: () => _showEditSheet(
                              filtered[index], productsState.products.indexOf(filtered[index])),
                        ),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _headerChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _formatK(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
  }
}

// ─── Product Card ────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.realIndex,
    required this.onTap,
    required this.onEdit,
  });

  final StartupProduct product;
  final int realIndex;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  String _formatK(int v) => v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : '$v';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image banner
            Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0088CC).withValues(alpha: 0.8),
                    const Color(0xFF0088CC),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.biotech,
                        size: 58,
                        color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: StartupColorHelper.fromKey(product.tagColorKey).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(product.status,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(product.version,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D))),
                  const SizedBox(height: 4),
                  Text(product.description,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          height: 1.4)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFF59E0B), size: 15),
                      const SizedBox(width: 3),
                      Text(product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF12233D))),
                      const SizedBox(width: 14),
                      const Icon(Icons.bookmark_outline,
                          color: Color(0xFF9CA3AF), size: 15),
                      const SizedBox(width: 3),
                      Text(_formatK(product.saves),
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF6B7280))),
                      const SizedBox(width: 14),
                      const Icon(Icons.download_outlined,
                          color: Color(0xFF9CA3AF), size: 15),
                      const SizedBox(width: 3),
                      Text(_formatK(product.downloads),
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF6B7280))),
                      const Spacer(),
                      GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF229ED9)),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF229ED9),
                            ),
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
    );
  }
}
