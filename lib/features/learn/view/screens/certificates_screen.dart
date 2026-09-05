import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  final List<_Cert> _certs = const [
    _Cert(title: 'Flutter Developer', issuer: 'Udemy', date: 'Aug 2026', color: Color(0xFF7C3AED), icon: Icons.flutter_dash_rounded),
    _Cert(title: 'Python for Data Science', issuer: 'Coursera', date: 'Jul 2026', color: Color(0xFF10B981), icon: Icons.analytics_rounded),
    _Cert(title: 'UI/UX Design Fundamentals', issuer: 'Google', date: 'Jun 2026', color: Color(0xFF6D28D9), icon: Icons.design_services_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Text('Certificates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text('${_certs.length} earned', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _certs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (ctx, i) => _buildCertCard(ctx, _certs[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertCard(BuildContext context, _Cert cert) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cert.color.withValues(alpha: 0.2), width: 1.2),
        boxShadow: [BoxShadow(color: cert.color.withValues(alpha: 0.08), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: cert.color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(cert.icon, color: cert.color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(cert.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 4),
          Text('Issued by ${cert.issuer}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          Text('Earned ${cert.date}', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => HapticFeedback.lightImpact(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: cert.color, borderRadius: BorderRadius.circular(12)),
                    child: const Text('View Certificate', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: cert.color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.share_rounded, color: cert.color, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cert {
  final String title, issuer, date;
  final Color color;
  final IconData icon;
  const _Cert({required this.title, required this.issuer, required this.date, required this.color, required this.icon});
}
