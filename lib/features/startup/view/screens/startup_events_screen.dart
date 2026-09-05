import 'package:flutter/material.dart';

class StartupEventsScreen extends StatefulWidget {
  const StartupEventsScreen({
    super.key,
    required this.startupName,
    this.autoOpenCreateEvent = false,
  });

  final String startupName;
  final bool autoOpenCreateEvent;

  @override
  State<StartupEventsScreen> createState() => _StartupEventsScreenState();
}

class _StartupEventsScreenState extends State<StartupEventsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.autoOpenCreateEvent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        createEvent();
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  String _filter = 'All';
  bool _showMyEvents = false;
  final List<_StartupEvent> _events = [
    _StartupEvent(
      title: 'MedTech Startup Summit 2026',
      category: 'Pitch Events',
      date: 'AUG\n18',
      dateLabel: 'Tuesday - Thursday',
      time: '9:00 AM - 6:00 PM GMT-7',
      location: 'Moscone Center, San Francisco',
      attendees: 120,
      description:
          'The premier gathering for healthcare innovators, founders building the future of autonomous medicine, and investors.',
      color: const Color(0xFF0088CC),
    ),
    _StartupEvent(
      title: 'Founder\'s Last Mile',
      category: 'Networking',
      date: 'AUG\n21',
      dateLabel: 'Thursday',
      time: '5:30 PM - 8:00 PM',
      location: 'SOMA District, San Francisco',
      attendees: 84,
      description:
          'An intimate operator meetup for founders preparing their next growth milestone.',
      color: const Color(0xFF2563EB),
    ),
    _StartupEvent(
      title: 'Future of AI Healthcare',
      category: 'Conferences',
      date: 'AUG\n24',
      dateLabel: 'Sunday',
      time: '10:00 AM - 4:00 PM',
      location: 'Palo Alto Tech Hub',
      attendees: 210,
      description:
          'Product leaders, clinicians, and AI researchers discuss responsible healthcare innovation.',
      color: const Color(0xFF0F766E),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_StartupEvent> get _visibleEvents {
    final query = _searchController.text.trim().toLowerCase();
    return _events.where((event) {
      final matchesFilter = _filter == 'All' || event.category == _filter;
      final matchesQuery =
          query.isEmpty ||
          event.title.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  List<_StartupEvent> get _recommendedEvents => _visibleEvents;

  void _viewAllMyEvents() {
    setState(() => _showMyEvents = !_showMyEvents);
  }

  void _editEvent(_StartupEvent event) {
    final titleCtrl = TextEditingController(text: event.title);
    final locationCtrl = TextEditingController(text: event.location);
    final dateCtrl = TextEditingController(text: event.date.replaceAll('\n', ' '));
    final timeCtrl = TextEditingController(text: event.time);
    final descCtrl = TextEditingController(text: event.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42, height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088CC).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_calendar_rounded,
                            color: Color(0xFF0088CC), size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Text('Edit Event',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: Color(0xFF6B7280), size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ComposerField(
                    controller: titleCtrl, label: 'Event name',
                    hintText: 'Founder Meetup Night', icon: Icons.title_outlined, autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  _ComposerField(
                    controller: locationCtrl, label: 'Location',
                    hintText: 'San Francisco, CA', icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ComposerField(
                          controller: dateCtrl, label: 'Date',
                          hintText: 'AUG 18', icon: Icons.calendar_month_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ComposerField(
                          controller: timeCtrl, label: 'Time',
                          hintText: '9:00 AM - 6:00 PM', icon: Icons.schedule_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ComposerField(
                    controller: descCtrl, label: 'Description',
                    hintText: 'Tell founders why they should attend.',
                    icon: Icons.notes_outlined, maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            if (titleCtrl.text.trim().isEmpty) return;
                            final rawDate = dateCtrl.text.trim().toUpperCase();
                            final formatted = rawDate.isEmpty
                                ? event.date
                                : rawDate.replaceFirst(RegExp(r'\s+'), '\n');
                            setState(() {
                              final idx = _events.indexOf(event);
                              if (idx != -1) {
                                _events[idx] = _StartupEvent(
                                  title: titleCtrl.text.trim(),
                                  category: event.category,
                                  date: formatted,
                                  dateLabel: rawDate.isEmpty ? event.dateLabel : rawDate,
                                  time: timeCtrl.text.trim().isEmpty ? event.time : timeCtrl.text.trim(),
                                  location: locationCtrl.text.trim().isEmpty ? event.location : locationCtrl.text.trim(),
                                  attendees: event.attendees,
                                  description: descCtrl.text.trim().isEmpty ? event.description : descCtrl.text.trim(),
                                  color: event.color,
                                );
                              }
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Event updated successfully!')),
                            );
                          },
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: const Text('Save Changes',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0088CC),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() => _events.remove(event));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Event removed.')),
                          );
                        },
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text('Delete',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEvent(_StartupEvent event) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => _StartupEventDetailsScreen(event: event),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> createEvent() async {
    final created = await showModalBottomSheet<_StartupEvent>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) =>
          _CreateEventBottomSheet(startupName: widget.startupName),
    );
    if (created != null && mounted) {
      setState(() => _events.insert(0, created));
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _visibleEvents;
    final myEvents = _events.where((event) => event.registered).toList();
    final recommended = _recommendedEvents;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E1EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E1EB)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Networking', 'Pitch Events', 'Conferences']
                  .map(
                    (filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: _filter == filter,
                        onSelected: (_) => setState(() => _filter = filter),
                        selectedColor: const Color(0xFF0088CC),
                        labelStyle: TextStyle(
                          color: _filter == filter
                              ? Colors.white
                              : const Color(0xFF4B5563),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 22),
          if (events.isNotEmpty)
            _FeaturedEventCard(
              event: events.first,
              onTap: () => _openEvent(events.first),
            ),
          const SizedBox(height: 24),
          _SectionTitle(
            title: 'Recommended for you',
            action: '${recommended.length} events',
            onActionTap: () => setState(() => _filter = 'All'),
          ),
          const SizedBox(height: 10),
          if (events.isEmpty)
            const _EmptyEvents()
          else
            ...events
                .skip(1)
                .map(
                  (event) => _EventListCard(
                    event: event,
                    onTap: () => _openEvent(event),
                    onSave: () => setState(() => event.saved = !event.saved),
                    onEdit: () => _editEvent(event),
                  ),
                ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'My events',
            action: myEvents.isEmpty ? '' : (_showMyEvents ? 'Show less' : 'View all'),
            onActionTap: myEvents.isEmpty ? null : _viewAllMyEvents,
          ),
          const SizedBox(height: 10),
          if (myEvents.isEmpty)
            const _EmptyEvents(message: 'Register for an event to see it here.')
          else
            ...myEvents.take(_showMyEvents ? myEvents.length : 2).map(
              (event) => _EventListCard(
                event: event,
                onTap: () => _openEvent(event),
                onSave: () => setState(() => event.saved = !event.saved),
                onEdit: () => _editEvent(event),
              ),
            ),
        ],
      ),
    );
  }
}

class _StartupEventDetailsScreen extends StatefulWidget {
  const _StartupEventDetailsScreen({required this.event});
  final _StartupEvent event;

  @override
  State<_StartupEventDetailsScreen> createState() =>
      _StartupEventDetailsScreenState();
}

class _StartupEventDetailsScreenState
    extends State<_StartupEventDetailsScreen> {
  void _register() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final companyCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0088CC).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.how_to_reg_rounded,
                              color: Color(0xFF0088CC), size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Register for event',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF12233D))),
                              Text('Fill in your details to confirm your spot',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF6B7280))),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: Color(0xFF6B7280), size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Event info chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0088CC).withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_rounded,
                              color: Color(0xFF0088CC), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.event.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0088CC),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Full Name
                    _RegField(
                      controller: nameCtrl,
                      label: 'Full Name *',
                      hint: 'e.g. Arjun Mehta',
                      icon: Icons.person_outline_rounded,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 12),
                    // Email
                    _RegField(
                      controller: emailCtrl,
                      label: 'Email Address *',
                      hint: 'e.g. arjun@startup.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please enter your email';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Role / Title
                    _RegField(
                      controller: roleCtrl,
                      label: 'Your Role / Title',
                      hint: 'e.g. Co-Founder & CTO',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 12),
                    // Company / Startup
                    _RegField(
                      controller: companyCtrl,
                      label: 'Startup / Company',
                      hint: 'e.g. MedVision AI',
                      icon: Icons.business_outlined,
                    ),
                    const SizedBox(height: 20),
                    // Free badge
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Color(0xFF059669), size: 18),
                          SizedBox(width: 8),
                          Text('This event is free to attend',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF065F46))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          Navigator.pop(ctx);
                          setState(() => widget.event.registered = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'You\'re registered, ${nameCtrl.text.trim()}! Check ${emailCtrl.text.trim()} for confirmation.'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color(0xFF059669),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text('Confirm Registration',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Event details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => event.saved = !event.saved),
            icon: Icon(event.saved ? Icons.bookmark : Icons.bookmark_border),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Event link copied.'))),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _EventHero(event: event),
          const SizedBox(height: 16),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 24,
              height: 1.15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 18),
          _DetailsCard(event: event),
          const SizedBox(height: 20),
          const Text(
            'About this event',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Meet founders, investors, and product leaders. Build partnerships, join focused sessions, and leave with practical next steps.',
            style: TextStyle(color: Color(0xFF5D6472), height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text(
            'Schedule',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          const _ScheduleItem(time: '09:00 AM', title: 'Registration & Coffee'),
          const _ScheduleItem(time: '10:30 AM', title: 'Founder keynote'),
          const _ScheduleItem(
            time: '12:30 PM',
            title: 'Networking lunch',
            last: true,
          ),
          const SizedBox(height: 18),
          const Text(
            'Location',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            event.location,
            style: const TextStyle(color: Color(0xFF5D6472)),
          ),
          const SizedBox(height: 12),
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFFDCEBFF), Color(0xFFE8F4FB)],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: Color(0xFF0088CC),
                size: 34,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Free',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Registration',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: event.registered ? null : _register,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0088CC),
                  minimumSize: const Size(154, 48),
                ),
                child: Text(event.registered ? 'Registered' : 'Register now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartupEvent {
  _StartupEvent({
    required this.title,
    required this.category,
    required this.date,
    required this.dateLabel,
    required this.time,
    required this.location,
    required this.attendees,
    required this.description,
    required this.color,
  });
  final String title;
  final String category;
  final String date;
  final String dateLabel;
  final String time;
  final String location;
  final int attendees;
  final String description;
  final Color color;
  bool saved = false;
  bool registered = false;
}

