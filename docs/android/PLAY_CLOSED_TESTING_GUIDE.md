# Google Play Closed Testing → Production Guide

How to get **Daily ArmourUp** (`com.hustlebluprint.armourupdaily`) from "no production access" to live on Google Play.

**Why this is needed:** personal developer accounts created after 13 Nov 2023 must run a closed test with **at least 12 testers opted in for 14 days in a row** before they can apply for production access.

**Plan:** Testers Community (paid) + 8 real people (family, friends, community).
**Timeline:** about 3–4 weeks in total.

---

## Current status (15 Nov 2026)

**Waiting for Google to review the first closed testing release.** This usually takes a few
hours to about 2 days, and you'll get an email when it's done. In Play Console,
**Publishing overview** shows "Changes in review". Don't click **Remove changes**.

### Done ✅
- [x] Privacy policy rewritten and live at https://markpetersondev.github.io/armour-up-privacy/
- [x] Release fixes committed and pushed: portrait lock, Reflect opens a new entry, single
      "copied" message, Memory tab at large text, Recovery notes saved to the Journal
- [x] Play Console Dashboard setup, 11 of 11:
  - Privacy policy, Sign in details (none), Ads (none)
  - Content rating: Everyone / PEGI 3 / IARC 3+
  - Target audience: 13+
  - Data safety: no data collected or shared
  - Government apps, Financial features: none
  - Health: Stress management, relaxation, mental acuity
  - Advertising ID: not used
  - Category Lifestyle, store listing
- [x] Signing key checked. Upload key SHA-1 `90:92:0F:99:D2:21:B1:8A:E6:A3:55:45:E5:42:2C:C6:EB:98:28:48`
- [x] Release AAB `1 (1.0.0)` built, signed and uploaded to **Closed testing – Alpha**
- [x] Countries: all 177 plus rest of world
- [x] Testers: email list "ArmourUp testers" (only hustlebluprint@gmail.com so far)
- [x] Feedback email: hustlebluprint@gmail.com
- [x] Submitted for review

### While waiting for approval
- [ ] **Email Testers Community support** (support@testerscommunity.com) with the 5 questions in
      [TESTERS_COMMUNITY_NOTES.md](TESTERS_COMMUNITY_NOTES.md), especially: do I add your
      Google Group, or paste a list of emails?
- [ ] **Create a Google Group** at https://groups.google.com
  - Name: `ArmourUp Testers`. Who can join: invited users only
  - Members: hustlebluprint@gmail.com plus your 7 people
- [ ] **Collect Gmail addresses** from your 7 people (1 friend, 3 family, 3 community friends).
      Tell them the link is coming in a day or two.
- [ ] Add those emails to the **ArmourUp testers** list in Play Console (or to the Google Group).
- [ ] **Back up the keystore** off this Mac: `/Users/markpeterson/releasekeys/armourup-release.jks`
      and its passwords, in a password manager or encrypted cloud storage.

### When Google approves
- [ ] **Closed testing → Alpha → Testers**, then **Copy link** (the opt-in link).
- [ ] **Opt in yourself first** on your Samsung with hustlebluprint@gmail.com and install from
      Play, to check the link works.
- [ ] **Buy Testers Community, Starter plan (LKR 3,999).** Screenshot the guarantee and keep
      the Stripe receipt.
- [ ] Submit the opt-in link in their dashboard.
- [ ] If they give you a Google Group, switch **Testers** to **Google Groups** and enter both
      groups separated by a comma, e.g.
      `armourup-testers@googlegroups.com, <their-group>@googlegroups.com`.
      A track uses either email lists **or** Google Groups, not both.
