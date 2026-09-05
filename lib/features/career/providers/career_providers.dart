import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppliedApplicationItem {
  final String id;
  final String title;
  final String company;
  final String logoUrl;
  final String statusLabel;
  final Color statusColor;
  final Color statusBgColor;
  final String type; // 'Job', 'Internship', 'Freelance'
  final String appliedDate;
  final bool isActive;

  AppliedApplicationItem({
    required this.id,
    required this.title,
    required this.company,
    required this.logoUrl,
    required this.statusLabel,
    required this.statusColor,
    required this.statusBgColor,
    required this.type,
    required this.appliedDate,
    this.isActive = true,
  });
}

class CompletedInterviewItem {
  final String id;
  final String title;
  final String company;
  final String date;
  final String score;
  final String interviewer;
  final String status;

  CompletedInterviewItem({
    required this.id,
    required this.title,
    required this.company,
    required this.date,
    required this.score,
    required this.interviewer,
    required this.status,
  });
}

class UserResumeState {
  final String fileName;
  final String fileSize;
  final String uploadDate;
  final int atsScore;
  final List<String> skills;
  final List<String> experiences;

  UserResumeState({
    required this.fileName,
    required this.fileSize,
    required this.uploadDate,
    this.atsScore = 88,
    required this.skills,
    required this.experiences,
  });

  UserResumeState copyWith({
    String? fileName,
    String? fileSize,
    String? uploadDate,
    int? atsScore,
    List<String>? skills,
    List<String>? experiences,
  }) {
    return UserResumeState(
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      uploadDate: uploadDate ?? this.uploadDate,
      atsScore: atsScore ?? this.atsScore,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
    );
  }
}

class CareerState {
  final List<AppliedApplicationItem> appliedApplications;
  final List<CompletedInterviewItem> completedInterviews;
  final UserResumeState resumeState;

  CareerState({
    required this.appliedApplications,
    required this.completedInterviews,
    required this.resumeState,
  });

  CareerState copyWith({
    List<AppliedApplicationItem>? appliedApplications,
    List<CompletedInterviewItem>? completedInterviews,
    UserResumeState? resumeState,
  }) {
    return CareerState(
      appliedApplications: appliedApplications ?? this.appliedApplications,
      completedInterviews: completedInterviews ?? this.completedInterviews,
      resumeState: resumeState ?? this.resumeState,
    );
  }
}

