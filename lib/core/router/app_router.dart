import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/armour/presentation/armour_screen.dart';
import '../../features/disciplines/presentation/disciplines_screen.dart';
import '../../features/disciplines/presentation/habit_editor_screen.dart';
import '../../features/focus/presentation/focus_screen.dart';
import '../../features/focus/presentation/focus_session_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/journal/presentation/journal_entry_editor_screen.dart';
import '../../features/journal/presentation/journal_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/prayer/presentation/prayer_detail_screen.dart';
import '../../features/prayer/presentation/prayer_library_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/rescue/data/rescue_content.dart';
import '../../features/rescue/presentation/recovery_screen.dart';
import '../../features/rescue/presentation/rescue_flow_screen.dart';
import '../../features/rescue/presentation/rescue_screen.dart';
import '../../features/scripture/presentation/memory_quiz_screen.dart';
import '../../features/scripture/presentation/scripture_screen.dart';
import '../../shared/models/focus_session.dart';
import '../../shared/models/journal_entry.dart';
import '../../shared/models/saved_verse.dart';
import '../../shared/providers/app_providers.dart';
import 'app_shell.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const scripture = '/scripture';
  static const rescue = '/rescue';
  static const journal = '/journal';
  static const profile = '/profile';
  static const focus = '/focus';
  static const focusSession = '/focus/session';
  static const rescueFlow = '/rescue/flow';
  static const rescueRecovery = '/rescue/recovery';
  static const prayers = '/prayers';
  static const memoryQuiz = '/scripture/memory-quiz';
  static const journalNew = '/journal/new';
  static const disciplines = '/disciplines';
  static const disciplinesNew = '/disciplines/new';
  static const progress = '/progress';
  static const profileEdit = '/profile/edit';
  static const armour = '/profile/armour';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // Redirect reads the latest profile on each navigation; watching the
  // provider itself would rebuild the router and reset navigation state.
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final onboarded = ref.read(userProfileProvider).onboardingCompleted;
      final goingToOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!onboarded && !goingToOnboarding) return AppRoutes.onboarding;
      if (onboarded && goingToOnboarding) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.focus,
        builder: (context, state) => const FocusScreen(),
      ),
      GoRoute(
        path: AppRoutes.focusSession,
        builder: (context, state) {
          final config = state.extra is FocusSessionConfig
              ? state.extra as FocusSessionConfig
              : const FocusSessionConfig(
                  mode: FocusMode.prayer,
                  duration: Duration(minutes: 10),
                  showVerse: true,
                );
          return FocusSessionScreen(config: config);
        },
      ),
      GoRoute(
        path: AppRoutes.rescueFlow,
        builder: (context, state) => RescueFlowScreen(
          category: state.extra is RescueCategory
              ? state.extra as RescueCategory
              : RescueCategory.other,
        ),
      ),
      GoRoute(
        path: AppRoutes.rescueRecovery,
        builder: (context, state) {
          final extra = state.extra is Map ? state.extra as Map : const {};
          return RecoveryScreen(
            category: extra['category'] is RescueCategory
                ? extra['category'] as RescueCategory
                : RescueCategory.other,
            selectedAction: extra['selectedAction'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.prayers,
        builder: (context, state) => const PrayerLibraryScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => PrayerDetailScreen(
              prayerId: state.pathParameters['id'] ?? '',
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.journalNew,
        builder: (context, state) => JournalEntryEditorScreen(
          initialType: state.extra is JournalEntryType
              ? state.extra as JournalEntryType
              : null,
        ),
      ),
      GoRoute(
        path: '/journal/edit/:id',
        builder: (context, state) => JournalEntryEditorScreen(
          entryId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: AppRoutes.disciplines,
        builder: (context, state) => const DisciplinesScreen(),
      ),
      GoRoute(
        path: AppRoutes.disciplinesNew,
        builder: (context, state) => HabitEditorScreen(
          habitId: state.extra is String ? state.extra as String : null,
        ),
      ),
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.armour,
        builder: (context, state) => const ArmourScreen(),
      ),
      GoRoute(
        path: AppRoutes.memoryQuiz,
        builder: (context, state) => state.extra is SavedVerse
            ? MemoryQuizScreen(verse: state.extra as SavedVerse)
            : const ScriptureScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.scripture,
              builder: (context, state) => const ScriptureScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.rescue,
              builder: (context, state) => const RescueScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.journal,
              builder: (context, state) => const JournalScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
