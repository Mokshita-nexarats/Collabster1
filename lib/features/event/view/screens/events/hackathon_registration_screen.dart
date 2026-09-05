import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/providers.dart';

// ─── Color Tokens ───────────────────────────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _accentBg = Color(0xFFEFF6FF);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);
const _inputBg = Color(0xFFF1F5F9);
const _green = Color(0xFF22C55E);
const _orange = Color(0xFFF59E0B);

class HackathonRegistrationScreen extends ConsumerStatefulWidget {
  final String hackathonTitle;
  const HackathonRegistrationScreen({super.key, this.hackathonTitle = 'Global Fintech Hackathon'});

  @override
  ConsumerState<HackathonRegistrationScreen> createState() => _HackathonRegistrationScreenState();
}

class _HackathonRegistrationScreenState extends ConsumerState<HackathonRegistrationScreen> {
  int _selectedGender = 0; // 0=Male, 1=Female, 2=Others
  final List<String> _skills = ['Flutter', 'React'];
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController(text: 'Alex');
  final TextEditingController _lastNameController = TextEditingController(text: 'Chen');
  final TextEditingController _instituteController = TextEditingController(text: 'Stanford University');
  final TextEditingController _emailController = TextEditingController(text: 'alex.chen@university.edu');
  String _selectedCourse = 'B.Tech CS';
  String _selectedYear = '2024';

  final List<Map<String, dynamic>> _teammates = [
    {'name': 'Alex Rivera', 'phone': '+91 87369 63456', 'isLeader': true, 'status': 'verified', 'initial': 'A', 'color': Color(0xFF229ED9)},
    {'name': 'Sarah Jenkins', 'phone': '+91 87369 63456', 'isLeader': false, 'status': 'pending', 'initial': 'S', 'color': Color(0xFF22C55E)},
  ];

  Future<void> _addSkill() async {
    final controller = TextEditingController();
    final skill = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Skill'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Firebase, Python'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (skill != null && skill.isNotEmpty && mounted) {
      setState(() => _skills.add(skill));
    }
  }

