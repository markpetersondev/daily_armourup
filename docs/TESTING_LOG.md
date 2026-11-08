# Testing Log and Feature Gaps

Add a new dated section under [Test sessions](#test-sessions) for each round of testing.
Keep [Open issues](#open-issues) and [Feature gaps](#feature-gaps) current.

## Test sessions

### 8 Nov 2026: Android device, bug fixes

**Result:** passed. The fixes behave correctly on the phone, and no overflow warnings
appeared in the screenshots reviewed. These fixes haven't been run on iOS.

Same phone and debug build setup as the session below, on commit `a95e011` plus the fixes.

| Fix | Checked on the phone | Result |
|---|---|---|
| Focus reflection | 1-minute session; the reflection appears in the Journal as "Prayer reflection" | Pass |
| Plural | "Begin 1 minute" and "You stayed present for 1 minute" | Pass |
| Write a prayer | Opens a new Journal entry | Pass |
| Leaving Rescue early | Close button and back gesture each count once; stat reads "2 times, Reached for help" | Pass |
| Step 4: Read another verse | Returns to the Scripture step with a new verse | Pass |
| Step 4: accountability message | Shows the message sheet, then returns to step 4 | Pass |
| Step 4: Write in journal | Opens a new entry, and back returns to step 4 | Pass |
| Step 4: Start a focus session | Opens Sacred Focus | Pass |
| Text at 100%, 130% and 200% | Quick actions show full labels and grow with the text | Pass |
| Text at 130% and 200% | Bottom navigation labels stay readable, chips aren't clipped | Pass |

Leaving Recovery early is covered by an automated test, not checked on the phone.
`flutter test` now runs 8 tests, including new ones in `test/rescue_and_focus_test.dart`.

### 8 Nov 2026: Android device, full feature pass

**Result:** the core features work and no crashes occurred. It found 4 behaviour bugs and
layout problems at large text sizes, since fixed (see the session above).

| Item | Details |
|---|---|
| Device | Samsung SM A065F, Android 14, 720 × 1600 |
| Build | Debug APK, not a release build |
| Code | Commit `a95e011` |
| Tools | Real taps sent over `adb`, plus reviewing screenshots |
| Test data | Name "Sam", cleared at the end. Phone settings were restored afterwards |

**Flows tested:**

| Area | Steps | Result |
|---|---|---|
| Home | Save verse, mood check-in, Reflect | Pass |
| Journal | Create with type, mood and attached verse; reopen; edit | Pass |
| Journal | Type filter, search, no-match search, Answered tab | Pass |
| Journal | Delete: "Keep it" and confirm | Pass |
| Scripture | Category filter; search by reference and by word; no-match search | Pass |
| Scripture | Save, remove from saved, copy, add note, view note on Saved tab | Pass, see the double Copy message |
| Memory | Quiz with a wrong answer, all correct, capitals accepted, new words each retry | Pass |
| Memory | Status buttons | Tapped only; the status wasn't confirmed afterwards |
| Practices | Mark complete, week view and streak update, turn one on in Manage | Pass |
| Practices | Add, edit and delete a custom practice | Pass |
| Sacred Focus | Custom 1-minute session, pause, resume, end screen, reflection, Finish | Pass, with 2 issues |
| Prayer | Open, bookmark, Pray Now, back navigation | Pass |
| Rescue | "Read another verse", "Save verse", prayer next line and pause | Pass |
| Rescue | "Yes, I feel stronger" and "I still need help" | Pass, with 2 issues |
| Rescue | Accountability message: view and copy | Pass |
| Rhythm | Stats update from the activity above, including most common mood | Pass |
| Offline | Airplane mode, cold start, Home, Scripture, Rescue up to the prayer | Pass, fonts load offline |
| Privacy Policy link | Opens in the browser while online | Pass |
| Dark mode | Home, Scripture, Journal, Rescue | Pass, readable throughout |
| Text at 130% | Home, Rhythm, Journal | Minor issues |
| Text at 200% | Home, Scripture, Journal, Profile, Rescue start | Layout issues |

The Android logs didn't show the layout overflow that was visible on screen at 200%, so
log searches can't be relied on to catch overflow. Check screenshots of debug builds
instead, which show overflow as striped warnings.

### 8 Nov 2026: Android device, visual fixes

**Result:** passed. No crashes or font errors, and the screenshots reviewed showed no
overflow warnings.

Same phone and debug build setup as the session below, on commit `cdf8a8e` plus the
uncommitted fixes.

| Check | Result |
|---|---|
| Home verse card | Pass, shows Save and Reflect only, and the layout holds |
| Stat numbers on Home and Your Spiritual Rhythm | Pass, "0" no longer looks like "O" |
| Sacred Focus options | Pass, Ambient sound gone, Verse prompt still there |
| Starting a Focus session | Pass, timer counts down with full-height digits, no sound icon |
| Onboarding after a reset | Pass, 5 steps |

Only the first few seconds of a Focus session were run, not a full one. These fixes
haven't been run on iOS.

### 8 Nov 2026: Android device

**Result:** passed, with one visual issue (numerals, since fixed). No crashes or font
errors appeared. The log search for overflow turned out to be unreliable (see the full
feature pass), but the screenshots reviewed showed no overflow warnings.

| Item | Details |
|---|---|
| Device | Samsung SM A065F, Android 14, 720 × 1600 |
| Build | Debug APK, not a release build |
| Code | Commit `6d77a54` plus the uncommitted reminder-hiding changes |
| Tools | Flutter 3.38.4, real taps sent over `adb`, screenshots and `logcat` |
| Test data | Name "Sam", erased at the end by Reset all app data |

**Flows tested:**

| Flow | Steps | Result |
|---|---|---|
| Build and install | Debug APK with upgraded Gradle, AGP and Kotlin, then install and launch | Pass |
| Onboarding | Welcome, name, focus areas, goals, Ready, enter app | Pass, 5 steps with no reminders step |
| Home | Scroll to the bottom | Pass, ends at Quick actions with no "Coming up" card |
| Rescue | Open, scroll, choose "Something else", skip breathing, Scripture, prayer, choose "Drink water", check-in | Pass, no crisis note |
| Recovery | Choose "I slipped", scroll, tap Begin Again | Pass, no crisis note, returns to Home |
| Profile | Scroll the full screen | Pass, no journal lock toggle |
| Edit Profile | Open, scroll, Save Changes | Pass, no Reminders section |
| Persistence | Force-close and reopen | Pass, name and onboarding state kept |
| Licences | Open the page, scroll to the fonts | Pass, Flutter packages, Inter and Playfair Display all listed |
| Reset all app data | Confirm "Delete everything" | Pass, returns to onboarding |

**Opened and checked visually only:** Scripture, Journal, Your Spiritual Rhythm, Sacred
Focus, Pray Now and My Armour.

### 8 Nov 2026: iOS simulator

**Result:** passed for the changes tested at the time.

| Item | Details |
|---|---|
| Device | iPhone 15 Pro simulator, iOS 17.2 |
| Build | Debug, Xcode 15.1, which Apple won't accept for App Store upload |
| Code | Before the crisis note and reminder UI were hidden |
| Tools | Temporary Flutter integration test with in-app screenshots, then removed |

**Flows tested:**

| Flow | Result |
|---|---|
| App launch, with Playfair fonts loading | Pass |
| Rescue and Recovery with the crisis note visible (now hidden) | Pass |
| Prayer detail, guided prayer in Playfair | Pass |
| Profile: journal lock toggle removed, licences item added | Pass |
| Licences page, including the Playfair licence text | Pass |
| Built app settings: portrait only, iPhone only, iOS 15.0, encryption declared as not used | Pass |

Because the test started the app in a test environment, navigation used routes rather
than real taps. The reminder-hiding changes haven't been run on iOS. They passed a
temporary widget test instead.

### 8 Nov 2026: automated checks

Run after the reminder UI was hidden:

- `flutter analyze`: 2 deprecation notices, in `profile_screen.dart`, and nothing else.
- `flutter test`: all 5 tests pass. That covers app launch and persistence only, so
  most features have no automated tests.
- Temporary widget tests, since deleted: 5 onboarding steps, no "Coming up" card, no
  Reminders section in Edit Profile.

## Not tested yet

**Before App Store submission:**

- [ ] Real iPhone. It wasn't usable with Xcode 15.1
- [ ] Build with Xcode 26 or later, and retest after the macOS, Xcode and Flutter upgrade
- [ ] iOS release build, archive upload and TestFlight
- [ ] Reminder-hiding changes and the visual fixes on iOS
- [ ] Launch screen colour on iOS, which shows too briefly for the test to capture
- [ ] Rotating an iPhone (the portrait setting is confirmed in the build only)
- [ ] App running on iPad in iPhone compatibility mode
- [ ] Small iPhones (iPhone SE)
- [ ] All Android-only results above on iOS: offline, dark mode and large text

**App behaviour, on either platform:**

- [ ] VoiceOver and TalkBack
- [ ] Streaks and stats across a day or week change, and time zone changes
- [ ] Data surviving an app update

**Features not fully exercised:**

- [ ] Journal: 4 of the 6 entry types (Gratitude and Answered Prayer were tested)
- [ ] Journal: the Temptation Trigger type in particular
- [ ] Memory: confirming a status change sticks
- [ ] Practices: drag to reorder, and turning a practice off
- [ ] Sacred Focus: other modes, ending early, and turning off the verse prompt
- [ ] Rescue: categories other than Something else, Anxiety and Anger
- [ ] Rescue: "Start a focus session" and "Begin the rescue flow again" from "I still need help"
- [ ] Privacy Policy link with no connection: it opened Chrome, but the page wasn't reviewed

**Android, when that release resumes:**

- [ ] Release build with the current code. The last bundle is from 29 Aug 2026
- [ ] Landscape. The app isn't locked to portrait on Android

## Open issues

| Issue | Where | Severity | Status |
|---|---|---|---|
| Recovery's optional notes are saved but never shown anywhere, so users can't read what they wrote. Found in the code, not on the phone | `note` in `recovery_screen.dart` | High | Open |
| "Memory" tab label cut off at 200% text | Scripture | Low | Open |
| Copy shows two messages on Android: "Copied to clipboard" overlaps "Verse copied" | Scripture | Low | Open, Android only |
| "Reflect" opens the Journal list instead of a new entry | Home verse card | Low | Open |
| Mixed spelling: "armour" in headings, "armor" in verses | My Armour and elsewhere | Low | Open, depends on the Scripture translation decision |
| Deprecated radio properties | `profile_screen.dart:174` | Low | Open |

## Feature gaps

Features described in the PRD or shown in the app that aren't available in the MVP.
[POST_MVP_BACKLOG.md](POST_MVP_BACKLOG.md) has the details for bringing each one back.

| Feature | State | Decision |
|---|---|---|
| Reminders (PRD 7.11) | UI built but hidden, and no notifications are sent | Post-MVP, see [IOS_SETUP.md](IOS_SETUP.md) step 4.6 |
| Backup (PRD 7.12) | Not built | Post-MVP, removed from the App Store description |
| Journal Privacy Lock | Toggle saved a setting but locked nothing, now removed | Removed for v1; needs `local_auth` if built later |
| Crisis support note | Built but hidden | Post-MVP, see [IOS_SETUP.md](IOS_SETUP.md) step 4.9 |
| Verse sharing | Placeholder button removed | Out of scope for v1, as the PRD states |
| Ambient sound (PRD 7.7) | Toggle played no audio, now removed | Post-MVP; needs an audio package and sounds |
| iPad layout | Not supported on iOS | iPhone only for v1 |

## Remaining release blockers

| Blocker | Who | Status |
|---|---|---|
| Scripture licence: wording looks like the NIV, with no attribution | Owner decision | Open |
| Apple Developer Program enrollment | Owner | Not confirmed |
| macOS, Xcode and Flutter upgrade | Owner | Not started |
| Privacy policy rewrite, because the live text doesn't match the app | Owner | Open |
| Support page | Owner | Open |
| App Store screenshots | After the upgrade | Open |
| Crisis sentence in the App Store description: keep or remove | Owner | Open |
