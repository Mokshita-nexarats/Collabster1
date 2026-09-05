import 'package:flutter/material.dart';

class StartupPublicProfileScreen extends StatelessWidget {
  const StartupPublicProfileScreen({super.key, required this.startupName});

  final String startupName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9FF),
        elevation: 0,
        title: const Text(
          'Public Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(Icons.business, size: 42, color: Color(0xFF0088CC)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        startupName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Seed Stage Startup | Public',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D6472),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _infoRow('Website', 'https://acme.ai'),
                    _infoRow('LinkedIn', 'linkedin.com/acme'),
                    _infoRow('Focus', 'AI, Product, Growth'),
                    _infoRow('Team', '4 members'),
                    const SizedBox(height: 16),
                    const Text(
                      'About',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A focused startup building practical tools for founders and teams. This profile is a preview of what investors and collaborators will see.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Startup Snapshot',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                    ),
                    const SizedBox(height: 14),
                    _metricRow('Profile completion', '65%'),
                    _metricRow('Public deck', 'Uploaded'),
                    _metricRow('Team invites', '2 sent'),
                    _metricRow('Funding stage', 'Seed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5D6472),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF12233D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5D6472),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12233D),
            ),
          ),
        ],
      ),
    );
  }
}
