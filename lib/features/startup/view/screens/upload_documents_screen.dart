import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'review_your_details_screen.dart';

class DocItem {
  DocItem({required this.title, required this.required, this.path});
  final String title;
  final bool required;
  String? path;

  bool get uploaded => path != null;
  String get fileName =>
      path == null ? '' : path!.split('/').last.split('\\').last;
}

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _skyLight = Color(0xFFE0F2FE);

  final List<DocItem> _docs = [
    DocItem(title: 'PAN Card', required: true),
    DocItem(title: 'GST Certificate', required: true),
    DocItem(title: 'Other Document', required: false),
  ];

  Future<void> _pickDoc(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (!mounted) return;
    setState(() {
      _docs[index].path = file.path ?? file.name;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_docs[index].title} uploaded'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeDoc(int index) {
    setState(() => _docs[index].path = null);
  }

  void _onNext() {
    FocusScope.of(context).unfocus();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReviewYourDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 28, top: 15),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Color(0xFF202020),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Steps — Company Details complete (all done)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  _step('1', done: true),
                  _line(done: true),
                  _step('2', done: true),
                  _line(done: true),
                  _step('3', done: true),
                  _line(done: true),
                  _step('4', done: true),
                  _line(done: true),
                  _step('5', done: true),
                ],
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Company Details',
              style: TextStyle(
                fontSize: 11,
                color: _skyBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Documents',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Provide the required company documents.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF626A79)),
                    ),
                    const SizedBox(height: 16),

                    // Plain list — no outer card, no fixed height
                    for (int i = 0; i < _docs.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      _documentCard(index: i, doc: _docs[i]),
                    ],
                    const SizedBox(height: 28),

                    // Next
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: ElevatedButton(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _skyBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 19),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(String number, {bool active = false, bool done = false}) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active || done ? _skyBlue : const Color(0xFFE9E9EE),
      ),
      child: done && !active
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              number,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : const Color(0xFF747783),
              ),
            ),
    );
  }

  Widget _line({bool done = false}) {
    return Expanded(
      child: Container(
        height: 1,
        color: done ? _skyBlue : const Color(0xFFE5E3EA),
      ),
    );
  }

  Widget _documentCard({required int index, required DocItem doc}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE1E2EA)),
      ),
      child: Row(
        children: [
          // Document icon — sky tint
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _skyLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 21,
              color: doc.uploaded ? _skyBlue : const Color(0xFF626A79),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: doc.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                    children: [
                      TextSpan(
                        text: doc.required ? ' (Required)' : ' (Optional)',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF626A79),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  doc.uploaded ? doc.fileName : 'PDF, JPG, PNG (Max. 5MB)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: doc.uploaded ? _skyBlue : const Color(0xFF626A79),
                    fontWeight: doc.uploaded
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (doc.uploaded)
            GestureDetector(
              onTap: () => _removeDoc(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _skyLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Uploaded',
                      style: TextStyle(
                        fontSize: 12,
                        color: _skyBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.check_circle_outline, size: 14, color: _skyBlue),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              width: 82,
              height: 37,
              child: OutlinedButton(
                onPressed: () => _pickDoc(index),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _skyBlue,
                  side: const BorderSide(color: _skyBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Upload', style: TextStyle(fontSize: 13)),
              ),
            ),
        ],
      ),
    );
  }
}
