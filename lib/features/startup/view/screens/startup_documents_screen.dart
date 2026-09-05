import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../model/startup_models.dart';
import '../../../../core/di/providers.dart';
import '../widgets/startup_color_helper.dart';

class StartupDocumentsScreen extends ConsumerStatefulWidget {
  const StartupDocumentsScreen({super.key});

  @override
  ConsumerState<StartupDocumentsScreen> createState() =>
      _StartupDocumentsScreenState();
}

class _StartupDocumentsScreenState extends ConsumerState<StartupDocumentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDocumentDetails(DocumentItem doc) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
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
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: StartupColorHelper.fromKey(doc.colorKey)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    doc.type == 'PDF'
                        ? Icons.picture_as_pdf_rounded
                        : doc.type == 'XLSX' || doc.type == 'Spreadsheet'
                            ? Icons.table_chart_rounded
                            : Icons.insert_drive_file_rounded,
                    color: StartupColorHelper.fromKey(doc.colorKey),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D),
                        ),
                      ),
                      Text(
                        '${doc.type} · ${doc.size} · ${doc.category}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Document Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doc.description ?? 'No description provided for this document.',
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(
                        'Added: ${doc.dateAdded ?? "Recent"}',
                        style:
                            const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening "${doc.name}" preview...'),
                          backgroundColor: const Color(0xFF0088CC),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: const Color(0xFF0088CC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: const Text('View Document',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Downloading "${doc.name}" (${doc.size})...'),
                        backgroundColor: const Color(0xFF059669),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    foregroundColor: const Color(0xFF0088CC),
                    side: const BorderSide(color: Color(0xFF0088CC)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Download',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDocumentSheet() {
    _openUploadSheetWithData(
      nameCtrl: TextEditingController(),
      size: '2.4 MB',
      type: 'PDF',
      category: 'Fundraising',
      attachedFileName: null,
    );
  }

  void _openUploadSheetWithData({
    required TextEditingController nameCtrl,
    required String size,
    required String type,
    required String category,
    required String? attachedFileName,
  }) {
    final categories = ['Fundraising', 'Legal', 'Product', 'Finance', 'HR', 'Other'];
    final types = ['PDF', 'XLSX', 'Spreadsheet', 'Doc', 'PNG'];

    var currentSize = size;
    var currentType = type;
    var currentCategory = category;
    var currentAttachedFileName = attachedFileName;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (sheetCtx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.upload_file_rounded,
                          color: Color(0xFF0088CC),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload New Document',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12233D),
                              ),
                            ),
                            Text(
                              'Add files to your startup repository',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetCtx),
                        icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Document Title *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Q3 Financial Audit',
                      prefixIcon: const Icon(Icons.description_outlined,
                          color: Color(0xFF6B7280), size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Color(0xFF0088CC), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSelected = cat == currentCategory;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0088CC),
                        backgroundColor: const Color(0xFFF3F4F6),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        onSelected: (_) =>
                            setModalState(() => currentCategory = cat),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Format Type',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: types.map((t) {
                      final isSelected = t == currentType;
                      return ChoiceChip(
                        label: Text(t),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0088CC),
                        backgroundColor: const Color(0xFFF3F4F6),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        onSelected: (_) =>
                            setModalState(() => currentType = t),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Attachment *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      try {
                        Navigator.pop(sheetCtx);
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: [
                            'pdf', 'xlsx', 'xls', 'doc', 'docx',
                            'png', 'jpg', 'ppt', 'pptx', 'csv', 'txt'
                          ],
                        );
                        if (result != null && result.files.isNotEmpty) {
                          final picked = result.files.first;
                          final fileName = picked.name;
                          final fileBytes = picked.size;
                          final fileSizeStr = fileBytes > 1024 * 1024
                              ? '${(fileBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
                              : '${(fileBytes / 1024).toStringAsFixed(0)} KB';
                          _openUploadSheetWithData(
                            nameCtrl: nameCtrl,
                            size: fileSizeStr,
                            type: currentType,
                            category: currentCategory,
                            attachedFileName: fileName,
                          );
                        }
                      } catch (e) {
                        debugPrint('FilePicker error: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error picking file: $e'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: currentAttachedFileName != null
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFE8F4FB).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentAttachedFileName != null
                              ? const Color(0xFF059669)
                              : const Color(0xFF0088CC).withValues(alpha: 0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            currentAttachedFileName != null
                                ? Icons.check_circle_rounded
                                : Icons.cloud_upload_outlined,
                            color: currentAttachedFileName != null
                                ? const Color(0xFF059669)
                                : const Color(0xFF0088CC),
                            size: 34,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentAttachedFileName != null
                                ? 'File Attached: $currentAttachedFileName ($currentSize)'
                                : 'Tap to Choose File / Browse Storage',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: currentAttachedFileName != null
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF0088CC),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentAttachedFileName != null
                                ? 'Ready to upload • Tap to change file'
                                : 'Supports PDF, XLSX, DOC, PNG up to 50MB',
                            style: const TextStyle(
                                color: Color(0xFF6B7280), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(sheetCtx).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a document title'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        if (currentAttachedFileName == null) {
                          ScaffoldMessenger.of(sheetCtx).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please tap "Choose File" to attach a document first'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        final colorKeyMap = {
                          'Fundraising': 'primary',
                          'Legal': 'red',
                          'Product': 'blue',
                          'Finance': 'live',
                          'HR': 'amber',
                          'Other': 'draft',
                        };
                        ref
                            .read(documentsViewModelProvider.notifier)
                            .addDocument(DocumentItem(
                              name: name,
                              type: currentType,
                              size: currentSize,
                              category: currentCategory,
                              colorKey:
                                  colorKeyMap[currentCategory] ?? 'primary',
                              dateAdded: 'Today',
                              description:
                                  'User uploaded document ($currentAttachedFileName).',
                            ));
                        ref
                            .read(documentsViewModelProvider.notifier)
                            .setSelectedCategory('All');
                        ref
                            .read(documentsViewModelProvider.notifier)
                            .setSearchQuery('');
                        _searchController.clear();
                        Navigator.pop(sheetCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text('"$name" uploaded successfully!'),
                              ],
                            ),
                            backgroundColor: const Color(0xFF059669),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.check_rounded, size: 20),
                      label: const Text('Complete Upload',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openCollectionSheet(DocumentCollection col, List<DocumentItem> allDocs) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
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
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: StartupColorHelper.fromKey(col.colorKey)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.folder_special_rounded,
                      color: StartupColorHelper.fromKey(col.colorKey),
                      size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(col.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      Text('${col.count} organized documents',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(col.description ?? 'AI organized collection for easy sharing and review.',
                style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563))),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: allDocs.take(col.count).length,
                itemBuilder: (context, i) {
                  final doc = allDocs[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file_outlined,
                              color: StartupColorHelper.fromKey(col.colorKey),
                              size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(doc.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Color(0xFF12233D))),
                          ),
                          Text(doc.size,
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF9CA3AF))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final documentsState = ref.watch(documentsViewModelProvider);
    final filteredDocs = documentsState.filteredDocuments;
    final pinnedDocs = documentsState.filteredPinned;
    final recentDocs = documentsState.filteredRecent;
    final collections = documentsState.collections;
    final isFiltering = documentsState.isFiltering;

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
                  colors: [Color(0xFF0088CC), Color(0xFF229ED9), Color(0xFF0088CC)],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20, right: 20, bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Documents',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => ref
                        .read(documentsViewModelProvider.notifier)
                        .setSearchQuery(value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search documents, files or folders...',
                      hintStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      prefixIcon: Icon(Icons.search,
                          color: Colors.white.withValues(alpha: 0.7)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(documentsViewModelProvider.notifier)
                                    .setSearchQuery('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Categories',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      const Spacer(),
                      if (documentsState.selectedCategory != 'All')
                        TextButton(
                          onPressed: () => ref
                              .read(documentsViewModelProvider.notifier)
                              .setSelectedCategory('All'),
                          child: const Text('Clear Filter',
                              style: TextStyle(
                                  color: Color(0xFF0088CC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                    children: [
                      _catChip(Icons.monetization_on_outlined, 'Fundraising',
                          const Color(0xFF0088CC), documentsState.selectedCategory),
                      _catChip(Icons.gavel_outlined, 'Legal',
                          const Color(0xFFDC2626), documentsState.selectedCategory),
                      _catChip(Icons.inventory_2_outlined, 'Product',
                          const Color(0xFF2563EB), documentsState.selectedCategory),
                      _catChip(Icons.account_balance_outlined, 'Finance',
                          const Color(0xFF059669), documentsState.selectedCategory),
                      _catChip(Icons.people_outline, 'HR',
                          const Color(0xFFF59E0B), documentsState.selectedCategory),
                      _catChip(Icons.folder_outlined, 'Other',
                          const Color(0xFF6B7280), documentsState.selectedCategory),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (pinnedDocs.isNotEmpty) ...[
                    Row(
                      children: const [
                        Text('Pinned',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12233D))),
                        SizedBox(width: 8),
                        Icon(Icons.push_pin, size: 16, color: Color(0xFF0088CC)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...pinnedDocs.map((d) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _DocCard(
                            doc: d,
                            pinned: true,
                            onTap: () => _openDocumentDetails(d),
                            onPinToggle: () => ref
                                .read(documentsViewModelProvider.notifier)
                                .togglePin(d),
                            onDelete: () => ref
                                .read(documentsViewModelProvider.notifier)
                                .removeDocument(d),
                          ),
                        )),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    children: [
                      Text(
                        isFiltering
                            ? 'Matching Documents (${filteredDocs.length})'
                            : 'Recent Documents',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF12233D)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (recentDocs.isEmpty && (pinnedDocs.isEmpty || !isFiltering))
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'No documents found matching your criteria.',
                          style:
                              TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ...recentDocs.map((d) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _DocCard(
                            doc: d,
                            pinned: false,
                            onTap: () => _openDocumentDetails(d),
                            onPinToggle: () => ref
                                .read(documentsViewModelProvider.notifier)
                                .togglePin(d),
                            onDelete: () => ref
                                .read(documentsViewModelProvider.notifier)
                                .removeDocument(d),
                          ),
                        )),
                  const SizedBox(height: 14),
                  if (!isFiltering) ...[
                    const Text('Smart Collections',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF12233D))),
                    const SizedBox(height: 4),
                    const Text(
                        'AI organized document groups for faster access.',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
                    const SizedBox(height: 12),
                    ...collections.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DocumentCollectionCard(
                            collection: c,
                            onTap: () => _openCollectionSheet(
                                c, documentsState.allDocuments),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showUploadDocumentSheet,
                  icon: const Icon(Icons.upload_outlined),
                  label: const Text('Upload New Document',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF0088CC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _catChip(
      IconData icon, String label, Color color, String selectedCategory) {
    final isSelected = selectedCategory.toLowerCase() == label.toLowerCase();
    return GestureDetector(
      onTap: () {
        ref.read(documentsViewModelProvider.notifier).setSelectedCategory(
            isSelected ? 'All' : label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F4FB) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF0088CC) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
                color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                color: isSelected
                    ? const Color(0xFF0088CC)
                    : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocCard extends StatelessWidget {
  const _DocCard({
    required this.doc,
    required this.pinned,
    required this.onTap,
    required this.onPinToggle,
    required this.onDelete,
  });

  final DocumentItem doc;
  final bool pinned;
  final VoidCallback onTap;
  final VoidCallback onPinToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: StartupColorHelper.fromKey(doc.colorKey)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                doc.type == 'PDF'
                    ? Icons.picture_as_pdf_outlined
                    : doc.type == 'XLSX' || doc.type == 'Spreadsheet'
                        ? Icons.table_chart_outlined
                        : Icons.insert_drive_file_outlined,
                color: StartupColorHelper.fromKey(doc.colorKey),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF12233D))),
                  Text('${doc.type} · ${doc.size}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
            if (pinned)
              const Icon(Icons.push_pin, size: 16, color: Color(0xFF0088CC)),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  color: Color(0xFF9CA3AF), size: 20),
              onSelected: (val) {
                if (val == 'view') {
                  onTap();
                } else if (val == 'pin') {
                  onPinToggle();
                } else if (val == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'pin',
                  child: Row(
                    children: [
                      Icon(pinned
                          ? Icons.push_pin_outlined
                          : Icons.push_pin, size: 18),
                      const SizedBox(width: 8),
                      Text(pinned ? 'Unpin Document' : 'Pin Document'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentCollectionCard extends StatelessWidget {
  const DocumentCollectionCard(
      {super.key, required this.collection, required this.onTap});
  final DocumentCollection collection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: StartupColorHelper.fromKey(collection.colorKey)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.folder_outlined,
                  color: StartupColorHelper.fromKey(collection.colorKey),
                  size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF12233D))),
                  Text('${collection.count} documents',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(
                    color: StartupColorHelper.fromKey(collection.colorKey)
                        .withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('Open →',
                  style: TextStyle(
                      color:
                          StartupColorHelper.fromKey(collection.colorKey),
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
