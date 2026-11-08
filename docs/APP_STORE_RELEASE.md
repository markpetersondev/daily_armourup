# App Store Release Guide

How to publish Armour Up Daily on the App Store, from account setup to release. Finish
[IOS_SETUP.md](IOS_SETUP.md) first.

Apple's requirements were checked on 4 Nov 2026. See [Sources](#sources) for the
official pages.

## Before you start

- [ ] The app is built with Xcode 26 or later
- [ ] Reminders work on a real iPhone
- [ ] The Journal Privacy Lock toggle is removed or actually works
- [ ] The Scripture licence is resolved
- [ ] The privacy policy is corrected (step 2)
- [ ] A support page is live (step 3)

## 1. Accept agreements and declare trader status

1. Sign in to [App Store Connect](https://appstoreconnect.apple.com) and accept any
   pending agreements under **Business**. This release is free, so you shouldn't need
   banking or tax setup unless you add paid features later.
2. Declare your EU **trader status** under Business > Agreements > Compliance. Apple
   asks for this even if you don't distribute in the EU.

| Your choice | What it means |
|---|---|
| Trader | Your address, phone number and email are shown on the EU product page |
| Non-trader | No contact details are shown, and EU users are told consumer protection rights don't apply |

You must assess this yourself. Apple's factors include revenue from the app, commercial
promotion, VAT registration and developing it in a business capacity. If you're unsure,
get local advice. Excluding EU storefronts is also an option.

## 2. Fix the privacy policy

**The live policy needs rewriting before you submit.** It's generic template text that
doesn't match the app or the "Data Not Collected" answer in step 7:

| The policy says | What the app does |
|---|---|
| Collects names and other information | Stores data only on the device, with no developer access |
| Uses data for usage trends, marketing and improving services | Has no analytics or tracking |
| Refers to accounts and deactivating them | Has no accounts |
| Offers a data subject access request form | You hold no user data to return |
| Does not collect data from anyone under 18 | Must be consistent with your age rating (step 6) |

The rewritten policy should say:

- All profile, journal, prayer, habit and mood data stays on the user's device.
- You don't collect, receive, sell or share any of it, and the app has no accounts,
  ads, analytics or tracking.
- Data may be included in the user's own device or iCloud backup, under Apple's terms.
- Reminders are scheduled locally, and notification permission is optional.
- Users can erase everything with Profile > **Reset all app data**, or by deleting the
  app.
- The app opens external links, such as the policy itself, in the browser.
- How to contact you, and when the policy was last updated.

Update it at `https://markpetersondev.github.io/armour-up-privacy/`. It also publishes
your postal address, so decide whether you want that public.

## 3. Create a support page

Apple requires a support URL, and the project doesn't have one yet. A simple GitHub
Pages page is enough. Include the app name, a contact email, a short FAQ and a link to
the privacy policy. For the FAQ, cover where data is stored, how to change reminders,
and that deleting the app or using reset erases data permanently because there's no
backup.

## 4. Create the app record

Go to **Apps** > **+** > **New App**:

| Field | Value |
|---|---|
| Platform | iOS |
| Name | Armour Up Daily |
| Primary language | English (U.K.) suits the "Armour" spelling |
| Bundle ID | `com.hustlebluprint.armourupdaily` |
| SKU | `armourupdaily-ios` |
| User access | Full Access |

If the bundle ID isn't listed, register it under
[Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/list),
or let Xcode create it by building once with automatic signing.

## 5. Add the store listing

Use the text below, and change anything that no longer matches the final app.

**Subtitle** (30 characters max)

```
Prayer, Scripture & Rescue
```

**Promotional text** (170 characters max)

```
A private place for daily prayer and Scripture, with guided help for the moment temptation, anxiety, or discouragement hits. No account. No ads. Works offline.
```

**Keywords** (100 characters max)

```
prayer,bible,scripture,devotional,christian,journal,temptation,faith,habit,verse,anxiety
```

**Description** (adapted from the Play listing, with the backup claim removed)

```
Armour Up Daily is a private daily companion for building consistent spiritual habits — and for the moment temptation, anxiety, or discouragement actually hits.

Most faith apps either give you devotional content or track habits. Neither shows up at 11pm when you're about to do the thing you promised yourself you wouldn't do. Armour Up Daily does.

YOUR DAILY RHYTHM
• Check in on how your heart is doing and get a grace-centered response, not a guilt trip
• A new verse each day, saveable in one tap
• One gentle next step — never a to-do list
• Build daily practices — prayer, Scripture reading, journaling, gratitude — at your own pace
• Gentle reminders at the times you choose, each one easy to turn off

RESCUE — HELP WHEN YOU NEED IT MOST
One tap from anywhere in the app. Choose what you're facing — temptation, anxiety, anger, loneliness, and more — and get a guided path: breathe, Scripture chosen for that struggle, a matched prayer, and a concrete next step. Leave at any point; reaching for help always counts.

BUILT AROUND YOUR PRIVACY
Your journey stays on your device. No account, no sign-up, no email required. No analytics and no tracking.

WORKS EVEN WITH NO SIGNAL
Every verse, prayer, and flow is bundled in the app. Faith doesn't wait for a connection.

ALSO INCLUDED
• A curated Scripture library organized by real-life need, with saving, notes, and memorization
• A private journal with six entry types, including answered-prayer tracking
• Sacred Focus — timed, distraction-free prayer and reflection sessions
• A library of written prayers for the moments people actually reach for one
• The Armour of God — a reflection built on Ephesians 6

No ads. No social feed. No streak-shaming. Just a quiet place to come back to.

Armour Up Daily offers spiritual encouragement. It is not medical or mental health care. If you're in crisis, please contact your local emergency services.
```

**Other fields**

| Field | Value |
|---|---|
| Primary category | Lifestyle |
| Secondary category | Reference (optional) |
| Price | Free |
| Support URL | Your page from step 3 |
| Privacy Policy URL | `https://markpetersondev.github.io/armour-up-privacy/` |
| Copyright | `2026 Mark Peterson` |
| Availability | All countries, subject to your choice in step 1 |

## 6. Complete the age rating

Go to **App Information** > **Age Ratings**, and answer based on what's actually in the
app. Things to keep in mind:

- Rescue includes a "Lust / sexual temptation" category and addresses addiction and
  anxiety. The content is prayer and Scripture and isn't explicit, but answer the
  sexual content, substance and medical or wellness questions honestly.
- The app has no social features, messaging, user-generated sharing or web browsing.
- Apple adds Shared Location and Dating and Relationships declarations on 16 Nov 2026,
  which all apps must complete by 12 Jan 2027. Both should be "no" for this app.
- Your calculated rating must fit your privacy policy. If you intend the app for
  adults only, use **Override to Higher Age Rating** and keep the 18+ policy wording.
  Otherwise, remove the 18+ wording from the policy.

## 7. Complete App Privacy

Go to **App Privacy** > **Get Started**, select **Data Not Collected**, and publish.

This is accurate only if the finished build still has no analytics, crash reporting,
ads or other data-sending SDK. Data that stays on the device doesn't count as collected.
Change the answer if you add any of these later.

## 8. Prepare the screenshots

**The Play Store screenshots can't be reused.** They're 1250 × 2220, which Apple doesn't
accept, so capture new ones.

| Display | Size | Simulator | Required? |
|---|---|---|---|
| iPhone with Dynamic Island, medium | 1206 × 2622 | iPhone 17 | **Yes** |
| iPhone with Dynamic Island, large | 1320 × 2868 | iPhone 17 Pro Max | Recommended |

Without the large size, Apple requires 1284 × 2778 or 1242 × 2688 screenshots instead,
so providing it is the simplest route. iPad screenshots aren't needed if you made the
app iPhone-only. You can upload up to 10 per size, and images can't have transparency.

```bash
mkdir -p store/appstore/screenshots
open -a Simulator
flutter run -d "iPhone 17 Pro Max"
xcrun simctl status_bar booted override --time "9:41" --batteryState charged --batteryLevel 100
xcrun simctl io booted screenshot store/appstore/screenshots/6.9-01-home.png
sips -g pixelWidth -g pixelHeight -g hasAlpha store/appstore/screenshots/*.png
```

Repeat for each screen and device. Use the same five screens as Play: Home, Rescue,
Scripture, Armour and Progress. Fill the app with realistic sample content first, and
don't show any real personal journal text.

## 9. Upload the build

1. Set the version in [pubspec.yaml](../pubspec.yaml). `1.0.0+1` works for the first
   upload, and each later upload needs a higher build number, such as `1.0.0+2`.
2. Build it:

   ```bash
   flutter clean
   flutter pub get
   flutter build ipa --release
   ```

3. Open `build/ios/archive/Runner.xcarchive` in Xcode.
4. Click **Validate App** and fix anything it reports.
5. Click **Distribute App** > **App Store Connect** > **Distribute**.
6. Wait for processing to finish in App Store Connect. Apple emails you if the build has
   problems. If an email mentions a missing privacy manifest reason, update the affected
   plugin or add the required `PrivacyInfo.xcprivacy` entry.

## 10. Test with TestFlight

Apple doesn't require a tester count or test period, unlike Google Play, but use
TestFlight anyway because it's the build your users will get.

1. Open the **TestFlight** tab and add yourself to an internal testing group.
2. Install the **TestFlight** app on your iPhone and install the build.
3. Repeat the checklist from [IOS_SETUP.md](IOS_SETUP.md#5-test-the-app), and leave
   reminders running for a few days.
4. Optionally add external testers by email or public link. Their first build goes
   through a short Beta App Review.

## 11. Submit for review

On the version page, attach the build and screenshots, then fill in **App Review
Information** with your contact details. No sign-in details are needed, so paste these
notes:

```
Armour Up Daily is a private Christian devotional app. It has no accounts, login, in-app purchases, ads, or analytics, and all user data stays on the device. No demo account is needed, and the app works offline.

To review: complete the short onboarding, then tap Rescue, choose a category, and follow the guided flow (breathing, Scripture, prayer, next step).

Reminders are local notifications, set during onboarding or under Profile > Edit Profile. Permission is optional, and the app works without it.

Rescue addresses struggles such as temptation, anxiety, and addiction through prayer and Scripture only. It contains no explicit content and doesn't provide medical advice.
```

Then:

1. Under **Version Release**, choose **Manually release this version**, so you control the
   launch day.
2. Click **Add for Review**, then **Submit for Review**.

Review is often finished in a day or two, but allow a week, especially for a first
submission.

## 12. Respond to the outcome

**If approved:** check the listing, click **Release This Version**, then install from the
App Store and run through the key flows once more.

**If rejected:** read the message in App Store Connect, fix the cited issue, and reply or
resubmit from there. Rejections are common and don't count against you. If you disagree,
you can reply with an explanation or file an appeal.

| Likely risk | Guideline | How to avoid it |
|---|---|---|
| Features that don't work or look unfinished | 2.1 | Build reminders, remove the lock toggle and the "later update" text |
| Listing claims don't match the app | 2.3 | Don't mention backup, and only describe what's in the build |
| Privacy policy doesn't match the app | 5.1.1 | Complete step 2 |
| Scripture licensing | 5.2 | Resolve IOS_SETUP step 4.8 |
| Health claims | 1.4 | Don't claim to treat addiction or anxiety |
| Crashes or broken layouts on iPad | 2.1, 4 | Open the iPhone app on an iPad simulator, because App Review may test there |

## 13. After launch

- **Updates:** raise the version and build number, upload, attach the build to a new
  version, and submit.
- **Crashes and reviews:** check them in App Store Connect and Xcode Organizer. Both are
  provided by Apple, so you don't need to add an analytics SDK.
- **April 2027:** iOS apps must be built with the iOS 27 SDK or later. You already meet
  this if you built with Xcode 27.
- **Android:** when you're ready, Play needs a closed test with at least 12 testers
  opted in for 14 consecutive days, then a production access application. iOS users and
  TestFlight testers can't count unless they also join on Android.

## Sources

- [Apple: SDK minimum requirements](https://developer.apple.com/news/upcoming-requirements/?id=04282026a)
- [Apple: Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
- [Apple: Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/)
- [Apple: New age rating content descriptors](https://developer.apple.com/news/?id=yxkh08us)
- [Apple: EU trader requirements](https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements/)
- [Apple: App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google Play: Testing requirements for new personal accounts](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en)
