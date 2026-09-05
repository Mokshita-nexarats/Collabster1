import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/bridge/bridge_models.dart';
import '../../../../../core/bridge/view/connect_screen.dart';
import '../../../../../core/di/providers.dart';
import '../../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../../../shared/widgets/mode_drawer.dart';
import '../../../../../shared/widgets/mode_menu_bar.dart';
import '../../../../auth/view/screens/profile_screen.dart';
import '../../../../auth/view/sign_in_screen.dart';
import '../../../../inbox/view/inbox_screen.dart';
import '../../../model/event_model.dart';
import '../../../view/widgets/event_card.dart';
import '../event_home_screen.dart';
import 'conferences_screen.dart';
import 'event_create_screen.dart';
import 'event_detail_screen.dart';
import 'event_notifications_screen.dart';
import 'hackathons_screen.dart';
import 'meetups_screen.dart';
import 'my_events_screen.dart';
import 'webinars_screen.dart';
import 'workshops_screen.dart';

// ─── Color Tokens ───────────────────────────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _accentBg = Color(0xFFEFF6FF);
const _live = Color(0xFFFF3C5C);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

class EventHomeScreen extends ConsumerStatefulWidget {
  const EventHomeScreen({super.key});

  @override
  ConsumerState<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends ConsumerState<EventHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _bottomNavIndex = 0;
  int _selectedDayIndex = 0;
  int _activityTabIndex = 0;
  final _searchController = TextEditingController();