class _FeaturedEventCard extends StatelessWidget {
  const _FeaturedEventCard({required this.event, required this.onTap});
  final _StartupEvent event;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Ink(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [event.color, const Color(0xFF006699)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FEATURED EVENT',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '${event.dateLabel}  |  ${event.location}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          const Chip(
            label: Text('View event'),
            labelStyle: TextStyle(
              color: Color(0xFF0088CC),
              fontWeight: FontWeight.w800,
            ),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    ),
  );
}

class _EventListCard extends StatelessWidget {
  const _EventListCard({
    required this.event,
    required this.onTap,
    required this.onSave,
    required this.onEdit,
  });

  final _StartupEvent event;
  final VoidCallback onTap;
  final VoidCallback onSave;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 54,
                decoration: BoxDecoration(
                  color: event.color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    event.date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: event.color,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      event.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: const Color(0xFF9CA3AF),
                tooltip: 'Edit event',
              ),
              IconButton(
                onPressed: onSave,
                icon: Icon(
                  event.saved ? Icons.bookmark : Icons.bookmark_border,
                  color: const Color(0xFF0088CC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventHero extends StatelessWidget {
  const _EventHero({required this.event});
  final _StartupEvent event;
  @override
  Widget build(BuildContext context) => Container(
    height: 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [event.color, const Color(0xFF1E1B4B)],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -10,
          top: -20,
          child: Icon(
            Icons.hub_rounded,
            size: 180,
            color: Colors.white.withValues(alpha: .12),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.category.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${event.attendees} founders attending',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.event});
  final _StartupEvent event;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE6E4ED)),
    ),
    child: Column(
      children: [
        _DetailRow(
          icon: Icons.calendar_month_outlined,
          text: '${event.date.replaceAll('\n', ' ')}  •  ${event.dateLabel}',
        ),
        _DetailRow(icon: Icons.schedule_outlined, text: event.time),
        _DetailRow(
          icon: Icons.location_on_outlined,
          text: event.location,
          last: true,
        ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text, this.last = false});
  final IconData icon;
  final String text;
  final bool last;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 14),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFF0EAFE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: const Color(0xFF0088CC)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    ),
  );
}

class _CreateEventBottomSheet extends StatefulWidget {
  const _CreateEventBottomSheet({required this.startupName});
  final String startupName;

