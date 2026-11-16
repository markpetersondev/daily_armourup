# iOS Requirements Checklist

What Armour Up Daily needs before it can go on the App Store, and what is already done.
Status checked against the code on 16 Nov 2026.

- How to do the setup work: [IOS_SETUP.md](IOS_SETUP.md)
- How to submit: [APP_STORE_RELEASE.md](APP_STORE_RELEASE.md)

**Summary:** no app *features* are missing. Apple requires no feature the app lacks. The
remaining work is the **Mac tools upgrade**, **one project change (UIScene)**, a **support
page**, and the **App Store Connect paperwork**.

---

## 1. Already done ✅

| Requirement | Where |
|---|---|
| Minimum iOS 15.0 | Xcode project, `ios/Podfile`, `ios/Flutter/AppFrameworkInfo.plist` |
| iPhone only (`TARGETED_DEVICE_FAMILY = 1`) | Xcode project |
| Portrait only | `ios/Runner/Info.plist`, and locked in `lib/main.dart` |
| Encryption declared as not used (`ITSAppUsesNonExemptEncryption = false`) | `Info.plist` |
| Launch screen in brand green `#123D2B` | `LaunchScreen.storyboard` |
| App icon 1024px with no transparency | `Assets.xcassets/AppIcon.appiconset` |
| Display name "Armour Up Daily" | `Info.plist` |
| Bundle ID `com.hustlebluprint.armourupdaily`, team `SGA7JNW87Z` | Xcode project. **Confirm the team is your paid account** |
| Privacy policy matches the app ("Data Not Collected") | https://markpetersondev.github.io/armour-up-privacy/ |
| Privacy policy link inside the app (guideline 5.1.1) | Profile → About → Privacy Policy |
| No network use; fonts and content bundled | `GoogleFonts.config.allowRuntimeFetching = false` |
| Journal Privacy Lock removed (it locked nothing) | Profile |
| Reminders, crisis note and ambient sound hidden for v1 | See [POST_MVP_BACKLOG.md](../product/POST_MVP_BACKLOG.md) |
| Scripture licence and credit (Berean Standard Bible) | Profile → About → Scripture |
| Open-source licences, including the bundled fonts | Profile → About → Open-source licences |
| Accessibility: labels, 48dp targets, WCAG AA contrast, large text | `test/accessibility_test.dart` |

These shared fixes also apply on iOS (tested in code, not yet on an iPhone): today's verse
and check-in refresh the next day, streaks count correctly around clock changes, and Reflect
opens a new entry. The Android-only clipboard check falls back to showing "Verse copied." on
iOS, which is correct because iOS shows no system message.

---

## 2. Mandatory and not done ❌

