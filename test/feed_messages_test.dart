import 'package:collabsphere/core/di/providers.dart';
import 'package:collabsphere/features/auth/model/auth_session.dart';
import 'package:collabsphere/features/auth/repository/auth_repository_impl.dart';
import 'package:collabsphere/features/auth/viewmodel/auth_state.dart';
import 'package:collabsphere/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:collabsphere/features/home/view/collabster_home/feed_messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _base = AuthSession(
  fullName: 'Tester',
  email: 't@t.com',
  password: 'x',
  phone: '1',
  role: 'founder',
  onboardingComplete: true,
);

class _SeedAuth extends AuthViewModel {
  _SeedAuth(AuthState seed) : super(AuthRepositoryImpl()) {
    state = seed;
  }
}

void main() {
  test('workspaces list idea + created + joined, deduped', () {
    final session = AuthSession(
      fullName: 'Tester',
      email: 't@t.com',
      password: 'x',
      phone: '1',
      role: 'founder',
      onboardingComplete: true,
      originalStartupName: 'Acme',
      joinedStartupName: 'Beta',
      ideaPhaseProfiles: const [
        {'ideaName': 'Idea One'},
        {'ideaName': 'Acme'}, // dup of created → dropped
        {'ideaName': ''}, // blank → dropped
      ],
    );
    final spaces = startupWorkspacesFor(session);
    expect(
      spaces.map((w) => (w.name, w.phase)).toList(),
      [
        ('Acme', 'Created'),
        ('Beta', 'Joined'),
        ('Idea One', 'Idea phase'),
      ],
    );
  });

  test('no session or no startups means no workspaces', () {
    expect(startupWorkspacesFor(null), isEmpty);
    expect(startupWorkspacesFor(_base), isEmpty);
  });

  testWidgets('chips never overflow on narrow phones', (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: FeedMessagesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Startup'), findsOneWidget);
    expect(find.text('Investor'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
  });

  testWidgets('chip taps switch message lists', (tester) async {    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: FeedMessagesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Null session → Startup tab shows empty-workspace state, no popup.
    await tester.tap(find.text('Startup'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No startup yet'), findsOneWidget);

    await tester.tap(find.text('Investor'));
    await tester.pumpAndSettle();
    expect(find.text('Nova Robotics'), findsOneWidget);

    await tester.tap(find.text('Community'));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('real session: chips match owned roles, picker lists phases',
      (tester) async {
    const session = AuthSession(
      fullName: 'Founder',
      email: 'f@f.com',
      password: 'x',
      phone: '1',
      role: 'founder',
      onboardingComplete: true,
      activeRole: 'founder',
      roles: ['founder', 'investor'],
      originalStartupName: 'Acme',
      ideaPhaseProfiles: [
        {'id': 'i1', 'ideaName': 'Idea One'},
      ],
    );
    final container = ProviderContainer(
      overrides: [
        authViewModelProvider.overrideWith(
          (ref) => _SeedAuth(
            const AuthState(
              status: AuthStatus.authenticated,
              session: session,
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: FeedMessagesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Only owned roles shown, using the app's canonical labels.
    expect(find.text('Startup'), findsOneWidget);
    expect(find.text('Investor'), findsOneWidget);
    expect(find.text('Community'), findsNothing);

    // Tapping Startup opens the workspace picker with both phases.
    await tester.tap(find.text('Startup'));
    await tester.pumpAndSettle();
    expect(find.text('Choose workspace'), findsOneWidget);
    expect(find.text('Acme'), findsWidgets);
    expect(find.text('Idea One'), findsOneWidget);
    expect(find.text('Created'), findsOneWidget);
    expect(find.text('Idea phase'), findsOneWidget);

    // Jump into the idea-phase workspace.
    await tester.tap(find.text('Idea One'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Idea phase'), findsWidgets);
  });
}
