# iOS Setup and App Changes

How to get Armour Up Daily building on this Mac and ready for App Store upload.
When you finish this guide, continue with [APP_STORE_RELEASE.md](APP_STORE_RELEASE.md).

Apple's requirements were checked on 4 Nov 2026. They change often, so see
[Sources](#sources) if something looks different.

## Where things stand

| Item | Now | Needed |
|---|---|---|
| macOS | 14.2.1 (Sonoma) | Tahoe 26.6+ for Xcode 27 |
| Xcode | 15.1, not selected as the active developer directory | Xcode 26 or later is required for App Store uploads |
| Flutter | 3.38.4 | Latest stable (3.41+ migrates the app to UIScene automatically) |
| CocoaPods | 1.14.3 | 1.16.2 |
| Signing certificates on this Mac | 0 | Created by Xcode after you sign in |
| Apple team in the project | `SGA7JNW87Z` | Confirm it is your paid team |
| Deployment target | iOS 12.0 | iOS 15.0 |
| Devices | iPhone and iPad | iPhone only for v1 |
| Orientation on iPhone | Portrait and landscape | Portrait only |
| Reminders | Settings only, nothing fires | Real notifications |
| Journal Privacy Lock | Toggle saves a value but locks nothing | Remove for v1, or build it |
| Scripture text | Wording looks like NIV, no attribution | Licensed with notice, or public domain |

**The macOS and Xcode upgrade comes first.** Apple rejects uploads not built with
Xcode 26+, and Xcode 26 can't run on your current macOS.

## 1. Prepare before upgrading

1. Commit the pending Gradle changes in `android/` so they aren't mixed into iOS work.
2. Back up the Mac with Time Machine or similar.
3. Copy `~/releasekeys/armourup-release.jks` and `android/key.properties` somewhere
   safe off this Mac. Neither is in git, and you'll need them when Android resumes.
4. Create a working branch:

   ```bash
   git checkout develop
   git checkout -b feature/ios-release
   ```

## 2. Upgrade the Mac tools

1. **Update macOS:** System Settings > General > Software Update. Install Tahoe 26.6
   or later.
2. **Install the latest stable Xcode** (not a beta) from the Mac App Store or
   [Apple's downloads page](https://developer.apple.com/download/applications/).
3. **Activate it:**

   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   sudo xcodebuild -license accept
   xcodebuild -downloadPlatform iOS
   ```

4. **Fix the terminal encoding and update CocoaPods.** CocoaPods warned about UTF-8
   on this Mac, so add this to `~/.zshrc`:

   ```bash
   export LANG=en_US.UTF-8
   ```

   Then update it, using the same tool that installed it:

   ```bash
   which pod                  # a Homebrew path means use brew
   brew upgrade cocoapods     # Homebrew install
   sudo gem install cocoapods # system gem install
   ```

5. **Upgrade Flutter and check everything:**

   ```bash
   flutter upgrade
   flutter doctor -v
   ```

   Continue when the Xcode section shows no errors. Android warnings can wait.

> **If the latest Flutter and Xcode don't work together:** install Xcode 26.6 instead.
> It needs Tahoe 26.2+ and meets today's upload rule. You'd then need to move to the
> iOS 27 SDK and UIScene before April 2027.

## 3. Set up your Apple account

1. Enroll in the [Apple Developer Program](https://developer.apple.com/programs/enroll/).
   It has been US$99 a year, so confirm the current price for your region. A free
   account can't use TestFlight or the App Store. Enroll as an **Individual** unless
   you have a registered company with a D-U-N-S number. Approval can take a while, so
   start early.
2. In Xcode, go to Settings > Accounts and sign in with that Apple ID.
3. Open the project:

   ```bash
   flutter pub get
   cd ios && pod install && cd ..
   open ios/Runner.xcworkspace
   ```

4. Select **Runner** > target **Runner** > **Signing & Capabilities**, and then:
   - Turn on **Automatically manage signing**.
   - Select your paid team. Your team ID is on your
     [membership page](https://developer.apple.com/account#MembershipDetailsCard). If
     it isn't `SGA7JNW87Z`, selecting your team here updates the project.
   - Confirm the bundle ID is `com.hustlebluprint.armourupdaily`.

## 4. Make the project changes

Do these in order. The UIScene step must come before you edit `AppDelegate.swift`,
because automatic migration only applies to an unmodified `AppDelegate`.

### 4.1 Migrate to UIScene

Apps built with the iOS 27 SDK crash on startup without the UIScene lifecycle. Run:

```bash
flutter build ios --simulator --debug
```

Look for `Finished migration to UIScene lifecycle`. If it prints manual instructions
instead, follow
[Flutter's migration guide](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate).
Commit the result.

### 4.2 Raise the deployment target to iOS 15.0

- In Xcode, go to Runner project > Info > **iOS Deployment Target** and choose 15.0.
  Check the Runner target's **Minimum Deployments** shows 15.0 too.
- In [ios/Podfile](../ios/Podfile), replace the commented `platform` line with:

  ```ruby
  platform :ios, '15.0'
  ```

- If [ios/Flutter/AppFrameworkInfo.plist](../ios/Flutter/AppFrameworkInfo.plist) still
  has a `MinimumOSVersion` key, set it to `15.0`.

Then run `cd ios && pod install && cd ..`.

### 4.3 Make v1 iPhone-only and portrait-only

iPad support would require iPad screenshots and iPad layout testing. iPhone-only apps
still run on iPads in compatibility mode, and App Review may test them that way.

- In Xcode, go to the Runner target > General > **Supported Destinations** and remove
  iPad. `TARGETED_DEVICE_FAMILY` should become `"1"`.
- In [ios/Runner/Info.plist](../ios/Runner/Info.plist), keep only portrait:

  ```xml
  <key>UISupportedInterfaceOrientations</key>
  <array>
      <string>UIInterfaceOrientationPortrait</string>
  </array>
  ```

### 4.4 Declare encryption use

The app doesn't use its own encryption, and this key skips the export compliance
question on every upload. Add it to `Info.plist`:

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

### 4.5 Set the launch screen colour

The launch images are 1×1 placeholders, so launch shows a plain screen. Open
`ios/Runner/Base.lproj/LaunchScreen.storyboard` in Xcode and set the view background
to the brand green `#123D2B`, the same colour as the Android icon background.

### 4.6 Build the reminders

Users can set four reminders today, and home shows a "Coming up" card with a bell
icon, but nothing is ever sent. The onboarding footnote says notifications arrive in a
later update. App Review can treat that as an unfinished feature.

**Add the packages:**

```bash
flutter pub add flutter_local_notifications timezone flutter_timezone
```

**Register the delegate** in
[ios/Runner/AppDelegate.swift](../ios/Runner/AppDelegate.swift), inside
`didFinishLaunchingWithOptions`, before the `return`:

```swift
UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
```

Add `import UserNotifications` at the top if the compiler asks for it.

**Create `lib/core/notifications/reminder_service.dart`** with these jobs:

| Job | How |
|---|---|
| Set up time zones | `tz.initializeTimeZones()`, then `tz.setLocalLocation(...)` using the name from `flutter_timezone` |
| Initialise without prompting | Set the `DarwinInitializationSettings` permission flags to `false` |
| Ask for permission | `IOSFlutterLocalNotificationsPlugin.requestPermissions(alert: true, badge: true, sound: true)` |
| Schedule | One `zonedSchedule` per enabled reminder, with `matchDateTimeComponents: DateTimeComponents.time` so it repeats daily |
| Reschedule | Cancel all, then schedule from the current `ReminderPreferences` |

The plugin's API changes between major versions, so copy the exact call signatures
from the [plugin README](https://pub.dev/packages/flutter_local_notifications) for the
version you install.

**Connect it to the app:**

| Where | Change |
|---|---|
| [lib/main.dart](../lib/main.dart) | Initialise the service before `runApp`, and reschedule so time zone changes are picked up |
| [onboarding_steps.dart:392](../lib/features/onboarding/presentation/onboarding_steps.dart#L392) | Remove the "later update" footnote, and ask permission when the user continues from this step |
| [onboarding_provider.dart:72](../lib/features/onboarding/providers/onboarding_provider.dart#L72) | Schedule reminders after `complete()` saves the profile |
| [edit_profile_screen.dart:46](../lib/features/profile/presentation/edit_profile_screen.dart#L46) | Reschedule after saving |
| [profile_screen.dart:357](../lib/features/profile/presentation/profile_screen.dart#L357) | Cancel all notifications when the user resets app data |

**Use the PRD's tone:** gentle invitations such as "Begin the day anchored in prayer",
never messages about missed streaks. Keep notification text generic so it doesn't
reveal anything private on the lock screen. Avoid wording such as "temptation" in the
high-risk reminder.

**If the user denies permission:** the app must keep working, and the reminder settings
should explain how to turn notifications on in iOS Settings.

> **Android impact:** this plugin needs AGP 8.11.1+, Java 17 with core library
> desugaring, and `compileSdk` 35+. The project has AGP 8.9.1 and Java 8, so Android
> builds will fail until you update them using the plugin's Android setup steps.

### 4.7 Remove the Journal Privacy Lock toggle

The toggle at [profile_screen.dart:204](../lib/features/profile/presentation/profile_screen.dart#L204)
saves a setting, but the journal never reads it. A user could turn it on and believe
their journal is protected when it isn't.

**Recommended for v1:** remove the toggle. Leave the `journalLockEnabled` field in the
model so existing saved data still loads. Building a real lock later needs `local_auth`
and an `NSFaceIDUsageDescription` entry in `Info.plist`.

### 4.8 Resolve the Scripture licence

The verses have no translation name or copyright notice, and the wording looks like
the NIV. For example, Ephesians 6:11 in
[verse.dart](../lib/shared/models/verse.dart) reads "take your stand against the
devil's schemes". Please confirm which translation you used. Apple can reject or remove
apps over third-party rights (guideline 5.2).

| Option | What it takes | Note |
|---|---|---|
| **Switch to a public domain translation (recommended)** | Replace the verse text with the World English Bible or Berean Standard Bible | No permission needed, but check each translation's current terms and re-read each verse in its context |
| Keep the NIV | Follow [Biblica's permissions](https://www.biblica.com/permissions/), and add the required notice | Biblica's pages differ on digital use, and its terms ask for the notice on each page showing NIV text. Get written confirmation for an app |

Verses appear in `scripture_library.dart`, `rescue_content.dart`, `prayer_library.dart`,
`focus_content.dart`, `verse.dart` and `app_providers.dart`. This isn't legal advice.

### 4.9 Add crisis support wording (deferred until after the MVP)

> **Status:** built, but hidden for the MVP release by decision. The widget is in
> `lib/features/rescue/widgets/crisis_support_note.dart`. To turn it back on, uncomment
> the marked lines (the import and the note at the end of the list) in
> `rescue_screen.dart` and `recovery_screen.dart`.

Rescue offers help with anxiety, addiction and negative thoughts, and the app has no
crisis wording while this note is hidden. The note adds a short line to Rescue and
Recovery:

> If you're in danger or thinking of harming yourself, please contact your local
> emergency services or someone you trust right now.

It isn't a stated submission requirement, but it's the right safeguard for this
audience, and it also helps show the app doesn't claim to replace professional care.

### 4.10 Tidy up

- Replace the deprecated radio properties at
  [profile_screen.dart:174](../lib/features/profile/presentation/profile_screen.dart#L174)
  with `RadioGroup`. This is optional for now.
- Mark backup as post-v1 in [PRD.md](PRD.md).

## 5. Test the app

```bash
flutter analyze
flutter test
flutter run                   # choose an iOS simulator
flutter run --release         # on a connected iPhone
```

To use a real iPhone, connect it, trust the Mac, and turn on Settings > Privacy &
Security > **Developer Mode**. Test notifications on the real device.

- [ ] A fresh install goes through onboarding correctly
- [ ] The app works fully in airplane mode
- [ ] Rescue works from start to finish, and leaving early still counts
- [ ] Journal entries and habits survive force-quitting the app
- [ ] Each reminder fires at its set time, including with the app force-quit
- [ ] Changing or turning off a reminder takes effect
- [ ] Denying notification permission causes no errors
- [ ] Reset all app data clears data and cancels notifications
- [ ] The Privacy Policy link opens
- [ ] Layouts work on small and large iPhones (iPhone SE and a Pro Max simulator)
- [ ] Light mode, dark mode and the largest text size are all readable
- [ ] The app icon and name look right on the home screen
- [ ] No "later update" or other placeholder wording remains

## 6. Confirm a release build works

```bash
flutter clean
flutter pub get
flutter build ipa --release
```

A successful build creates `build/ios/archive/Runner.xcarchive`. You're then ready for
[APP_STORE_RELEASE.md](APP_STORE_RELEASE.md).

## Troubleshooting

| Problem | Try |
|---|---|
| `xcodebuild requires Xcode` | Run the `xcode-select --switch` command from step 2 |
| CocoaPods errors | `cd ios && rm -rf Pods Podfile.lock && pod install --repo-update` |
| A pod needs a newer iOS version | Check the `platform` line in the Podfile and the Xcode deployment target match |
| `No signing certificate` or no profiles | Re-check your team in Signing & Capabilities, with automatic signing on |
| Bundle ID unavailable | Check it isn't registered to a different Apple account |
| App crashes at launch | Check the UIScene migration in step 4.1 |
| Notifications don't appear | Check iOS Settings and Focus modes, then test on a real iPhone |

## Sources

- [Apple: SDK minimum requirements](https://developer.apple.com/news/upcoming-requirements/?id=04282026a)
- [Apple: Xcode system requirements](https://developer.apple.com/xcode/system-requirements/)
- [Apple: Compare memberships](https://developer.apple.com/support/compare-memberships/)
- [Flutter: UISceneDelegate migration](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Biblica: Permissions](https://www.biblica.com/permissions/)
