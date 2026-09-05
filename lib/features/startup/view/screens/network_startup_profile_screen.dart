import 'package:flutter/material.dart';
import '../../model/startup_models.dart';
import 'messages_inbox_screen.dart';

class NetworkStartupProfileScreen extends StatefulWidget {
  const NetworkStartupProfileScreen({
    super.key,
    required this.startup,
    required this.accent,
    this.isConnected = false,
    required this.onConnect,
  });

  final SuggestedStartup startup;
  final Color accent;
  final bool isConnected;
  final VoidCallback onConnect;

  @override
  State<NetworkStartupProfileScreen> createState() =>
      _NetworkStartupProfileScreenState();
}

class _NetworkStartupProfileScreenState
    extends State<NetworkStartupProfileScreen> {
  late bool _connected;

  @override
  void initState() {
    super.initState();
    _connected = widget.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.startup;
    final accent = widget.accent;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: accent,
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
                    colors: [accent, accent.withValues(alpha: 0.75)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(Icons.rocket_launch_rounded,
                          color: Colors.white, size: 38),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${s.industry} • ${s.location}',
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
                  // Stats
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
                        _stat(s.stage, 'Stage', accent),
                        _divider(),
                        _stat('${s.teamMembers}', 'Team', const Color(0xFF6B7280)),
                        _divider(),
                        _stat('12', 'Partners', const Color(0xFF6B7280)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Action buttons
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
                                    ? 'Connection request sent to ${s.name}!'
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
                                  : Icons.link_rounded,
                              size: 18),
                          label: Text(
                            _connected ? 'Pending' : 'Connect',
                            style:
                                const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _connected ? const Color(0xFFF3F4F6) : accent,
                            foregroundColor:
                                _connected ? const Color(0xFF6B7280) : Colors.white,
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
                          icon: const Icon(Icons.message_outlined, size: 18),
                          label: const Text('Message',
                              style: TextStyle(fontWeight: FontWeight.w800)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accent,
                            side: BorderSide(
                                color: accent.withValues(alpha: 0.4)),
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Tags
                  _infoCard(
                    title: 'Tags',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: s.tags
                          .map((tag) => _chip(tag, accent))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // About card
                  _infoCard(
                    title: 'About ${s.name}',
                    child: Text(
                      '${s.name} is an innovative ${s.industry} startup based in ${s.location}. '
                      'Currently at the ${s.stage} stage with ${s.teamMembers} team members, '
                      'we are building cutting-edge solutions to transform the industry.',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                          height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Highlights
                  _infoCard(
                    title: 'Highlights',
                    child: Column(
                      children: [
                        _highlight(Icons.people_rounded,
                            '${s.teamMembers} Team Members', accent),
                        const SizedBox(height: 10),
                        _highlight(Icons.location_on_rounded,
                            s.location, accent),
                        const SizedBox(height: 10),
                        _highlight(
                            Icons.business_rounded, s.industry, accent),
                        const SizedBox(height: 10),
                        _highlight(Icons.show_chart_rounded,
                            '${s.stage} Stage', accent),
                      ],
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
                fontSize: 18, fontWeight: FontWeight.w900, color: color)),
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

  Widget _chip(String label, Color color) {
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

  Widget _highlight(IconData icon, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151))),
      ],
    );
  }
}
