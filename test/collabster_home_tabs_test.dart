import 'package:collabsphere/core/di/providers.dart';
import 'package:collabsphere/features/home/view/collabster_home/collabster_home_screen.dart';
import 'package:collabsphere/features/home/view/collabster_home/home_feed_item.dart';
import 'package:collabsphere/features/home/view/collabster_home/my_posts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(HomeRole role) {
  return ProviderScope(
    child: MaterialApp(
      home: CollabsterHomeScreen(activeRole: role),
    ),
  );
}

void main() {
  testWidgets('Jobs tab switches content + highlight (startup role)',
      (tester) async {
    await tester.pumpWidget(_harness(HomeRole.startup));
    await tester.pumpAndSettle();

    // For You is default: feed posts visible, jobs section hidden.
    expect(find.text('Project Alpha: Beta Launch Today!'), findsOneWidget);
    expect(find.text('Hiring Now in Startups'), findsNothing);

    // Tap Jobs tab.
    await tester.tap(find.text('Jobs'));
    await tester.pumpAndSettle();

    // Jobs tab is highlighted blue, For You is not.
    Color? tabColor(String label) {
      final t = tester.widget<Text>(find.text(label));
      return t.style?.color;
    }

    expect(tabColor('Jobs'), const Color(0xFF2563EB));
    expect(tabColor('For You'), const Color(0xFF6B7280));

    // Jobs content visible.
    expect(find.text('Hiring Now in Startups'), findsWidgets);
    expect(find.text('Flutter Developer'), findsWidgets);

    // Tap Following tab, then back to For You.
    await tester.tap(find.text('Following'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('For You'));
    await tester.pumpAndSettle();
    expect(find.text('Project Alpha: Beta Launch Today!'), findsOneWidget);
  });

  testWidgets('Investor role has no Jobs tab', (tester) async {
    await tester.pumpWidget(_harness(HomeRole.investor));
    await tester.pumpAndSettle();

    expect(find.text('For You'), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Jobs'), findsNothing);
    expect(find.text('Hiring Now in Startups'), findsNothing);
  });

  testWidgets('Create Post publishes to the top of the feed',
      (tester) async {
    await tester.pumpWidget(_harness(HomeRole.startup));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Post to Anyone'), findsOneWidget);

    await tester.enterText(
        find.byType(TextField).first, 'Hello Collabster test post');
    await tester.pump();
    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();

    expect(find.text('Hello Collabster test post'), findsOneWidget);
  });

  testWidgets('Poll post can be created and voted on', (tester) async {
    await tester.pumpWidget(_harness(HomeRole.startup));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextField).first, 'Best launch day?');
    await tester.tap(find.text('Poll'));
    await tester.pump();
    await tester.enterText(
        find.byType(TextField).at(1), 'Monday');
    await tester.enterText(
        find.byType(TextField).at(2), 'Friday');
    await tester.pump();
    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();

    expect(find.text('Best launch day?'), findsOneWidget);
    await tester.tap(find.text('Monday'));
    await tester.pumpAndSettle();
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('My Posts lists and deletes own posts', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    const post = HomeFeedPost(
      id: 'mine-1',
      roleTag: HomeRole.startup,
      authorName: 'Tester',
      authorSub: 'Just now',
      initials: 'T',
      timeAgo: 'now',
      title: '',
      body: 'My own test post',
      followed: true,
    );
    container.read(userPostsViewModelProvider.notifier).add(post);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MyPostsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('My own test post'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete post'));
    await tester.pumpAndSettle();
    expect(find.text('My own test post'), findsNothing);
  });
}
