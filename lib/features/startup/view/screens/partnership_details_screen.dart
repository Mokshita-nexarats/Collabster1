import 'package:flutter/material.dart';

import 'upload_documents_screen.dart';

class Partner {
  Partner({required this.name, required this.email});
  String name;
  String email;
}

class PartnershipDetailsScreen extends StatefulWidget {
  const PartnershipDetailsScreen({super.key});

  @override
  State<PartnershipDetailsScreen> createState() =>
      _PartnershipDetailsScreenState();
}

class _PartnershipDetailsScreenState extends State<PartnershipDetailsScreen> {
  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _skyLight = Color(0xFFE0F2FE);

  final List<Partner> _partners = [
    Partner(name: 'Neha Sharma', email: 'neha.sharma@technova.com'),
    Partner(name: 'Rohan Verma', email: 'rohan.verma@technova.com'),
  ];

  void _onNext() {
    FocusScope.of(context).unfocus();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UploadDocumentsScreen()),
    );
  }

  Future<void> _showPartnerSheet({Partner? existing, int? index}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final emailController = TextEditingController(text: existing?.email ?? '');
    final formKey = GlobalKey<FormState>();

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Form(
            key: formKey,
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
                const SizedBox(height: 20),
                Text(
                  existing == null ? 'Add Partner' : 'Edit Partner',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter name' : null,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Neha Sharma',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFDDE0E8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFDDE0E8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _skyBlue, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter email';
                    if (!v.contains('@')) return 'Enter valid email';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'name@company.com',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFDDE0E8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFDDE0E8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _skyBlue, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() != true) return;
                      Navigator.pop(ctx, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _skyBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      existing == null ? 'Add Partner' : 'Save Changes',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (saved == true && mounted) {
      setState(() {
        if (index != null) {
          _partners[index] = Partner(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
          );
        } else {
          _partners.add(
            Partner(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
            ),
          );
        }
      });
    }
    nameController.dispose();
    emailController.dispose();
  }

  void _deletePartner(int index) {
    setState(() => _partners.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Partner removed'),
        behavior: SnackBarBehavior.floating,
      ),
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

            // Step indicator — step 5 active, 1-4 done
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
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
                  _step('5', active: true),
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
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Partnership Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Add details of all partners in the firm.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF626A79),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () => _showPartnerSheet(),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text(
                              'Add',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _skyBlue,
                              side: const BorderSide(color: _skyBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Plain partners list — single border, no outer card
                    if (_partners.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDDE0E8)),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 40,
                              color: Color(0xFF9CA3AF),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No partners added yet',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF626A79),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap Add to add your first partner.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDDE0E8)),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < _partners.length; i++) ...[
                              if (i > 0)
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFDDE0E8),
                                ),
                              _partner(
                                partner: _partners[i],
                                onEdit: () => _showPartnerSheet(
                                  existing: _partners[i],
                                  index: i,
                                ),
                                onDelete: () => _deletePartner(i),
                              ),
                            ],
                          ],
                        ),
                      ),
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

  Widget _partner({
    required Partner partner,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          // Avatar — sky tint
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _skyLight,
            ),
            child: const Icon(Icons.person, size: 27, color: _skyBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  partner.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF626A79),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: _skyLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'PARTNER',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _skyBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: Color(0xFF626A79),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.delete_outline,
              size: 20,
              color: Color(0xFF626A79),
            ),
          ),
        ],
      ),
    );
  }
}
