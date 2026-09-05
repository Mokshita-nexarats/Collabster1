import 'package:flutter/material.dart';
import 'messages_inbox_screen.dart';

class NetworkPersonProfileScreen extends StatefulWidget {
  const NetworkPersonProfileScreen({
    super.key,
    required this.name,
    required this.role,
    required this.company,
    required this.initials,
    required this.color,
    required this.mutualConnections,
    this.isConnected = false,
    required this.onConnect,
  });

  final String name;
  final String role;
  final String company;
  final String initials;
  final Color color;
  final int mutualConnections;
  final bool isConnected;
  final VoidCallback onConnect;

  @override
  State<NetworkPersonProfileScreen> createState() =>
      _NetworkPersonProfileScreenState();
}

class _NetworkPersonProfileScreenState
    extends State<NetworkPersonProfileScreen> {
  late bool _connected;

  @override
  void initState() {
    super.initState();
    _connected = widget.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          // ── Header / Avatar ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: widget.color,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.color,
                      widget.color.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      child: Text(
                        widget.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.role} at ${widget.company}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats row
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _stat('${widget.mutualConnections}', 'Mutual', widget.color),
                        _divider(),
                        _stat('142', 'Connections', const Color(0xFF6B7280)),
                        _divider(),
                        _stat('4', 'Posts', const Color(0xFF6B7280)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Connect / Message buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _connected = !_connected);
                            widget.onConnect();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_connected
                                    ? 'Connection request sent to ${widget.name}!'
                                    : 'Connection cancelled'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
                          icon: Icon(
                              _connected
                                  ? Icons.check_rounded
                                  : Icons.person_add_rounded,
                              size: 18),
                          label: Text(
                            _connected ? 'Pending' : 'Connect',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _connected ? const Color(0xFFF3F4F6) : widget.color,
                            foregroundColor: _connected
                                ? const Color(0xFF6B7280)
                                : Colors.white,
                            minimumSize: const Size.fromHeight(46),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                           onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessagesInboxScreen(
                                  startupName: 'Collabster',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_outline_rounded,
                              size: 18),
                          label: const Text('Message',
                              style: TextStyle(fontWeight: FontWeight.w800)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: widget.color,
                            side: BorderSide(
                                color: widget.color.withValues(alpha: 0.4)),
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // About card
                  _infoCard(
                    title: 'About',
                    child: Text(
                      '${widget.name} is a ${widget.role} at ${widget.company}. '
                      'Passionate about building impactful products and connecting with like-minded professionals across the startup ecosystem.',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                          height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Experience card
                  _infoCard(
                    title: 'Experience',
                    child: Column(
                      children: [
                        _expItem(widget.role, widget.company,
                            '2022 – Present', widget.color),
                        const Divider(height: 20),
                        _expItem('Product Lead', 'TechStartup Inc.',
                            '2019 – 2022', const Color(0xFF6B7280)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Skills card
                  _infoCard(
                    title: 'Skills',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Product Strategy',
                        'Team Leadership',
                        'B2B SaaS',
                        'Growth Hacking',
                        'Fundraising',
                      ]
                          .map((s) => _skillChip(s, widget.color))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String val, String label, Color color) {
    return Column(
      children: [
        Text(val,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 28, color: const Color(0xFFE5E7EB));

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D))),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _expItem(
      String role, String company, String period, Color color) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.work_outline_rounded, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF12233D))),
              Text(company,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
        ),
        Text(period,
            style:
                const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
      ],
    );
  }

  Widget _skillChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w700)),
    );
  }
}