  late final List<DateTime> _days;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.code_rounded, 'label': 'Hackathons'},
    {'icon': Icons.edit_note_rounded, 'label': 'Workshops'},
    {'icon': Icons.people_rounded, 'label': 'Meetups'},
    {'icon': Icons.mic_rounded, 'label': 'Conferences'},
    {'icon': Icons.laptop_mac_rounded, 'label': 'Webinars'},
  ];

  @override
  void initState() {
    super.initState();
    _days = List.generate(5, (i) {
      final d = DateTime.now().add(Duration(days: i));
      return DateTime(d.year, d.month, d.day);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(eventViewModelProvider.notifier).loadEvents();
      ref
          .read(eventNotificationsViewModelProvider.notifier)
          .loadNotifications();
      ref.read(bridgeViewModelProvider.notifier).loadAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
    );
  }

  void _openCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EventCreateScreen()),
    );
  }

  void _openAllEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EventsListScreen()),
    );
  }

  void _openMyEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyEventsScreen()),
    );
  }

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Sarah';
    final initials = userName.isNotEmpty ? userName[0].toUpperCase() : 'S';

    final eventState = ref.watch(eventViewModelProvider);
    final allEvents = eventState.events;
    final myEvents = eventState.myEvents;
    final bridge = ref.watch(bridgeViewModelProvider);
    final bridgeOpportunities = bridge.opportunities;
    final bridgePosts = bridge.posts;

    final selectedDay = _days[_selectedDayIndex];
    final eventsOnDay = allEvents
        .where(
          (e) =>
              e.startDate.year == selectedDay.year &&
              e.startDate.month == selectedDay.month &&
              e.startDate.day == selectedDay.day,
        )
        .toList();

    final upcoming = eventsOnDay.isNotEmpty
        ? eventsOnDay
        : allEvents
              .where((e) => !e.startDate.isBefore(DateTime.now()))
              .take(3)
              .toList();

    final recommended = allEvents.isEmpty
        ? null
        : allEvents.reduce(
            (a, b) => a.attendeeCount >= b.attendeeCount ? a : b,
          );
    final topEvents = [...allEvents]
      ..sort((a, b) => b.attendeeCount.compareTo(a.attendeeCount));
    final liveNow = allEvents.where((e) => e.isOnline).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeaderBanner(
              initials,
              userName,
              myEvents.length,
              allEvents.length,
              liveNow.length,
            ),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildDateStrip(),
            const SizedBox(height: 20),
            _buildSectionHeader(
              'Your Upcoming',
              'View All',
              onCta: _openMyEvents,
            ),
            const SizedBox(height: 12),
            _buildUpcomingList(upcoming),
            const SizedBox(height: 24),
            _buildSectionHeader('Explore by Category', null),
            const SizedBox(height: 14),
            _buildCategoryChips(),
            const SizedBox(height: 24),
            _buildSectionHeader(
              'My Activity',
              'View All',
              onCta: _openMyEvents,
            ),
            const SizedBox(height: 12),
            _buildActivityTabs(),
            const SizedBox(height: 12),
            _buildActivityList(myEvents, allEvents),
            const SizedBox(height: 24),
            _buildSectionHeader('Recommended', null),
            const SizedBox(height: 12),
            if (recommended != null) _buildRecommendedCard(recommended),
            const SizedBox(height: 24),
            _buildSectionHeader(
              'Top Events',
              'VIEW ALL',
              onCta: _openAllEvents,
            ),
            const SizedBox(height: 12),
            _buildTopEventsRow(topEvents.take(4).toList()),
            const SizedBox(height: 24),
            _buildConnectSection(bridgeOpportunities, bridgePosts),
            const SizedBox(height: 24),
            if (liveNow.isNotEmpty) _buildRegisteredLiveSection(liveNow.first),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _bottomNavIndex,
        onTap: (index) async {
          switch (index) {
            case 0:
              setState(() => _bottomNavIndex = 0);
            case 1:
              setState(() => _bottomNavIndex = 1);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EventsListScreen(),
                ),
              );
              if (mounted) setState(() => _bottomNavIndex = 0);
            case 2:
              _openCreate();
            case 3:
              setState(() => _bottomNavIndex = 3);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InboxScreen()),
              );
              if (mounted) setState(() => _bottomNavIndex = 0);
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
          }
        },
      ),
    );
  }

  void _push(Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> _logout() async {
    Navigator.pop(context);
    await ref.read(authViewModelProvider.notifier).logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  Widget _buildDrawer() {
    final session = ref.watch(authViewModelProvider).session;
    return ModeDrawer(
      userName: session?.fullName ?? 'Sarah',
      email: session?.email ?? '',
      photoPath: session?.profilePhotoPath ?? '',
      headerGradient: const [Color(0xFF0088CC), Color(0xFF229ED9)],
      avatarColor: const Color(0xFF0088CC),
      items: [
        ModeDrawerItem(
          icon: Icons.add_circle_outline_rounded,
          label: 'New Event',
          onTap: () {
            Navigator.pop(context);
            _openCreate();
          },
        ),
        ModeDrawerItem(
          icon: Icons.event_outlined,
          label: 'All Events',
          onTap: () {
            Navigator.pop(context);
            _openAllEvents();
          },
        ),
        ModeDrawerItem(
          icon: Icons.confirmation_number_outlined,
          label: 'My Events',
          onTap: () {
            Navigator.pop(context);
            _openMyEvents();
          },
        ),
        ModeDrawerItem(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Messages',
          onTap: () => _push(const InboxScreen()),
        ),
        ModeDrawerItem(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          onTap: () => _push(const EventNotificationsScreen()),
        ),
        ModeDrawerItem(
          icon: Icons.alt_route_rounded,
          label: 'Connect',
          onTap: () =>
              _push(const ConnectScreen(modeTheme: 'event')),
        ),
        ModeDrawerItem(
          icon: Icons.person_outline_rounded,
          label: 'My Profile',
          onTap: () => _push(const ProfileScreen()),
        ),
        ModeDrawerItem(
          icon: Icons.swap_horiz_rounded,
          label: 'Switch Tab',
          onTap: () {
            Navigator.pop(context);
            RoleSwitcherSheet.show(context);
          },
        ),
      ],
      onLogout: _logout,
    );
  }

  Widget _buildTopHeaderBanner(
    String initials,
    String userName,
    int registeredCount,
    int totalCount,
    int liveCount,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006699), Color(0xFF0088CC), Color(0xFF229ED9)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ModeMenuButton(
                    onTap: () =>
                        _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.event_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Events Hub',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Discover workshops, meetups & conferences',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '$_timeBasedGreeting, $userName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready for your next event session today?',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _headerStatItem(
                      Icons.confirmation_number_outlined,
                      '$registeredCount',
                      'Passes',
                    ),
                    _headerDivider(),
                    _headerStatItem(
                      Icons.event_available_outlined,
                      '$totalCount',
                      'Events',
                    ),
                    _headerDivider(),
                    _headerStatItem(
                      Icons.videocam_outlined,
                      '$liveCount',
                      'Live Now',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 19),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _headerDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: _textSecondary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (q) =>
                    ref.read(eventViewModelProvider.notifier).setSearchQuery(q),
                style: const TextStyle(color: _textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search events, workshops...',
                  hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateStrip() {
    const daysAbbr = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        height: 60,
        child: Row(
          children: List.generate(_days.length, (i) {
            final isSelected = _selectedDayIndex == i;
            final day = _days[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDayIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: i == _days.length - 1 ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _accent : _surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _accent : _borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        daysAbbr[day.weekday - 1],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white70 : _textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : _textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? cta, {VoidCallback? onCta}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (cta != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onCta,
              child: Text(
                cta,
                style: const TextStyle(
                  color: _accentLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpcomingList(List<Event> events) {
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor),
          ),
          child: Column(
            children: [
              const Icon(Icons.event_outlined, color: _textSecondary, size: 34),
              const SizedBox(height: 8),
              const Text(
                'No events on this day',
                style: TextStyle(color: _textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _openCreate,
                child: const Text(
                  'Create one →',
                  style: TextStyle(
                    color: _accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: events.take(2).map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: EventCard(
              event: e,
              isRegistered: ref
                  .watch(eventViewModelProvider)
                  .isRegistered(e.id),
              onTap: () => _openDetail(e),
              onRegister: () {
                ref.read(eventViewModelProvider.notifier).rsvpEvent(e.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registered for the event!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (i) {
          final cat = _categories[i];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                final screen = switch (cat['label'] as String) {
                  'Hackathons' => const HackathonsScreen(),
                  'Workshops' => const WorkshopsScreen(),
                  'Meetups' => const MeetupsScreen(),
                  'Conferences' => const ConferencesScreen(),
                  _ => const WebinarsScreen(),
                };
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _card,
                      shape: BoxShape.circle,
                      border: Border.all(color: _borderColor),
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: _accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['label'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActivityTabs() {
    final tabs = ['Registrations', 'Watchlist', 'Recent'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = _activityTabIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _activityTabIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? _accent : _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? _accent : _borderColor),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : _textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActivityList(List<Event> myEvents, List<Event> allEvents) {
    final items = switch (_activityTabIndex) {
      0 => myEvents,
      1 => allEvents.where((e) => e.startDate.isAfter(DateTime.now())).toList(),
      _ => allEvents.take(4).toList(),
    };
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor),
          ),
          child: const Text(
            'Nothing here yet — register for an event to see it.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondary, fontSize: 12.5),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: items.map((e) {
          return GestureDetector(
            onTap: () => _openDetail(e),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _accentBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      e.isOnline
                          ? Icons.videocam_rounded
                          : Icons.event_note_rounded,
                      color: _accentLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${e.location} • ${e.category}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: _textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedCard(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFFEFF6FF), Color(0xFFD1FAE5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.event_rounded, size: 48, color: _accent),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${event.startDate.month}\n${event.startDate.day}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Row(
                    children: [
                      _tagChip(event.category),
                      const SizedBox(width: 6),
                      _tagChip(event.isOnline ? 'Online' : event.location),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openDetail(event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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

  Widget _buildConnectSection(
    List<BridgeOpportunity> opportunities,
    List<BridgePost> posts,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Connected Across Modes',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${opportunities.length + posts.length} items',
                  style: const TextStyle(
                    color: Color(0xFF0088CC),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (opportunities.isEmpty && posts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              child: const Text(
                'Connect to see hiring from Startup, Career jobs and posts from Community — all in one place.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            )
          else ...[
            ...opportunities.take(2).map((opp) {
              final isStartup = opp.fromStartup;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'event')),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isStartup
                              ? const Color(0xFFF3E8FF)
                              : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isStartup
                              ? Icons.rocket_launch_rounded
                              : Icons.work_rounded,
                          color: isStartup
                              ? const Color(0xFF0088CC)
                              : const Color(0xFF0284C7),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opp.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${opp.company} • ${opp.location}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isStartup
                              ? const Color(0xFFE8F4FB)
                              : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isStartup ? 'STARTUP' : 'CAREER',
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (posts.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.forum_rounded,
                        color: Color(0xFFEA580C),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posts.first.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${posts.first.sourceLabel} • ${posts.first.authorName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        posts.first.source == 'startup'
                            ? 'STARTUP'
                            : 'COMMUNITY',
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'event')),
                );
              },
              icon: const Icon(
                Icons.alt_route_rounded,
                size: 17,
                color: Color(0xFF0088CC),
              ),
              label: const Text(
                'Open Connect Hub',
                style: TextStyle(
                  color: Color(0xFF0088CC),
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0088CC), width: 1.3),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      ),
    );
  }

  Widget _buildTopEventsRow(List<Event> events) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: events.length,
        itemBuilder: (ctx, i) {
          final ev = events[i];
          return GestureDetector(
            onTap: () => _openDetail(ev),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [const Color(0xFF064E3B), const Color(0xFF0F766E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ev.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ev.attendeeCount} going • ${ev.category}',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegisteredLiveSection(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Registered: Live Now',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.circle, color: _live, size: 8),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        gradient: LinearGradient(
                          colors: [Color(0xFF006699), Color(0xFF0F766E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.ondemand_video_rounded,
                          size: 40,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _live,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 5),
                            SizedBox(width: 3),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openDetail(event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Join Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
    );
  }

}

// ── Floating Notched Bottom Navigation Bar for Events Mode ──
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // Same flat menu-bar design as Community mode — Event keeps its own
    // green accent, tabs and tap behavior (dark-mode aware).
    return ModeMenuBar(
      selectedIndex: selectedIndex,
      onTap: onTap,
      selectedColor: const Color(0xFF0088CC),
      fabGradient: const [Color(0xFF229ED9), Color(0xFF0088CC)],
      items: const [
        ModeMenuItem(index: 0, icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
        ModeMenuItem(index: 1, icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Explore'),
        ModeMenuItem(index: 3, icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Messages'),
        ModeMenuItem(index: 4, icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
      ],
    );
  }
}
