import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../shared/utils/app_snackbar.dart';
import '../../model/startup_models.dart';
import 'startup_dashboard_screen.dart';

class JoinStartupStatusScreen extends ConsumerWidget {
  const JoinStartupStatusScreen({super.key, required this.startup});

  final SuggestedStartup startup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0088CC)),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    size: 44,
                    color: Color(0xFF0088CC),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Verification in Progress',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 14),
              const SizedBox(
                height: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                  child: LinearProgressIndicator(
                    value: 0.82,
                    backgroundColor: Color(0xFFE9DCF9),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF0088CC),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _infoCard(
                icon: Icons.check_circle_outline,
                title: 'Submitted Successfully',
                description:
                    'Your application has been received and is currently in the priority queue.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Application Timeline',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: Color(0xFF8C8FA0),
                ),
              ),
              const SizedBox(height: 12),
              _timelineItem(
                title: 'Documents Uploaded',
                subtitle: 'Oct 24, 10:45 AM',
                completed: true,
              ),
              _timelineItem(
                title: 'Identity Verification',
                subtitle: 'Oct 24, 11:02 AM',
                completed: true,
              ),
              _timelineItem(
                title: 'Admin Review',
                subtitle: 'Estimated: 24-48 Hours',
                completed: false,
                active: true,
              ),
              _timelineItem(
                title: 'Approval',
                subtitle: 'Pending',
                completed: false,
              ),
              const SizedBox(height: 16),
              _infoCard(
                icon: Icons.info_outline,
                title: 'Our verification team is reviewing your documents.',
                description:
                    'You will receive a notification once your verification is approved.',
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      _showSnack(context, 'Verification is being tracked'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    elevation: 0,
                    backgroundColor: const Color(0xFF0088CC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Track Verification',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final currentSession = ref.read(authViewModelProvider).session;
                    final previousStartupName = currentSession?.startupName;

                    // Build a complete snapshot of the joined startup's data
                    final joinedData = <String, dynamic>{
                      'startupName': startup.name,
                      'startupIndustry': startup.industry,
                      'startupStage': startup.stage,
                      'startupTagline': 'Member of ${startup.name}',
                      'startupCity': startup.location,
                    };

                    // Also snapshot the CURRENT (own) startup data before switching,
                    // so it can be restored when the user switches back.
                    final ownData = currentSession?.originalStartupData ??
                        <String, dynamic>{
                          'startupName': previousStartupName ?? '',
                          'startupIndustry': currentSession?.startupIndustry ?? '',
                          'startupStage': currentSession?.startupStage ?? '',
                          'startupTagline': currentSession?.startupTagline ?? '',
                          'startupCountry': currentSession?.startupCountry ?? '',
                          'startupCity': currentSession?.startupCity ?? '',
                          'startupDescription': currentSession?.startupDescription ?? '',
                          'startupProblem': currentSession?.startupProblem ?? '',
                          'startupSolution': currentSession?.startupSolution ?? '',
                          'startupMission': currentSession?.startupMission ?? '',
                          'startupVision': currentSession?.startupVision ?? '',
                          'startupWebsite': currentSession?.startupWebsite ?? '',
                          'startupIncorporationDate': currentSession?.startupIncorporationDate ?? '',
                          'startupFounderName': currentSession?.startupFounderName ?? '',
                          'startupFounderDesignation': currentSession?.startupFounderDesignation ?? '',
                          'startupFounderEmail': currentSession?.startupFounderEmail ?? '',
                          'startupFounderPhone': currentSession?.startupFounderPhone ?? '',
                          'startupFounderLinkedin': currentSession?.startupFounderLinkedin ?? '',
                          'startupFounderBio': currentSession?.startupFounderBio ?? '',
                          'startupSocialWebsite': currentSession?.startupSocialWebsite ?? '',
                          'startupSocialLinkedin': currentSession?.startupSocialLinkedin ?? '',
                          'startupSocialProductHunt': currentSession?.startupSocialProductHunt ?? '',
                          'startupUseOfFunds': currentSession?.startupUseOfFunds ?? '',
                          'startupTeamSize': currentSession?.startupTeamSize ?? '',
                          'startupFundingStage': currentSession?.startupFundingStage ?? '',
                          'startupCurrentlyRaising': currentSession?.startupCurrentlyRaising ?? false,
                          'startupVisibility': currentSession?.startupVisibility ?? '',
                        };

                    await ref.read(authViewModelProvider.notifier).updateStartupData(
                      startupName: startup.name,
                      industry: startup.industry,
                      stage: startup.stage,
                      tagline: 'Member of ${startup.name}',
                      city: startup.location,
                      // Keep own startup name & data for "Switch back" button
                      originalStartupName: previousStartupName,
                      originalStartupData: ownData,
                      // Store joined startup data so it can be restored
                      joinedStartupName: startup.name,
                      joinedStartupData: joinedData,
                    );
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StartupDashboardScreen(startupName: startup.name),
                      ),
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: const Color(0xFF0088CC),
                    side: const BorderSide(color: Color(0xFF0088CC)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0088CC), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required String title,
    required String subtitle,
    required bool completed,
    bool active = false,
  }) {
    final color = completed || active
        ? const Color(0xFF0088CC)
        : const Color(0xFFD1CFE0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(
                  completed
                      ? Icons.check
                      : (active
                            ? Icons.radio_button_checked
                            : Icons.hourglass_empty),
                  size: 14,
                  color: Colors.white,
                ),
              ),
              if (title != 'Approval')
                Container(width: 2, height: 28, color: const Color(0xFFD9D3E8)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: completed || active
                          ? const Color(0xFF12233D)
                          : const Color(0xFF9CA0AD),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: completed || active
                          ? const Color(0xFF5D6472)
                          : const Color(0xFFB0B2C0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    AppSnackBar.showInfo(context, message);
  }
}
