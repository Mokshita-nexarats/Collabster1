import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/enums/app_enums.dart';
import '../../../shared/widgets/role_switcher_sheet.dart';
import '../../auth/view/sign_in_screen.dart';
import '../../../core/di/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final activeRole = session?.activeUserRole ?? UserRole.other;

    return Scaffold(
      appBar: AppBar(
        title: Text(activeRole.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch Tab',
            onPressed: () => RoleSwitcherSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  activeRole.icon,
                  size: 40,
                  color: const Color(0xFF5B21B6),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to ${activeRole.dashboardTitle}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You are viewing as ${activeRole.label}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => RoleSwitcherSheet.show(context),
                  icon: const Icon(Icons.swap_horiz, size: 20),
                  label: const Text('Switch Tab'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