  Future<void> _addTeammate() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final added = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Team Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(hintText: 'Full name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'Phone number'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (added == true && nameCtrl.text.trim().isNotEmpty && mounted) {
      final name = nameCtrl.text.trim();
      setState(() {
        _teammates.add({
          'name': name,
          'phone': phoneCtrl.text.trim().isEmpty ? '+91 ••••• •••••' : phoneCtrl.text.trim(),
          'isLeader': false,
          'status': 'pending',
          'initial': name[0].toUpperCase(),
          'color': const Color(0xFF229ED9),
        });
      });
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _instituteController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildHackathonBadge(),
                    const SizedBox(height: 14),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildTeamNameField(),
                    const SizedBox(height: 6),
                    _buildInfoNote(Icons.info_outline_rounded, 'Team must have 2 to 5 members max'),
                    const SizedBox(height: 22),
                    _buildSectionLabel('Add Member *'),
                    const SizedBox(height: 14),
                    _buildNameRow(),
                    const SizedBox(height: 12),
                    _buildGenderSelector(),
                    const SizedBox(height: 12),
                    _buildLabeledInput('Institute / University Name *', _instituteController, 'eg. Stanford University'),
                    const SizedBox(height: 12),
                    _buildCourseYearRow(),
                    const SizedBox(height: 12),
                    _buildLabeledInput('Email Address *', _emailController, 'alex.chen@university.edu'),
                    const SizedBox(height: 12),
                    _buildSkillsField(),
                    const SizedBox(height: 12),
                    _buildResumeUpload(),
                    const SizedBox(height: 16),
                    _buildAddMemberButton(),
                    const SizedBox(height: 14),
                    _buildImportantNotice(),
                    const SizedBox(height: 22),
                    _buildMyTeamSection(),
                    const SizedBox(height: 22),
                    _buildStatusLegend(),
                    const SizedBox(height: 20),
                    _buildUpdateDetailsButton(),
                    const SizedBox(height: 14),
                    _buildTermsText(),
                    const SizedBox(height: 12),
                    _buildSubmitButton(),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar ─────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _surface,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 18),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Team registration',
                  style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _surface,
              shape: BoxShape.circle,
              border: Border.all(color: _borderColor),
            ),
            child: const Icon(Icons.diamond_outlined, color: _accentLight, size: 18),
          ),
        ],
      ),
    );
  }

  // ─── Hackathon Badge ─────────────────────────────────────────
  Widget _buildHackathonBadge() {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_accentLight, _accent]),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.code_rounded, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _accentBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _accent.withOpacity(0.4)),
          ),
          child: Text(
            widget.hackathonTitle.toUpperCase(),
            style: const TextStyle(color: _accentLight, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ),
      ],
    );
  }

  // ─── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Register Your Participation',
            style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2)),
        SizedBox(height: 6),
        Text('Empowering the next generation of finance disruptors.',
            style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.4)),
      ],
    );
  }

  // ─── Team Name ───────────────────────────────────────────────
  Widget _buildTeamNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Team Name *', style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor),
          ),
          child: TextField(
            controller: _teamNameController,
            style: const TextStyle(color: _textPrimary, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Enter team name',
              hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Info Note ───────────────────────────────────────────────
  Widget _buildInfoNote(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: _accentLight, size: 14),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: _accentLight, fontSize: 11)),
      ],
    );
  }

  // ─── Section Label ───────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(label, style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w800));
  }

  // ─── Name Row ────────────────────────────────────────────────
  Widget _buildNameRow() {
    return Row(
      children: [
        Expanded(child: _buildLabeledInput('First Name *', _firstNameController, 'Alex')),
        const SizedBox(width: 10),
        Expanded(child: _buildLabeledInput('Last Name *', _lastNameController, 'Chen')),
      ],
    );
  }

  // ─── Labeled Input ───────────────────────────────────────────
  Widget _buildLabeledInput(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: _textPrimary, fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: _textSecondary, fontSize: 12),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Gender Selector ─────────────────────────────────────────
  Widget _buildGenderSelector() {
    final genders = ['Male', 'Female', 'Others'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender *', style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: List.generate(genders.length, (i) {
            final isSelected = _selectedGender == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedGender = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? _accent : _inputBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isSelected ? _accent : _borderColor),
                ),
                child: Text(
                  genders[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ─── Course + Year Row ───────────────────────────────────────
  Widget _buildCourseYearRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Course / Degree *', style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCourse,
                    dropdownColor: _card,
                    style: const TextStyle(color: _textPrimary, fontSize: 12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _textSecondary, size: 18),
                    items: ['B.Tech CS', 'B.Tech IT', 'MCA', 'MBA', 'BBA']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCourse = v!),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Graduation Year *', style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedYear,
                    dropdownColor: _card,
                    style: const TextStyle(color: _textPrimary, fontSize: 12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _textSecondary, size: 18),
                    items: ['2024', '2025', '2026', '2027', '2028']
                        .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedYear = v!),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Skills Field ────────────────────────────────────────────
  Widget _buildSkillsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Skills', style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._skills.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _accentBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _accent.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s, style: const TextStyle(color: _accentLight, fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => setState(() => _skills.remove(s)),
                    child: const Icon(Icons.close, color: _accentLight, size: 12),
                  ),
                ],
              ),
            )),
            GestureDetector(
              onTap: _addSkill,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _borderColor),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: _textSecondary, size: 14),
                    SizedBox(width: 4),
                    Text('Add Skill', style: TextStyle(color: _textSecondary, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Resume Upload ───────────────────────────────────────────
  Widget _buildResumeUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resume Upload *', style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _accentBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_upload_outlined, color: _accentLight, size: 22),
              ),
              const SizedBox(height: 8),
              const Text('Click to upload or drag & drop',
                  style: TextStyle(color: _textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              const Text('PDF, DOCX (Max 5MB)',
                  style: TextStyle(color: Color(0xFF666666), fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Add Member Button ───────────────────────────────────────
  Widget _buildAddMemberButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _addTeammate,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Add Member',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  // ─── Important Notice ────────────────────────────────────────
  Widget _buildImportantNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _accentBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: _accentLight, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Important: All added team members must belong to the same institute as the Team Leader.',
              style: TextStyle(color: _textSecondary, fontSize: 11, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ─── My Team Section ─────────────────────────────────────────
  Widget _buildMyTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('My Team', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.people_rounded, color: _textSecondary, size: 14),
            const SizedBox(width: 5),
            Text(
              'Teammates (${_teammates.length}/3)',
              style: const TextStyle(color: _textSecondary, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _teammates.length / 3,
            backgroundColor: _borderColor,
            color: _accent,
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF3D1515),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B6B), size: 13),
              SizedBox(width: 5),
              Text('Your team is incomplete',
                  style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Teammate list
        ..._teammates.map((t) => _buildTeammateCard(t)),
        const SizedBox(height: 12),
        // Add Team Member button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addTeammate,
            icon: const Icon(Icons.person_add_alt_1_rounded, color: _accentLight, size: 16),
            label: const Text('Add Team Member',
                style: TextStyle(color: _accentLight, fontWeight: FontWeight.w600, fontSize: 13)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _accent, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeammateCard(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: (t['color'] as Color).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(t['initial'] as String,
                  style: TextStyle(color: t['color'] as Color, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(t['name'] as String,
                        style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    if (t['isLeader'] == true) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _accentBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('TEAM LEADER',
                            style: TextStyle(color: _accentLight, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(t['phone'] as String,
                    style: const TextStyle(color: _textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: _textSecondary, size: 18),
        ],
      ),
    );
  }

  // ─── Status Legend ───────────────────────────────────────────
  Widget _buildStatusLegend() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Status Legend', style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _legendRow(_green, 'Verified Teammate'),
          const SizedBox(height: 6),
          _legendRow(_orange, 'Confirmation Pending'),
          const SizedBox(height: 6),
          _legendRow(_textSecondary, 'Not Added Yet'),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: _textSecondary, fontSize: 12)),
      ],
    );
  }

  // ─── Update Details ──────────────────────────────────────────
  Widget _buildUpdateDetailsButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Details updated successfully ✓'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _accent, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Update Details',
            style: TextStyle(color: _accentLight, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  // ─── Terms Text ──────────────────────────────────────────────
  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(color: _textSecondary, fontSize: 11, height: 1.4),
        children: [
          TextSpan(text: 'I agree to the '),
          TextSpan(text: 'Terms & Conditions', style: TextStyle(color: _accentLight, fontWeight: FontWeight.w600)),
          TextSpan(text: ' and consent to the processing of my data for hackathon purposes.'),
        ],
      ),
    );
  }

  // ─── Submit Button ───────────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final eventId = 'hackathon-${widget.hackathonTitle}';
          final notifier = ref.read(eventViewModelProvider.notifier);
          final alreadyRegistered = notifier.isRegistered(eventId);
          if (!alreadyRegistered) {
            notifier.rsvpEvent(eventId);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration submitted successfully! 🎉'),
              backgroundColor: Color(0xFF229ED9),
            ),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text('Submit Registration',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
