# Testing Log and Feature Gaps

Add a new dated section under [Test sessions](#test-sessions) for each round of testing.
Keep [Open issues](#open-issues) and [Feature gaps](#feature-gaps) current.

## Test sessions

### 16 Nov 2026: accessibility pass and deprecation fix

**Result:** passed after fixes. `test/accessibility_test.dart` runs Flutter's label, 48dp
tap-target and WCAG contrast checks on all 19 screens; `flutter test` now runs 66 tests and
`flutter analyze` reports no issues. TalkBack isn't installed on the emulator (no Play
Store), so what TalkBack reads was checked through the Android accessibility tree instead.

| Finding | Fix | Checked |
|---|---|---|
| Manage Practices switches and menus had no names ("Switch, on") | Labelled "Show <practice> in today's practices" and "Options for <practice>" | Emulator accessibility tree, test |
| Secondary grey text 3.8:1 on cream (needs 4.5:1), on most screens | `mutedGray` darkened to `#626A62` (5.3:1) | Tests, emulator screenshot |
| Gold text 2:1 on light backgrounds (verse references, onboarding, armour) | New `AppColors.goldText(context)`: deeper gold `#87641F` (5.1:1) in light mode, unchanged in dark mode | Tests, emulator screenshot |
| Tap targets 44–46dp: Home Save/Reflect, mood chips, practice ticks | Raised to 48dp | Tests |
| "How is your heart today?" heading could run off screen at large text | Heading wraps | Emulator at 200% text |
| Deprecated radio properties in Profile | Moved to `RadioGroup` | `flutter analyze` |

**Known exceptions:**

- Week-day cells on Practices are 46dp wide on a 360dp phone: seven can't fit at 48dp.
  They only show a summary that their label already reads out.
- Rescue's "Continue" is low contrast while disabled during breathing; WCAG exempts
  inactive controls.

**Still to do:** a real TalkBack pass on the Samsung, and VoiceOver on iPhone.

### 15 Nov 2026: untested features, before the day-7 update

**Result:** 3 bugs found and fixed, everything else passed. `flutter test` now runs 47 tests
(35 new in `test/feature_coverage_test.dart`) and they also pass with
`TZ=America/New_York`. Emulator: Pixel (API 34), debug build.

**Bugs found and fixed:**

| Bug | How it was found | Fix |
|---|---|---|
| Left open overnight, the app kept showing yesterday's verse and mood check-in (and today's ticks, streaks and suggestions) until restarted | Emulator: checked in, moved the clock to the next day, resumed the app | New `todayProvider` refreshes at midnight and when the app resumes; date-based providers watch it. Rechecked on the emulator: resuming the next day shows the new verse and an empty check-in |
| Daily streaks reset once a year in daylight-saving timezones (US, Canada, Europe, Australia): stepping back one day from the day after clocks go forward skipped a day | Script run with `TZ=America/New_York` | Calendar-day helpers in `lib/core/utils/dates.dart` replace `Duration(days: n)` arithmetic everywhere; covered by tests |
| "Resist Distraction" label at the top of a Focus session could overflow at large text sizes | Widget test layout error | Label wraps instead |

**Checked:**

| Area | How | Result |
|---|---|---|
| Journal: all 6 entry types, including Temptation Trigger | Widget tests: create each type; edit keeps the type | Pass |
| Memory: status change persists | Existing persistence test | Pass |
| Practices: drag to reorder | Emulator: long-press drag, then restart | Pass, order kept and shown on Practices |
| Practices: switch off | Emulator, then restart; plus tests | Pass, hidden from today and the week view, history kept |
| Sacred Focus: all 5 modes, verse prompt on and off, ending early | Widget tests (10 cases) | Pass, early sessions saved as not completed |
| Sacred Focus timer with screen off (60 s) and app in background (60 s) | Emulator | Pass, timer kept real time |
| Rescue: all 10 categories through the full flow | Widget tests | Pass, each saves one session |
| Rescue "I still need help": Begin again, Start a focus session | Widget tests | Pass |
| Streaks and stats across a day change | Emulator clock change plus tests | Pass after the fixes above |
| Data survives an app update | Emulator: data entered, then newer builds installed over it | Pass |

**Still to check:** the Focus timer when the app is in the background on iOS, where apps are
suspended; and TalkBack. On Android the switches in Manage Practices are not announced with
the practice's name to UI automation, which suggests TalkBack may only say "Switch, on".

### 8 Nov 2026: Scripture replaced with the Berean Standard Bible

**Result:** passed. All 100 quotations across 66 references match the official file, checked
by script, and old wording is gone. `flutter test` passes. iOS not run.