| # | Item | Why it's required | Who |
|---|---|---|---|
| 1 | **Upgrade macOS** from 14.2.1 to Tahoe 26.x | Xcode 26+ won't install on Sonoma | You |
| 2 | **Upgrade Xcode** from 15.1 to 26 or later | Apple rejects uploads built with older Xcode | You |
| 3 | **Upgrade Flutter** from 3.38.4 to 3.41+, and CocoaPods to 1.16.2 | Needed to build with the new Xcode, and for #4 | You |
| 4 | **UIScene migration** | Apps built with the iOS 27 SDK crash on launch without it. Flutter 3.41+ migrates automatically (IOS_SETUP step 4.1) | Code |
| 5 | **Apple Developer Program** ($99/year) | Can't upload or use TestFlight without it. Not yet confirmed | You |
| 6 | **Support page URL** | A required field in App Store Connect. See [section 4](#4-support-page-and-faq) | ⚠️ `support.html` written in the `armour-up-privacy` repo; **push it** to go live at https://markpetersondev.github.io/armour-up-privacy/support.html |
| 7 | **iPhone screenshots** (6.9" display, e.g. 1320×2868) | Required for the listing | After the upgrade |
| 8 | **App Store Connect forms**: agreements, trader status (EU), age rating, App Privacy, export compliance | Required before submitting. See [APP_STORE_RELEASE.md](APP_STORE_RELEASE.md) | You |
| 9 | **Release build and upload** with `flutter build ipa` | The only way to submit | After #1–5 |

---

## 3. Required code features for iOS

### Required by Apple
| Feature | Needed? | Status |
|---|---|---|
| UIScene lifecycle | **Yes**, from the iOS 27 SDK | ❌ Not done (needs Flutter 3.41+) |
| Privacy policy reachable inside the app | **Yes** (5.1.1) | ✅ Profile → Privacy Policy |
| Account deletion | Only if the app has accounts | ✅ Not applicable: no accounts. Reset all app data covers erasing |
| Sign in with Apple | Only if third-party login is offered | ✅ Not applicable |
| In-app purchase rules | Only if selling digital content | ✅ Not applicable |
| App Tracking Transparency prompt | Only if tracking | ✅ Not applicable: no tracking or ads |
| Permission usage descriptions (`NS…UsageDescription`) | Only for permissions used | ✅ None used (no camera, photos, location, etc.). When reminders return, notification permission is requested in code; no `Info.plist` key is needed |
| Privacy manifest (`PrivacyInfo.xcprivacy`) | For required-reason APIs | ⚠️ Probably covered by Flutter's and the plugins' own manifests (`shared_preferences`, `url_launcher`). Confirm with Xcode's privacy report when archiving |
| Works offline / no broken links | Expected by review (2.1) | ✅ Tested on Android; retest on iPhone |
| Doesn't crash on review devices | Expected by review (2.1) | ⚠️ Not yet tested on iPhone |

### Strongly recommended (not mandatory)
| Feature | Why | Status |
|---|---|---|
| **Help & support in Profile** | Reviewers and users look for a way to get help | ✅ Done 16 Nov 2026: Profile → Help & support → **Help & FAQ** (in-app, works offline) and **Contact us** (email with the app version filled in) |
| **Version from the build, not hardcoded** | So it never goes stale | ✅ Done 16 Nov 2026 with `package_info_plus`: Profile shows e.g. "Version 1.0.0 (1)" |
| **Crisis / "not professional care" note** | Rescue covers temptation, anxiety and negative thoughts. A short note with a link to find help reassures reviewers that it doesn't replace professional care | ❌ Built but hidden (IOS_SETUP step 4.9). Decide before submitting |
| **Focus timer survives the app being suspended** | iOS suspends apps quickly, so a tick-based timer may pause | ⚠️ Works on Android; untested on iOS. Fix if needed by timing from the end time |
| **VoiceOver pass** | Accessibility on iOS | ⚠️ Android checks pass; VoiceOver untested |

| **Close the keyboard by tapping outside or scrolling** | iPhone multi-line keyboards have no "Done" key and there is no back button | ✅ Done 16 Nov 2026, app-wide in `lib/main.dart` |

### Not needed for v1
Reminders (notifications), backup/iCloud sync, ambient sound, iPad layout, widgets.

---

## 4. Support page and FAQ

App Store Connect requires a **Support URL**. A simple page in the existing
`armour-up-privacy` GitHub Pages repo is enough, for example
`https://markpetersondev.github.io/armour-up-privacy/support.html`. The Play Store listing
can use it too.

### What the page should include
- App name and a one-line description
- **Contact email:** hustlebluprint@gmail.com, with an expected reply time
- **FAQ** (draft below)
- A link to the privacy policy
- "Last updated" date

### Draft FAQ

**Do I need an account?**
No. There's no sign-up, login or email. Open the app and start.

**Where is my data stored?**
Only on your phone. Your journal, prayers, moods and practices never leave your device. We
can't see them, and nothing is uploaded.

**Is my data backed up?**
Not by the app. On Android, app data is excluded from Google backups for privacy. On iPhone,
it may be included in your own iCloud device backup. If you delete the app or reset it, your
data is gone for good.

**How do I erase everything?**
Go to Profile → Reset all app data, or uninstall the app.

**Does it work without internet?**
Yes. All Scripture, prayers and guided flows are built into the app.

**Which Bible translation do you use?**
The Berean Standard Bible (BSB), which is free to use. See Profile → Scripture.

**What is Rescue?**
A guided path for hard moments: breathe, read Scripture chosen for what you're facing, pray,
take a concrete next step, and check in. Leaving early still counts as reaching for help.

**Is this a replacement for counselling or professional help?**
No. Armour Up Daily supports your walk with God, but it isn't medical or mental health
care. If you're in danger or thinking about harming yourself, contact your local emergency
number or a crisis line straight away.

**Why don't I get reminders?**
Reminders aren't in this version yet. They're planned for a future update.

**My streak reset. Why?**
Daily practices count consecutive days. If a day is missed, the streak starts again, and
grace covers every day. (An earlier version could wrongly reset streaks around clock
changes; this is fixed.)

**How do I suggest a feature or report a problem?**
Email hustlebluprint@gmail.com with your phone model and what happened.

---

## 5. Order of work

1. Back up the Mac, the Android keystore and `key.properties` (IOS_SETUP step 1).
2. Join the **Apple Developer Program**. Do this in parallel; approval can take a few days.
3. **Write and publish the support page**. This can be done now, before the upgrade.
4. Optionally add **Help & support** and the build-based **version** to Profile.
5. Upgrade **macOS → Xcode → Flutter → CocoaPods** (IOS_SETUP step 2).
6. Run the **UIScene migration** (IOS_SETUP step 4.1).
7. Test on the simulator and a real iPhone (IOS_SETUP step 5), including the Focus timer in
   the background and VoiceOver.
8. Decide on the crisis note.
9. Take screenshots, fill in App Store Connect, upload with `flutter build ipa`, test with
   TestFlight, and submit ([APP_STORE_RELEASE.md](APP_STORE_RELEASE.md)).
