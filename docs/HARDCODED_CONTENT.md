# Hardcoded Content and Backend Notes

Snapshot from a codebase review on 2026-11-08. Counts may change as content is added.

## Firebase and backend

**The app doesn't use Firebase.** There's no Firebase package in `pubspec.yaml` and no
Firebase code in `lib/`. The only mention is an outdated comment in
`android/app/src/main/AndroidManifest.xml` about a "planned Firebase integration."

- The app has no backend or accounts.
- User data is stored on the device with `shared_preferences`, which fits the PRD's
  "Works offline, always" principle.
- The only web link is the privacy policy, passed to `url_launcher` from the Profile screen.
- Optional backup (PRD 7.12) isn't built. `POST_MVP_BACKLOG.md` suggests the user's own
  iCloud or Google Drive rather than Firebase. Adding backup means updating the privacy
  policy and App Store privacy answers.

## Hardcoded content

Nearly all of the app's content is compiled in, so changing it requires a new app release.

| Content | What's included | File |
|---|---|---|
| Scripture library | 36 verses across 15 categories | `lib/features/scripture/data/scripture_library.dart` |
| Prayer library | 12 guided prayers, each with a verse and reflection prompt | `lib/features/prayer/data/prayer_library.dart` |
| Rescue flow | 10 temptation categories, about 30 verses, category prayers and 8 suggested actions | `lib/features/rescue/data/rescue_content.dart` |
| Recovery flow | 1 John 1:9 and a prayer of return | `lib/features/rescue/data/rescue_content.dart` |
| Armour of God | 6 pieces, each with an explanation, verse and reflection | `lib/features/armour/data/armour_content.dart` |
| Focus sessions | 5 modes with prompts and verses, plus 5, 10, 15 and 30 minute presets | `lib/features/focus/data/focus_content.dart` |
| Onboarding | 10 focus areas and 7 goals | `lib/features/onboarding/data/onboarding_options.dart` |
| Default habits | 11 starter habits, 4 of them on by default, plus the goal-to-habit mapping | `lib/shared/providers/habit_providers.dart` |
| App text and links | App name, tagline, welcome text, privacy note, grace lines and privacy policy URL | `lib/core/constants/app_strings.dart` |
| Crisis message | The "contact your local emergency services" note | `lib/features/rescue/widgets/crisis_support_note.dart` |
| Theme colors | The app's color constants | `lib/core/constants/app_colors.dart` |

**Text inside screens:** many labels and headings are written directly in the screen widgets
rather than in `AppStrings`, especially in the Rescue flow, Profile, Focus and Journal
screens. This would make translating the app harder later.

**Not hardcoded:** the user's profile, journal entries, habit changes, saved verses, and
mood, rescue and focus history are all created by the user and saved on the device.

## Open item before release

The main Android manifest requests the `INTERNET` permission only for the planned Firebase
work, and its own comment says the app doesn't need it today. Consider removing the
permission and comment, which also better matches the privacy claim that data stays on the
device. First check that the debug and profile manifests declare their own copy so hot
reload keeps working.
