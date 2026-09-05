import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'booking_confirmation_screen.dart';


class PeerBookingScreen extends StatefulWidget {
  const PeerBookingScreen({super.key});

  @override
  State<PeerBookingScreen> createState() => _PeerBookingScreenState();
}

class _PeerBookingScreenState extends State<PeerBookingScreen> {
  int _selectedDateIndex = 1; // 1 = Tue 21
  int _selectedSlotIndex = 1; // 1 = 11:30 AM

  final List<Map<String, String>> _dates = [
    {'day': 'Mon', 'num': '20'},
    {'day': 'Tue', 'num': '21'},
    {'day': 'Wed', 'num': '22'},
    {'day': 'Thu', 'num': '23'},
  ];

  final List<String> _slots = [
    '09:00 AM',
    '11:30 AM',
    '02:00 PM',
    '03:30 PM',
    '05:00 PM',
    '06:30 PM',
  ];

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
                  const SizedBox(width: 14),
                  const Text(
                    'Expert Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card 1: Expert details (David Chen)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          children: [
                            // Circular photo with check verified badge
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?img=11'),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0088CC),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Name
                            const Text(
                              'David Chen',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Title capsule
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4FB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Staff Engineer @ Meta',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0088CC),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Rating/Mocks info row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 18),
                                const SizedBox(width: 4),
                                const Text(
                                  '5.0',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(84 reviews)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Container(width: 1, height: 16, color: Colors.grey.shade300),
                                const SizedBox(width: 14),
                                Icon(Icons.check_circle_outline_rounded, color: Colors.grey.shade400, size: 14),
                                const SizedBox(width: 4),
                                const Text(
                                  '120+ Mocks Completed',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Skill chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const [
                                _SkillTag(label: 'System Design'),
                                _SkillTag(label: 'Java'),
                                _SkillTag(label: 'Scalability'),
                                _SkillTag(label: 'FAANG Prep'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 2: Select Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Row(
                            children: [
                              _buildCircleArrow(Icons.keyboard_arrow_left_rounded),
                              const SizedBox(width: 8),
                              _buildCircleArrow(Icons.keyboard_arrow_right_rounded),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Dates horizontal list
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_dates.length, (index) {
                          return Expanded(
                            child: _buildDateItem(
                              index: index,
                              day: _dates[index]['day']!,
                              num: _dates[index]['num']!,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // Section 3: Available Slots
                      const Text(
                        'Available Slots',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Slots Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.8,
                        ),
                        itemCount: _slots.length,
                        itemBuilder: (context, index) {
                          final selected = _selectedSlotIndex == index;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedSlotIndex = index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFF0088CC) : const Color(0xFFF0F9FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _slots[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: selected ? Colors.white : const Color(0xFF374151),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Section 4: About David Card
                      Container(
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
                            const Text(
                              'About David',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'With over 12 years in big tech, I specialize in helping senior engineers bridge the gap to Staff levels. I focus on distributed systems, architectural patterns, and interview strategy.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Session Details rows
                            _buildInfoRow('Session Length', '60 Mins'),
                            const SizedBox(height: 8),
                            _buildInfoRow('Rate', '\$150 / hr'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Section 5: ATS Resume Review promo card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.star_purple500_rounded, color: Color(0xFF0088CC), size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'PRO FEATURE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0088CC),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'ATS Resume Review',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add a detailed ATS optimization check for your resume for just \$25 extra.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Sticky Booking Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '\$150.00',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Confirm Booking button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingConfirmationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC),
                        elevation: 0,
                        minimumSize: const Size(180, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            'Confirm Booking',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                        ],
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

  Widget _buildCircleArrow(IconData icon) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.grey.shade600, size: 16),
    );
  }

  Widget _buildDateItem({
    required int index,
    required String day,
    required String num,
  }) {
    final selected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDateIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0088CC) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade200,
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white70 : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              num,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            if (selected) ...[
              const SizedBox(height: 4),
              const CircleAvatar(
                radius: 2,
                backgroundColor: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillTag extends StatelessWidget {
  final String label;
  const _SkillTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }
}
