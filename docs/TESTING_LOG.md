# Testing Log and Feature Gaps

Add a new dated section under [Test sessions](#test-sessions) for each round of testing.
Keep [Open issues](#open-issues) and [Feature gaps](#feature-gaps) current.

## Test sessions

### 8 Nov 2026: Android device

**Result:** passed, with one visual issue (numerals, see [Open issues](#open-issues)).
No crashes, font errors or layout overflow errors appeared in the logs.

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
- [ ] Reminder-hiding changes on iOS
- [ ] Launch screen colour on iOS, which shows too briefly for the test to capture
- [ ] Rotating an iPhone (the portrait setting is confirmed in the build only)
- [ ] App running on iPad in iPhone compatibility mode
- [ ] Small iPhones (iPhone SE)

**App behaviour, on either platform:**

- [ ] Airplane mode. The Android phone stayed on Wi-Fi, so offline use is unconfirmed
- [ ] Dark mode
- [ ] Largest text size
- [ ] VoiceOver and TalkBack
- [ ] Privacy Policy link opening
- [ ] Streaks and stats across a day or week change, and time zone changes

**Features not exercised:**

- [ ] Journal: create, edit and delete entries, and each entry type
- [ ] Scripture: search, filters, saving, copying, notes and memory quiz
- [ ] Practices: tracking, adding and editing habits
- [ ] Sacred Focus: running a full session
- [ ] Prayer library: browsing and saving
- [ ] Mood check-in on Home
- [ ] Home verse: Save, Share and Reflect
- [ ] Rescue: "Yes, I feel stronger" and "I still need help" outcomes
- [ ] Rescue: "Read another verse", "Save verse", and the other actions
- [ ] Recovery: saving the optional reflection notes

**Android, when that release resumes:**

- [ ] Release build with the current code. The last bundle is from 29 Aug 2026
- [ ] Landscape. The app isn't locked to portrait on Android

## Open issues

| Issue | Where | Severity | Status |
|---|---|---|---|
| Playfair's old-style numerals make "0" look like the letter O and "1" like a small capital I | Stat tiles on Home and Your Spiritual Rhythm | Medium, visible on main screens | Open, side effect of the font fix |
| Share button only shows "Sharing is on its way in a coming update." | Home verse card, `home_screen.dart:50` | High, placeholder that App Review could reject | Open |
| "Ambient sound" toggle plays no sound, only showing an icon during the session. The app has no audio package | Sacred Focus, `focus_screen.dart:142` | High, misleading and App Review could reject it | Open |
| Labels cut off on a small phone: "Start Focus Sessi…" and "See your faithful ste…" | Home Quick actions | Low | Open |
| Mixed spelling: "armour" in headings, "armor" in verses | My Armour and elsewhere | Low | Open, depends on the Scripture translation decision |
| Deprecated radio properties | `profile_screen.dart:174` | Low | Open |

## Feature gaps

Features described in the PRD or shown in the app that aren't available in the MVP.

| Feature | State | Decision |
|---|---|---|
| Reminders (PRD 7.11) | UI built but hidden, and no notifications are sent | Post-MVP, see [IOS_SETUP.md](IOS_SETUP.md) step 4.6 |
| Backup (PRD 7.12) | Not built | Post-MVP, removed from the App Store description |
| Journal Privacy Lock | Toggle saved a setting but locked nothing, now removed | Removed for v1; needs `local_auth` if built later |
| Crisis support note | Built but hidden | Post-MVP, see [IOS_SETUP.md](IOS_SETUP.md) step 4.9 |
| Verse sharing | Placeholder message only | Not decided |
| Ambient sound | Toggle with no audio | Not decided |
| iPad layout | Not supported on iOS | iPhone only for v1 |

The PRD lists sharing as out of scope for v1, so the Share button could simply be removed.

## Remaining release blockers

| Blocker | Who | Status |
|---|---|---|
| Scripture licence: wording looks like the NIV, with no attribution | Owner decision | Open |
| Apple Developer Program enrollment | Owner | Not confirmed |
| macOS, Xcode and Flutter upgrade | Owner | Not started |
| Privacy policy rewrite, because the live text doesn't match the app | Owner | Open |
| Support page | Owner | Open |
| App Store screenshots | After the visual fixes | Open |
| Share button and ambient sound decisions | Owner | Open |
| Crisis sentence in the App Store description: keep or remove | Owner | Open |
