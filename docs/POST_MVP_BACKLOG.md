# Post-MVP Backlog

Features removed, hidden or left out of the MVP release, to consider afterwards. None of
these are committed plans. Last updated 8 Nov 2026.

| Feature | State in the MVP | Effort to add | Code to bring back |
|---|---|---|---|
| [Reminders](#reminders) | Hidden | Medium | Commented out, plus new code |
| [Crisis support note](#crisis-support-note) | Hidden | Very small | Commented out |
| [Verse sharing](#verse-sharing) | Removed | Small | `5cd7386` (button only) |
| [Ambient sound](#ambient-sound) | Removed | Medium | `5cd7386` (toggle only) |
| [Journal Privacy Lock](#journal-privacy-lock) | Removed | Small to medium | `c44ac0c` (toggle only) |
| [Backup](#backup) | Never built | Large | None |
| [iPad support](#ipad-support) | iPhone only | Medium | Project settings |

To see what a commit removed, run `git show <commit>`.

## Reminders

**What it does:** up to four daily notifications at times the user chooses. See PRD 7.11.

**Why it's out:** the settings existed, but nothing ever sent a notification.

**What exists:** the UI is commented out, marked "Hidden for the MVP release", in
`onboarding_screen.dart`, `home_screen.dart` and `edit_profile_screen.dart`. Saved
preferences are still in the profile data.

**To add it:** follow [IOS_SETUP.md](IOS_SETUP.md) step 4.6.

**Watch out for:**
- `flutter_local_notifications` needs newer Android build tools than the project has
  (AGP 8.11.1+, Java 17 with desugaring).
- It needs an edit to `AppDelegate.swift`, so do the Flutter upgrade and UIScene
  migration first if they haven't been done.
- Keep the notification text generic, so nothing private shows on the lock screen.

## Crisis support note

**What it does:** a short line on Rescue and Recovery pointing people in danger to local
emergency services or someone they trust.

**Why it's out:** owner decision for the MVP.

**What exists:** `lib/features/rescue/widgets/crisis_support_note.dart` is finished.

**To add it:** uncomment the marked lines in `rescue_screen.dart` and
`recovery_screen.dart`. See [IOS_SETUP.md](IOS_SETUP.md) step 4.9.

**Watch out for:** turn this on first if App Review raises it. Rescue covers anxiety,
addiction and negative thoughts, so this is the first item to reconsider after launch.

## Verse sharing

**What it does:** would let users share a verse from the Home verse card.

**Why it's out:** the button only showed "Sharing is on its way in a coming update." The
PRD also lists sharing as out of scope for v1.

**What exists:** nothing useful. Commit `5cd7386` removed the button.

**To add it:** add a package such as `share_plus`, and restore the button in
`verse_card.dart` and `home_screen.dart`.

**Watch out for:** share only the verse text and reference, and never anything from the
user's private data. The PRD's "no social features" principle needs revisiting first.

## Ambient sound

**What it does:** would play gentle background audio during Sacred Focus sessions. See
PRD 7.7.

**Why it's out:** the toggle played no sound, and only showed a small icon during the
session.

**What exists:** nothing useful. Commit `5cd7386` removed the toggle and the setting.

**To add it:** add an audio package, license or create the sounds, restore the toggle in
`focus_screen.dart`, and play audio from `focus_session_screen.dart`.

**Watch out for:**
- Bundle the audio so it works offline, which will increase the app size.
- Confirm the licence for every sound.
- Decide how it behaves with the silent switch and when the app is in the background.

## Journal Privacy Lock

**What it does:** would ask for Face ID, fingerprint or a passcode before opening the
journal.

**Why it's out:** the toggle saved a setting, but the journal never checked it, so users
could believe their journal was protected when it wasn't.

**What exists:** `journalLockEnabled` is still in `user_profile.dart`, so saved data loads
correctly. Commit `c44ac0c` removed the toggle from `profile_screen.dart`.

**To add it:** add `local_auth` and an `NSFaceIDUsageDescription` entry in `Info.plist`,
restore the toggle, and check the lock whenever the journal opens.

**Watch out for:** this only controls access inside the app and doesn't encrypt anything.
PRD section 10 separately suggests encrypting journal entries.

## Backup

**What it does:** an optional private backup and restore, with no account needed. See PRD
7.12.

**Why it's out:** it was never built, and it's the largest item here. The app also has to
work fully without it.

**What exists:** nothing.

**To add it:** first choose where backups are stored without an account system, such as
the user's own iCloud or Google Drive.

**Watch out for:**
- Adding this changes the App Store privacy answers and the privacy policy, which both
  say data stays on the device.
- Until then, deleting the app or changing phones can lose the user's data, apart from
  any copy in their own device backup. The support page should say so.

## iPad support

**What it does:** would let the app run as a proper iPad app.

**Why it's out:** it would need iPad screenshots and iPad layout testing.

**What exists:** v1 is iPhone only, and it still opens on iPads in compatibility mode.

**To add it:** set `TARGETED_DEVICE_FAMILY` back to `"1,2"`, restore the iPad orientations
in `Info.plist`, test the layouts, and add 13-inch iPad screenshots.
