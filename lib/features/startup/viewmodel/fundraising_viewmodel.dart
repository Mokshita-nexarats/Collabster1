import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'fundraising_state.dart';

class FundraisingViewModel extends StateNotifier<FundraisingState> {
  FundraisingViewModel() : super(const FundraisingState());

  void loadInitialData() {
    state = state.copyWith(
      activeInvestors: const [
        FundraisingInvestor(
          name: 'Horizon Ventures',
          fund: 'Series A',
          amount: '\$350K',
          meetingIn: 'Meeting Tomorrow',
          initials: 'HV',
          colorKey: '0xFF229ED9',
          leadPartner: 'Anish Srivastava',
          email: 'anish@horizonvc.com',
          notes: 'Interested in B2B AI & Cloud Infrastructure platforms.',
        ),
        FundraisingInvestor(
          name: 'NorthStar Ventures',
          fund: 'Pre-seed',
          amount: '\$400K',
          meetingIn: 'Not Engaged',
          initials: 'NV',
          colorKey: '0xFF0D9488',
          leadPartner: 'Rachel Green',
          email: 'rachel@northstarvc.io',
          notes: 'Focusing on early-stage developer tools & developer ecosystem.',
        ),
        FundraisingInvestor(
          name: 'SeedFounders',
          fund: 'Seed',
          amount: '\$150K',
          meetingIn: '2 weeks ago',
          initials: 'SF',
          colorKey: '0xFFF59E0B',
          leadPartner: 'Michael Chang',
          email: 'm.chang@seedfounders.com',
          notes: 'Follow-on investor from initial incubator batch.',
        ),
      ],
      attentionTasks: const [
        FundraisingTask(
          title: 'Investor Meeting Tomorrow',
          subtitle: 'Horizon Ventures – 10:00 AM',
          iconKey: 'event_outlined',
          isUrgent: true,
        ),
        FundraisingTask(
          title: 'Update Pitch Deck',
          subtitle: 'Slides are 2 months outdated.',
          iconKey: 'description_outlined',
          isUrgent: false,
        ),
      ],
      documents: const [
        FundraisingDocument(
          name: 'Pitch Deck v3.pdf',
          size: '2.4 MB',
          dateAdded: 'Added 3 days ago',
        ),
        FundraisingDocument(
          name: 'Financial Projections.pdf',
          size: '1.6 MB',
          dateAdded: 'Added 1 week ago',
        ),
      ],
    );
  }

  void addInvestor(FundraisingInvestor investor, double checkSizeInMillions) {
    state = state.copyWith(
      activeInvestors: [investor, ...state.activeInvestors],
      raisedAmount: (state.raisedAmount + checkSizeInMillions).clamp(0.0, 10.0),
      meetingsCount: state.meetingsCount + 1,
      reachCount: state.reachCount + 5,
      introsCount: state.introsCount + 1,
      repliesCount: state.repliesCount + 2,
    );
  }

  void updateInvestorStatus(FundraisingInvestor investor, String newStatus) {
    final updated = state.activeInvestors.map((i) {
      if (i.name == investor.name) {
        return i.copyWith(meetingIn: newStatus);
      }
      return i;
    }).toList();
    state = state.copyWith(activeInvestors: updated);
  }

  void addDocument(FundraisingDocument doc) {
    state = state.copyWith(documents: [doc, ...state.documents]);
  }

  void removeDocument(FundraisingDocument doc) {
    final updated = state.documents.where((d) => d.name != doc.name).toList();
    state = state.copyWith(documents: updated);
  }

  void addAttentionTask(FundraisingTask task) {
    state = state.copyWith(attentionTasks: [task, ...state.attentionTasks]);
  }

  void resolveTask(FundraisingTask task) {
    final updated = state.attentionTasks.where((t) => t != task).toList();
    state = state.copyWith(attentionTasks: updated);
  }
}
