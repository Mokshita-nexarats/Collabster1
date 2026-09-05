import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/career_providers.dart';
import 'application_success_screen.dart';


class ApplicationDetailsScreen extends StatefulWidget {
  final String jobType; // 'Job', 'Internship', 'Freelance'
  final String? jobTitle;
  final String? companyName;

  const ApplicationDetailsScreen({
    super.key,
    this.jobType = 'Job',
    this.jobTitle,
    this.companyName,
  });

  @override
  State<ApplicationDetailsScreen> createState() => _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  String _authorizedToWork = 'Yes'; // 'Yes' or 'No'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Apply for Position',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Nexus Systems',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Card 1: Mini Banner
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=600&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.2)],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Product Design Intern',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'San Francisco, CA • Remote',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 2: Personal Information
                      _buildSectionCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Information',
                        children: [
                          _buildTextField('Full Name', 'John Doe'),
                          const SizedBox(height: 12),
                          _buildTextField('Email Address', 'john@example.com'),
                          const SizedBox(height: 12),
                          _buildTextField('Phone Number', '+1 (555) 000-0000'),
                          const SizedBox(height: 12),
                          _buildTextField('Location', 'City, Country'),
                          const SizedBox(height: 12),
                          _buildTextField('Portfolio / LinkedIn Link', 'https://portfolio.com'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card 3: Preferences & Availability
                      _buildSectionCard(
                        icon: Icons.calendar_today_outlined,
                        title: 'Preferences & Availability',
                        children: [
                          const Text(
                            'Employment Type',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9FB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200, width: 1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Full-time',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.keyboard_arrow_down_rounded,
                                    color: Colors.grey.shade500),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField('Earliest Start Date', 'mm/dd/yyyy'),
                          const SizedBox(height: 12),
                          _buildTextField('Expected Salary (Monthly USD)', '\$ 5,000'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card 4: Work Experience
                      _buildSectionCard(
                        icon: Icons.work_outline_rounded,
                        title: 'Work Experience',
                        trailingText: '+ Add Experience',
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE8F4FB), width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.business_center_rounded,
                                          color: Color(0xFF0088CC), size: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Junior UX Designer • TechFlow',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Jan 2022 - Present',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Lead user research and interactive prototyping for the core dashboard redesign project.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4B5563),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Center(
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card 5: Education
                      _buildSectionCard(
                        icon: Icons.school_outlined,
                        title: 'Education',
                        trailingText: '+ Add School',
                        children: [
                          // Add degree dotted box
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                                width: 1.2,
                                style: BorderStyle.none, // Can use dotted painter but plain/dashed is fine
                              ),
                            ),
                            // Simple custom dashed look via CustomPaint or background
                            child: CustomPaint(
                              painter: _DashedBorderPainter(color: const Color(0xFFCBD5E1)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_circle_outline_rounded, color: Colors.grey, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Degree',
                                    style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Education item
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'B.S. Interaction Design',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF006699),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'University of California, Berkeley',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0088CC),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Class of 2021',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.edit_outlined, color: Color(0xFF0088CC), size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Card 6: Documents & Screening
                      _buildSectionCard(
                        icon: Icons.description_outlined,
                        title: 'Documents & Screening',
                        children: [
                          const Text(
                            'RESUME (PDF)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDottedUploadBox(
                            icon: Icons.cloud_upload_outlined,
                            text: 'Click to upload or drag & drop',
                            subtext: 'PDF, DOCX formats\nMaximum file size 5MB',
                          ),
                          const SizedBox(height: 14),

                          const Text(
                            'COVER LETTER (OPTIONAL)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDottedUploadBox(
                            icon: Icons.insert_drive_file_outlined,
                            text: 'Click to upload or drag & drop',
                            subtext: 'PDF, DOCX formats\nMaximum file size 10MB',
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Are you legally authorized to work in the United States?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildRadioButton('Yes'),
                              const SizedBox(width: 20),
                              _buildRadioButton('No'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Professional References',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9FB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200, width: 1.2),
                            ),
                            child: const TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'List name, contact, and relationship...',
                                hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE8F4FB), width: 1.5),
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Save for Later',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0088CC)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          try {
                            final container = ProviderScope.containerOf(context, listen: false);
                            container.read(careerStateProvider.notifier).addApplication(
                              title: widget.jobTitle ?? (widget.jobType == 'Internship' ? 'UI/UX Design Intern' : (widget.jobType == 'Freelance' ? 'Full-Stack Developer (Freelance)' : 'Senior Product Designer')),
                              company: widget.companyName ?? (widget.jobType == 'Internship' ? 'Canva Design Studio' : (widget.jobType == 'Freelance' ? 'TechFlow Global' : 'Nexus Systems')),
                              logoUrl: widget.jobType == 'Internship' ? 'https://img.icons8.com/color/48/canva.png' : (widget.jobType == 'Freelance' ? 'https://img.icons8.com/color/48/code.png' : 'https://img.icons8.com/color/48/adobe-illustrator.png'),
                              type: widget.jobType,
                            );
                          } catch (_) {}
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ApplicationSuccessScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          elevation: 0,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Submit Application',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.send_rounded, color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    String? trailingText,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F9FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF0088CC), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              if (trailingText != null) ...[
                const Spacer(),
                Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0088CC),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200, width: 1.2),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDottedUploadBox({
    required IconData icon,
    required String text,
    required String subtext,
  }) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(color: const Color(0xFF0088CC)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF0088CC), size: 24),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtext,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label) {
    final selected = _authorizedToWork == label;
    return GestureDetector(
      onTap: () => setState(() => _authorizedToWork = label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? const Color(0xFF0088CC) : Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0088CC),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12)));

    // Drawing dashed line path
    final dashWidth = 5.0;
    final dashSpace = 4.0;
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