class CareerNotifier extends StateNotifier<CareerState> {
  CareerNotifier()
      : super(
          CareerState(
            appliedApplications: [
              // Jobs
              AppliedApplicationItem(
                id: '1',
                title: 'Senior Product Designer',
                company: 'Nexus Systems',
                logoUrl: 'https://img.icons8.com/color/48/adobe-illustrator.png',
                statusLabel: 'APPLICATION RECEIVED',
                statusColor: const Color(0xFF10B981),
                statusBgColor: const Color(0xFFE6FBF3),
                type: 'Job',
                appliedDate: 'Oct 12, 2026',
              ),
              AppliedApplicationItem(
                id: '2',
                title: 'Frontend Engineer',
                company: 'CloudStrate',
                logoUrl: 'https://img.icons8.com/color/48/figma--v1.png',
                statusLabel: 'UNDER REVIEW',
                statusColor: const Color(0xFF0088CC),
                statusBgColor: const Color(0xFFE8F4FB),
                type: 'Job',
                appliedDate: 'Oct 14, 2026',
              ),
              AppliedApplicationItem(
                id: '3',
                title: 'Frontend Developer',
                company: 'Google',
                logoUrl: 'https://img.icons8.com/color/48/google-logo.png',
                statusLabel: 'APPLICATION RECEIVED',
                statusColor: const Color(0xFF10B981),
                statusBgColor: const Color(0xFFE6FBF3),
                type: 'Job',
                appliedDate: 'Oct 15, 2026',
              ),
              // Internships
              AppliedApplicationItem(
                id: '4',
                title: 'UI/UX Design Intern',
                company: 'Canva Design Studio',
                logoUrl: 'https://img.icons8.com/color/48/canva.png',
                statusLabel: 'APPLICATION RECEIVED',
                statusColor: const Color(0xFF10B981),
                statusBgColor: const Color(0xFFE6FBF3),
                type: 'Internship',
                appliedDate: 'Oct 16, 2026',
              ),
              AppliedApplicationItem(
                id: '5',
                title: 'Data Analyst Intern',
                company: 'Microsoft',
                logoUrl: 'https://img.icons8.com/color/48/microsoft.png',
                statusLabel: 'UNDER REVIEW',
                statusColor: const Color(0xFF0088CC),
                statusBgColor: const Color(0xFFE8F4FB),
                type: 'Internship',
                appliedDate: 'Oct 17, 2026',
              ),
              AppliedApplicationItem(
                id: '6',
                title: 'Software Engineering Intern',
                company: 'Amazon',
                logoUrl: 'https://img.icons8.com/color/48/amazon.png',
                statusLabel: 'INTERVIEW SCHEDULED',
                statusColor: const Color(0xFF0088CC),
                statusBgColor: const Color(0xFFE8F4FB),
                type: 'Internship',
                appliedDate: 'Oct 18, 2026',
              ),
              // Freelance
              AppliedApplicationItem(
                id: '7',
                title: 'Full-Stack Developer (Freelance)',
                company: 'TechFlow Global',
                logoUrl: 'https://img.icons8.com/color/48/code.png',
                statusLabel: 'UNDER REVIEW',
                statusColor: const Color(0xFF0088CC),
                statusBgColor: const Color(0xFFE8F4FB),
                type: 'Freelance',
                appliedDate: 'Oct 19, 2026',
              ),
              AppliedApplicationItem(
                id: '8',
                title: 'Figma UI Specialist (Freelance)',
                company: 'DesignCraft',
                logoUrl: 'https://img.icons8.com/color/48/figma--v1.png',
                statusLabel: 'PROPOSAL SUBMITTED',
                statusColor: const Color(0xFF10B981),
                statusBgColor: const Color(0xFFE6FBF3),
                type: 'Freelance',
                appliedDate: 'Oct 20, 2026',
              ),
            ],
            completedInterviews: [
              CompletedInterviewItem(
                id: '1',
                title: 'Frontend Developer Technical Assessment',
                company: 'Google',
                date: 'Oct 10, 2026',
                score: '92/100',
                interviewer: 'Sarah Jenkins (Senior Recruiter)',
                status: 'PASSED',
              ),
              CompletedInterviewItem(
                id: '2',
                title: 'UI/UX System Design Interview',
                company: 'Airbnb',
                date: 'Oct 05, 2026',
                score: '88/100',
                interviewer: 'David Chen (Staff Engineer)',
                status: 'PASSED',
              ),
            ],
            resumeState: UserResumeState(
              fileName: 'Alex_Professional_Resume_2026.pdf',
              fileSize: '2.4 MB',
              uploadDate: 'Oct 12, 2026 at 02:30 PM',
              atsScore: 88,
              skills: ['React', 'TypeScript', 'Tailwind CSS', 'Figma', 'UI/UX Design', 'Node.js', 'REST APIs'],
              experiences: [
                'Senior Frontend Developer at TechCorp (2023 - Present)',
                'UI/UX Design Intern at Canva (2022 - 2023)'
              ],
            ),
          ),
        );

  void addApplication({
    required String title,
    required String company,
    String? logoUrl,
    required String type,
  }) {
    final newItem = AppliedApplicationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      company: company,
      logoUrl: logoUrl ?? 'https://img.icons8.com/color/48/briefcase.png',
      statusLabel: 'APPLICATION RECEIVED',
      statusColor: const Color(0xFF10B981),
      statusBgColor: const Color(0xFFE6FBF3),
      type: type,
      appliedDate: 'Just Now',
      isActive: true,
    );
    state = state.copyWith(
      appliedApplications: [newItem, ...state.appliedApplications],
    );
  }

  void addCompletedInterview({
    required String title,
    required String company,
    required String interviewer,
    String score = '95/100',
  }) {
    final newInterview = CompletedInterviewItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      company: company,
      date: 'Just Completed',
      score: score,
      interviewer: interviewer,
      status: 'COMPLETED',
    );
    state = state.copyWith(
      completedInterviews: [newInterview, ...state.completedInterviews],
    );
  }

  void uploadResume({
    required String fileName,
    required String fileSize,
    int? atsScore,
    List<String>? newSkills,
  }) {
    state = state.copyWith(
      resumeState: state.resumeState.copyWith(
        fileName: fileName,
        fileSize: fileSize,
        uploadDate: 'Just Now',
        atsScore: atsScore ?? 92,
        skills: newSkills ?? state.resumeState.skills,
      ),
    );
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (state.resumeState.skills.contains(skill.trim())) return;
    final updatedSkills = [...state.resumeState.skills, skill.trim()];
    state = state.copyWith(
      resumeState: state.resumeState.copyWith(skills: updatedSkills),
    );
  }
}

final careerStateProvider =
    StateNotifierProvider<CareerNotifier, CareerState>(
  (ref) => CareerNotifier(),
);