- [ ] Send the opt-in link and the message in [Phase 4.2](#42-invite-your-8-real-people) to
      your 7 people.
- [ ] Watch **"X testers currently opted-in"** on the Production page. The 14 days start at 12.

### If Google rejects the release
- [ ] Read the reason in the email and in **Publishing overview**, fix it, and resubmit.

---

## Overview

| Phase | What | Time |
|---|---|---|
| 1 | Finish Dashboard setup tasks | 1–2 hours |
| 2 | Build the release AAB | 15 min |
| 3 | Create the closed testing track and release | 30 min + Google review (hours–2 days) |
| 4 | Pay for testers and invite your 8 people | 1 hour |
| 5 | Run the 14-day test | 14+ days |
| 6 | Apply for production | 30 min + Google review (up to ~7 days) |
| 7 | Publish to production | 30 min + review |

---

## Phase 1 — Finish the Dashboard setup tasks

In **Play Console → Dashboard → "Set up your app"**, complete every item:

- [ ] **App access**: say whether any part of the app needs a login. If not, choose "All functionality is available without special access".
- [ ] **Ads**: does the app contain ads? (Yes/No)
- [ ] **Content rating**: fill in the questionnaire.
- [ ] **Target audience and content**: age groups.
- [ ] **Data safety**: declare what data is collected and shared. It must match what the app actually does, including any analytics or crash reporting.
- [ ] **Privacy policy URL**: a public URL is required.
- [ ] **Government apps / Financial features / Health**: answer as applicable.
- [ ] **App category and contact details**
- [ ] **Main store listing**: use the files in `store/play/`:
  - `short-description.txt`
  - `full-description.txt`
  - `play-store-icon-512.png`
  - `feature-graphic-1024x500.png`
  - `screenshots/`

> Testers see the store listing when they opt in, so finish it before the test starts.

---

## Phase 2 — Build the release AAB

Signing is already set up (`android/key.properties` exists and `build.gradle` uses it).

### 2.1 Bump the version
In `pubspec.yaml`, the current version is `1.0.0+1`. The number after `+` is the **versionCode**, and every upload to Play must use a higher one.

- First upload ever → `1.0.0+1` is fine.
- If you've already uploaded a build anywhere (internal testing, etc.) → increase it, e.g. `1.0.0+2`.

### 2.2 Build
```bash
flutter clean
flutter pub get
flutter test
flutter build appbundle --release
```

The output is:
```
build/app/outputs/bundle/release/app-release.aab
```

### 2.3 Back up your signing key
Keep your keystore file and `android/key.properties` passwords somewhere safe outside the repo, such as a password manager or encrypted backup. **If you lose the upload key, you can't update the app until Google resets it.**

---

## Phase 3 — Create the closed testing release

1. Go to **Play Console → Test and release → Testing → Closed testing**.
2. Use the default track (**"Closed testing – Alpha"**) or click **Create track**.
3. **Countries/regions** tab: add the countries your testers are in. Include Sri Lanka and any countries the tester service uses. Selecting all countries is the simplest choice.
4. **Testers** tab:
   - Choose **Email lists** and create a list (e.g. "ArmourUp testers") with your 8 real people's Gmail addresses, **or** add a **Google Group** email if the tester service gives you one.
   - Set the **feedback URL or email** (your email is fine).
   - Save.
5. **Create a new release**:
   - Upload `app-release.aab`.
   - If asked, accept **Play App Signing** (recommended).
   - Release name: e.g. `1.0.0 (1) closed test`.
   - Release notes: e.g. "First closed test build. Please explore daily devotion, rescue, focus and journal and send any feedback."
6. Click **Next → Save → Send for review**, then go to **Publishing overview** and click **Send changes for review** if it's shown.
7. Wait for Google's review, which takes a few hours to about 2 days.
8. Once approved, open the **Testers** tab and copy the **opt-in link** ("Join on the web"). It looks like:
   ```
   https://play.google.com/apps/testing/com.hustlebluprint.armourupdaily
   ```

---

## Phase 4 — Get testers

### 4.1 Pay for Testers Community
1. Go to **https://www.testerscommunity.com/**.
2. Before paying, read the **Trustpilot reviews from the last month**.
3. Choose a plan that includes:
   - [ ] At least 12 testers for at least 14 days
   - [ ] **Replacement of testers who drop out**
   - [ ] A **feedback report** (you'll need it for the production application)
4. Pay with a card enabled for online/international payments. **Starter plan: LKR 3,999 per app** (15 testers for 14 days, production access guarantee, credits never expire). Check "Compare plans" to see whether the feedback report needs the Pro plan.
   - Paying early is fine, but only **start** the testers after your closed testing release is approved (Phase 3).
5. Follow their onboarding instructions exactly. Typically you:
   - give them your **opt-in link** and/or package name `com.hustlebluprint.armourupdaily`, and
   - add the **Google Group email** they give you to your closed test's **Testers** tab, then save.
     Note that a track uses **either** email lists **or** Google Groups. If you switch to Google
     Groups, put your own testers in a Google Group too and enter both groups, separated by a comma.
6. Save the payment receipt and any guarantee terms (screenshot them).

### 4.2 Invite your 8 real people
Send them this message (edit as needed):

> Hi! I've built a Christian devotional app called **Daily ArmourUp** and need help testing it before it goes on the Play Store. It takes 2 minutes:
>
> 1. Open this link on your Android phone, signed in with the Gmail address you gave me: **[opt-in link]**
> 2. Tap **"Become a tester"**
> 3. Tap **"Download it on Google Play"** and install
>
> Please **don't tap "Leave the program"** for the next 2 weeks. Open the app a few times and tell me one thing you liked and one thing that could be better. Thank you! 🙏

Rules for your own people:
- Each person uses **their own phone and their own Google account**.
- Don't use multiple accounts on one phone, and don't use emulators to inflate the count.

---

## Phase 5 — Run the 14-day test

The clock starts once **12+ testers are opted in**, and it **restarts if the count falls below 12**.

### Daily or every 2–3 days
- [ ] Check **Dashboard / Production page → "X testers currently opted-in"**. Keep it at **≥ 12**, ideally 15+.
- [ ] If it drops toward 12, contact Testers Community and ask more of your own people.

### During the 14 days
- [ ] **Day ~5**: remind your 8 people to open the app and send feedback.
- [ ] **Day ~7**: push **one small update** to the closed track (fix something testers reported, bump the versionCode, rebuild, upload as a new closed testing release). This shows Google you're acting on feedback.
- [ ] **Day ~10**: second reminder.
- [ ] Keep a **feedback log** with the date, who, what they said, and what you changed. Use it in Phase 6.
- [ ] Check **Android vitals** and **Pre-launch report** in Play Console for crashes.

### Feedback log template

| Date | Tester | Feedback | Action taken |
|---|---|---|---|
| | | | |

---

## Phase 6 — Apply for production

When all three checklist items on the **Production** page are ticked:

1. Click **Apply for production**.
2. Answer the questions honestly and in detail. You can click **"Preview questions"** before then. Topics usually include:
   - **About your closed test**: how you recruited testers, how easy it was, and how they engaged with the app.
   - **About your app**: who it's for, the value it provides, and how many installs you expect in the first year.
   - **Production readiness**: what you changed based on feedback and how you decided it was ready.
3. Use your **feedback log** and the **Testers Community feedback report**. Mention specific changes (e.g. "fixed reflections not saving to Journal; improved large-text accessibility").
4. Submit. Google says the review takes **about 7 days or less**.

**If rejected:** read the reason, keep the closed test running, improve engagement and feedback, and apply again. Don't create a new developer account to get around it.

---

## Phase 7 — Publish to production

1. **Test and release → Production → Create new release**.
2. Bump the versionCode in `pubspec.yaml`, rebuild (`flutter build appbundle --release`), and upload.
3. Set **Countries/regions** for production.
4. Add release notes.
5. Choose the rollout: a **staged rollout** (e.g. 20%) is safer for the first release.
6. **Send for review**. Production reviews usually take from a few hours to a few days.
7. When it's live, share the Play Store link:
   ```
   https://play.google.com/store/apps/details?id=com.hustlebluprint.armourupdaily
   ```

---

## Quick checklist

- [ ] Dashboard setup tasks complete
- [ ] Store listing complete
- [ ] Signing key backed up
- [ ] AAB built (`flutter build appbundle --release`)
- [ ] Closed testing release approved
- [ ] Opt-in link copied
- [ ] Testers Community paid; their Google Group added to Testers
- [ ] 8 real people invited and opted in
- [ ] 12+ testers opted in (14-day clock started on: ____ )
- [ ] Mid-test update pushed
- [ ] Feedback log kept
- [ ] 14 days completed (date: ____ )
- [ ] Applied for production (date: ____ )
- [ ] Production access granted
- [ ] Production release live 🎉
