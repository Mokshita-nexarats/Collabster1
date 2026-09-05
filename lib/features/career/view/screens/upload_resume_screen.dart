import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/career_providers.dart';
import 'check_resume_score_screen.dart';
import 'resume_screen.dart';

class UploadResumeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const UploadResumeScreen({super.key, this.onBack});

  @override
  ConsumerState<UploadResumeScreen> createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends ConsumerState<UploadResumeScreen> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _uploadSuccess = false;
  String _selectedFileName = 'Alex_Senior_Frontend_Resume.pdf';
  String _selectedFileSize = '2.4 MB';

  void _simulateUpload(String fileName, String fileSize, int atsScore, List<String> skills) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.1;
      _uploadSuccess = false;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() {
        _uploadProgress = i / 10;
      });
    }

    if (!mounted) return;
    ref.read(careerStateProvider.notifier).uploadResume(
      fileName: fileName,
      fileSize: fileSize,
      atsScore: atsScore,
      newSkills: skills,
    );

    setState(() {
      _isUploading = false;
      _uploadSuccess = true;
      _selectedFileName = fileName;
      _selectedFileSize = fileSize;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully uploaded "$fileName"! Reflecting in My Resume...'),
        backgroundColor: const Color(0xFF0088CC),
        action: SnackBarAction(
          label: 'OPEN MY RESUME',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResumeScreen()),
            );
          },
        ),
      ),
    );
  }

  void _openFileManagerPicker() {
    final sampleFiles = [
      {'name': 'Alex_Senior_Frontend_Resume.pdf', 'size': '2.4 MB', 'score': 94, 'skills': ['React', 'TypeScript', 'Flutter', 'Next.js', 'Tailwind CSS', 'System Design']},
      {'name': 'Alex_FullStack_Engineer_CV.pdf', 'size': '1.9 MB', 'score': 91, 'skills': ['Node.js', 'Python', 'GraphQL', 'Docker', 'AWS', 'PostgreSQL']},
      {'name': 'Alex_UIUX_Product_Designer.pdf', 'size': '3.1 MB', 'score': 88, 'skills': ['Figma', 'UI/UX Design', 'User Research', 'Design Systems', 'Prototyping']},
      {'name': 'Alex_Tech_Lead_Resume_2026.pdf', 'size': '2.8 MB', 'score': 96, 'skills': ['Architecture', 'Agile Leadership', 'CI/CD', 'Kubernetes', 'Go']},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.folder_open_rounded, color: Color(0xFF0088CC)),
                  const SizedBox(width: 8),
                  const Text(
                    'Device File Manager',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Text(
                'Select a resume document to upload and parse:',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              ...sampleFiles.map((file) {
                final name = file['name'] as String;
                final size = file['size'] as String;
                final score = file['score'] as int;
                final skills = file['skills'] as List<String>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF0088CC), size: 22),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    subtitle: Text('$size • PDF Document', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _simulateUpload(name, size, score, skills);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Select File', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSkillDialog() {
    final controller = TextEditingController();
    final suggestions = ['Flutter', 'React Native', 'Swift', 'Python', 'GraphQL', 'Docker', 'AWS'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.add_circle_outline_rounded, color: Color(0xFF0088CC)),
            SizedBox(width: 8),
            Text('Add Skill to Resume', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter a new skill to add to your active resume:', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'e.g. Flutter, GraphQL, Node.js...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0088CC), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text('Quick Suggestions:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: suggestions.map((s) => ActionChip(
                label: Text(s, style: const TextStyle(fontSize: 11, color: Color(0xFF0088CC))),
                backgroundColor: const Color(0xFFE8F4FB),
                onPressed: () => controller.text = s,
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088CC),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(careerStateProvider.notifier).addSkill(controller.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added "${controller.text.trim()}" to resume!')),
                );
              }
            },
            child: const Text('Add Skill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final careerState = ref.watch(careerStateProvider);
    final resumeState = careerState.resumeState;

    final displayFileName = _uploadSuccess ? _selectedFileName : resumeState.fileName;
    final displayFileSize = _uploadSuccess ? _selectedFileSize : resumeState.fileSize;
    final atsScore = resumeState.atsScore;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0088CC)),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Upload Resume',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Gradient Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0088CC), Color(0xFF229ED9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0088CC).withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.cloud_upload_rounded, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Upload & AI Parse Resume',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select a PDF or Word document from file manager to analyze your ATS score and update your My Resume profile automatically.',
                      style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Upload Dropzone Box (Triggers File Manager Picker)
              GestureDetector(
                onTap: _isUploading ? null : _openFileManagerPicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF0088CC),
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F4FB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.folder_special_rounded,
                          color: Color(0xFF0088CC),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Tap to Open File Manager & Select Resume',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Supports PDF, DOCX, TXT (Max size 10MB)',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isUploading ? null : _openFileManagerPicker,
                        icon: const Icon(Icons.folder_open_rounded, size: 18),
                        label: const Text('Open File Manager'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Uploading Progress Indicator
              if (_isUploading) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8F4FB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sync_rounded, color: Color(0xFF0088CC), size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Parsing & Uploading to My Resume...',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
                          ),
                          const Spacer(),
                          Text(
                            '${(_uploadProgress * 100).toInt()}%',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: const Color(0xFFE8F4FB),
                        color: const Color(0xFF0088CC),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 4. Active Uploaded Resume Document Card
              const Text(
                'Active Uploaded Resume',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF0088CC), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayFileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$displayFileSize • Uploaded ${resumeState.uploadDate}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6FBF3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Viewing preview for "$displayFileName"...')),
                              );
                            },
                            icon: const Icon(Icons.picture_as_pdf_outlined, size: 16, color: Color(0xFF0088CC)),
                            label: const Text(
                              'View Document',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE8F4FB)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _openFileManagerPicker,
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text(
                              'Re-upload',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0088CC),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. ATS Score Check Below Upload Section
              const Text(
                'ATS Score Check for Uploaded Resume',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8F4FB), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0088CC).withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F4FB),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$atsScore%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0088CC),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                atsScore >= 90 ? 'Excellent ATS Match Score' : 'Good ATS Match Score',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'High probability of passing automated screening for tech roles.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 14),

                    // Metrics Grid
                    Row(
                      children: [
                        Expanded(child: _buildAtsMetric('Keyword Match', '94%')),
                        Expanded(child: _buildAtsMetric('Formatting', '98%')),
                        Expanded(child: _buildAtsMetric('Impact Score', '86%')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CheckResumeScoreScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('View Full ATS Score Breakdown →', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 6. Parsed Skills Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Extracted Skills',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showAddSkillDialog,
                    child: const Text(
                      '+ Add Skill',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0088CC),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: resumeState.skills.map((skill) {
                    return Chip(
                      label: Text(
                        skill,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0088CC)),
                      ),
                      backgroundColor: const Color(0xFFE8F4FB),
                      side: const BorderSide(color: Color(0xFFE8F4FB)),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // 7. Primary Action Button (Navigates to My Resume)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ResumeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088CC),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Go to My Resume (Reflect Changes) →',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAtsMetric(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