Checked on the Samsung (debug build): the verse on Home, the longest Rescue verse
(1 Corinthians 10:13), Scripture search, the My Armour list, the Scripture credit in
Profile, and the memory quiz on a verse with a dash.

The quiz now skips words joined by a dash, such as "salvation—whom". Not every verse was
viewed on screen, and no one has read through the new wording in context yet.

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
- [x] Streaks and stats across a day or week change, and time zone changes (15 Nov 2026)
- [x] Data surviving an app update (15 Nov 2026, Android)

**Features not fully exercised:**

- [x] Journal: 4 of the 6 entry types (Gratitude and Answered Prayer were tested)
- [x] Journal: the Temptation Trigger type in particular
- [x] Memory: confirming a status change sticks
- [x] Practices: drag to reorder, and turning a practice off
- [x] Sacred Focus: other modes, ending early, and turning off the verse prompt
- [x] Rescue: categories other than Something else, Anxiety and Anger
- [x] Rescue: "Start a focus session" and "Begin the rescue flow again" from "I still need help"
- [ ] Privacy Policy link with no connection: it opened Chrome, but the page wasn't reviewed

**Android, when that release resumes:**

- [ ] Release build with the current code. The last bundle is from 29 Aug 2026
- [x] Landscape. Locked to portrait on 15 Nov 2026; checked on the emulator with rotation forced to landscape

## Open issues

| Issue | Where | Severity | Status |
|---|---|---|---|
| Recovery's optional notes are saved but never shown anywhere, so users can't read what they wrote. Found in the code, not on the phone | `note` in `recovery_screen.dart` | High | Fixed 15 Nov 2026: notes now also saved to the Journal as a Temptation Trigger entry. Checked on the Pixel 3a emulator (API 34, debug build): entry shows in the Journal and survives an app restart |
| "Memory" tab label cut off at 200% text | Scripture | Low | Fixed 15 Nov 2026: tabs scroll above 1.3x text. Checked on the Pixel emulator (API 34) at 200% text, where all three labels show in full, and by a widget test |
| Copy shows two messages on Android: "Copied to clipboard" overlaps "Verse copied" | Scripture | Low | Fixed 15 Nov 2026: the app's message is skipped on Android 13+, where the system confirms. Checked on the Pixel emulator (API 34). Rescue's "Message copied. You are not alone." is unchanged on purpose |
| "Reflect" opens the Journal list instead of a new entry | Home verse card | Low | Fixed 15 Nov 2026: opens a new Reflection entry with the verse attached. Checked on the emulator and by a widget test |
| Mixed spelling: "armour" in headings, "armor" in verses | My Armour and elsewhere | Low | Won't fix: "Armour" is part of the app name and verses must keep the Berean "armor" |
| Deprecated radio properties | `profile_screen.dart:174` | Low | Fixed 16 Nov 2026: moved to `RadioGroup` |

## Feature gaps

Features described in the PRD or shown in the app that aren't available in the MVP.
[POST_MVP_BACKLOG.md](../product/POST_MVP_BACKLOG.md) has the details for bringing each one back.

| Feature | State | Decision |
|---|---|---|
| Reminders (PRD 7.11) | UI built but hidden, and no notifications are sent | Post-MVP, see [IOS_SETUP.md](../ios/IOS_SETUP.md) step 4.6 |
| Backup (PRD 7.12) | Not built | Post-MVP, removed from the App Store description |
| Journal Privacy Lock | Toggle saved a setting but locked nothing, now removed | Removed for v1; needs `local_auth` if built later |
| Crisis support note | Built but hidden | Post-MVP, see [IOS_SETUP.md](../ios/IOS_SETUP.md) step 4.9 |
| Verse sharing | Placeholder button removed | Out of scope for v1, as the PRD states |
| Ambient sound (PRD 7.7) | Toggle played no audio, now removed | Post-MVP; needs an audio package and sounds |
| iPad layout | Not supported on iOS | iPhone only for v1 |

## Remaining release blockers

| Blocker | Who | Status |
|---|---|---|
| Prayers, reflections and armour text: confirm the source and review them, as the PRD requires human-written content | Owner | Open |
| Apple Developer Program enrollment | Owner | Not confirmed |
| macOS, Xcode and Flutter upgrade | Owner | Not started |
| Privacy policy rewrite, because the live text doesn't match the app | Owner | Open |
| Support page | Owner | Open |
| App Store screenshots | After the upgrade | Open |
| Crisis sentence in the App Store description: keep or remove | Owner | Open |