  @override
  State<_CreateEventBottomSheet> createState() => _CreateEventBottomSheetState();
}

class _CreateEventBottomSheetState extends State<_CreateEventBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _descriptionController;
  String _category = 'Networking';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _dateController = TextEditingController(text: 'AUG 18');
    _timeController = TextEditingController(text: '9:00 AM - 6:00 PM');
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.event_available_rounded,
                        color: Color(0xFF0088CC),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create event',
                            style: TextStyle(
                              color: Color(0xFF172033),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add a new event for ${widget.startupName} and keep it visible in the startup dashboard.',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              height: 1.35,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F4F6),
                      ),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF6B7280),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ComposerField(
                  controller: _titleController,
                  label: 'Event name',
                  hintText: 'Founder Meetup Night',
                  icon: Icons.title_outlined,
                  autofocus: true,
                ),
                const SizedBox(height: 14),
                _ComposerField(
                  controller: _locationController,
                  label: 'Location',
                  hintText: 'San Francisco, CA',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.category_outlined,
                              color: Color(0xFF6B7280), size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _category,
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 'Networking', child: Text('Networking')),
                                DropdownMenuItem(value: 'Pitch Events', child: Text('Pitch Events')),
                                DropdownMenuItem(value: 'Conferences', child: Text('Conferences')),
                              ],
                              onChanged: (val) {
                                if (val == null) return;
                                setState(() => _category = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ComposerField(
                        controller: _dateController,
                        label: 'Date',
                        hintText: 'AUG 18',
                        icon: Icons.calendar_month_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ComposerField(
                        controller: _timeController,
                        label: 'Time',
                        hintText: '9:00 AM - 6:00 PM',
                        icon: Icons.schedule_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _ComposerField(
                  controller: _descriptionController,
                  label: 'Description',
                  hintText: 'Tell founders why they should attend this event.',
                  icon: Icons.notes_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) return;
                      final rawDate = _dateController.text.trim().toUpperCase();
                      final formattedDate = rawDate.isEmpty
                          ? 'SEP\n12'
                          : rawDate.replaceFirst(RegExp(r'\s+'), '\n');
                      Navigator.pop(
                        context,
                        _StartupEvent(
                          title: _titleController.text.trim(),
                          category: _category,
                          date: formattedDate,
                          dateLabel: rawDate.isEmpty ? 'Friday' : rawDate,
                          time: _timeController.text.trim().isEmpty
                              ? '6:00 PM - 8:00 PM'
                              : _timeController.text.trim(),
                          location: _locationController.text.trim().isEmpty
                              ? 'Location to be announced'
                              : _locationController.text.trim(),
                          attendees: 0,
                          description: _descriptionController.text.trim().isEmpty
                              ? 'An event created by ${widget.startupName}.'
                              : _descriptionController.text.trim(),
                          color: const Color(0xFF229ED9),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Create event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComposerField extends StatelessWidget {
  const _ComposerField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.autofocus = false,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool autofocus;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          autofocus: autofocus,
          maxLines: maxLines,
          textInputAction: maxLines > 1
              ? TextInputAction.newline
              : TextInputAction.next,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 22),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0088CC), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.time,
    required this.title,
    this.last = false,
  });
  final String time;
  final String title;
  final bool last;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFF0088CC),
              shape: BoxShape.circle,
            ),
          ),
          if (!last)
            Container(width: 2, height: 36, color: const Color(0xFFE4D8FA)),
        ],
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF0088CC),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.action,
    this.onActionTap,
  });
  final String title;
  final String action;
  final VoidCallback? onActionTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w900,
          color: Color(0xFF172033),
        ),
      ),
      const Spacer(),
      if (action.isNotEmpty)
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFF0088CC),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
    ],
  );
}

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents({this.message = 'No events match your search.'});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const Icon(Icons.event_busy_outlined, color: Color(0xFF9CA3AF)),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
      ],
    ),
  );
}

class _RegField extends StatelessWidget {
  const _RegField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 20),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0088CC), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
