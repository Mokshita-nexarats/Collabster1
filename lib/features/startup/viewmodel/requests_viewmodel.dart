import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'requests_state.dart';

class RequestsViewModel extends StateNotifier<RequestsState> {
  RequestsViewModel() : super(const RequestsState());

  void loadInitialData() {
    // Load once per session — reloading would resurrect accepted/ignored requests.
    if (state.pending.isNotEmpty || state.accepted.isNotEmpty) return;
    state = state.copyWith(
      pending: const [
        ConnectionRequest(
          name: 'Priya Sharma',
          role: 'Angel Investor • Mumbai',
          initials: 'PS',
          category: 'Investor',
          note: 'Interested in your B2B SaaS traction.',
          time: '10m ago',
          mutualConnections: 12,
        ),
        ConnectionRequest(
          name: 'Ravi Kumar',
          role: 'CTO at TechNova • Bangalore',
          initials: 'RK',
          category: 'Founder',
          note: 'Hey! Looking to collaborate on cloud infrastructure.',
          time: '1h ago',
          mutualConnections: 8,
        ),
        ConnectionRequest(
          name: 'Ananya Patel',
          role: 'Product Designer • Delhi',
          initials: 'AP',
          category: 'Design',
          note: 'Loved your product design! Would like to connect.',
          time: '3h ago',
          mutualConnections: 4,
        ),
        ConnectionRequest(
          name: 'Suresh Menon',
          role: 'Startup Advisor • Hyderabad',
          initials: 'SM',
          category: 'Mentor',
          note: 'Advising Series-A founders in FinTech.',
          time: 'Yesterday',
          mutualConnections: 19,
        ),
        ConnectionRequest(
          name: 'Kavitha Reddy',
          role: 'VC Partner at SeedFund • Chennai',
          initials: 'KR',
          category: 'Investor',
          note: 'We are active seed investors in your space.',
          time: '2d ago',
          mutualConnections: 15,
        ),
      ],
    );
  }

  void accept(String name) {
    final requestIndex = state.pending.indexWhere((r) => r.name == name);
    if (requestIndex == -1) return;

    final request = state.pending[requestIndex];
    final newPending = List<ConnectionRequest>.from(state.pending);
    newPending.removeAt(requestIndex);

    state = state.copyWith(
      pending: newPending,
      accepted: [...state.accepted, request],
      connected: state.connected + 1,
    );
  }

  void ignore(String name) {
    final newPending = state.pending.where((r) => r.name != name).toList();
    state = state.copyWith(
      pending: newPending,
      ignored: state.ignored + 1,
    );
  }

  List<ConnectionRequest> filtered(String category) {
    if (category == 'All') return state.pending;
    return state.pending
        .where((r) => r.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
