# Armour & Prayer — Product Requirements Document

**Version:** 1.0
**Status:** Built, pre-launch
**Platforms:** iOS, Android

---

## 1. One-Line Summary

Armour & Prayer is a private daily companion for Christians who want to build
consistent spiritual habits — and who need real help in the moment temptation,
anxiety, or discouragement actually hits.

---

## 2. The Problem

Most faith apps do one of two things well, and neither is enough on its own:

- **Devotional apps** deliver content. You read a verse, feel encouraged, close
  the app. Nothing carries into the rest of the day.
- **Habit trackers** count streaks. They tell you that you missed three days,
  which for spiritual practice often produces guilt rather than growth.

Neither is there at 11pm when someone is about to do the thing they promised
themselves they wouldn't do. That moment — the moment of temptation, panic, or
despair — is where faith is actually tested, and it's where almost no app shows
up.

There's also a trust problem. The things people most need to write down —
confessions, struggles with lust or addiction, fears they'd never say out loud —
are exactly the things they will not type into an app that uploads everything to
a server behind an account login.

## 3. What We're Building

A single app that covers the whole rhythm:

1. **The daily practice** — prayer, scripture, journaling, and habit-building
   that compounds over weeks.
2. **The emergency** — a guided rescue flow for the moment of crisis, reachable
   in one tap from anywhere in the app.
3. **The privacy that makes both possible** — everything stays on the device by
   default. No account. No sign-up. Nothing uploaded unless the user explicitly
   asks for it.

---

## 4. Who It's For

**Primary user:** A practicing Christian, roughly 18–40, who already believes
but struggles with consistency. They want to pray daily and read Scripture
regularly, and they keep falling off. They're often fighting a specific private
battle — pornography, anger, anxiety, doomscrolling — and they feel too ashamed
to bring it to their church community.

**Secondary user:** Someone earlier in their faith who wants structure and
doesn't know where to start — needs guided prayers and a curated verse library
rather than a blank page.

**Explicitly not for:** People looking for a full Bible reader, a church social
network, or a community/accountability-partner product. Those are different apps.

---

## 5. Product Principles

These govern every design decision.

1. **Grace, never guilt.** Copy encourages, never shames. A broken streak says
   "begin again today," not "you failed." No red warnings, no scolding, no
   pressure metrics.
2. **Private by default.** Nothing leaves the device unless the user turns on
   backup themselves. This is a product feature, not an implementation detail —
   it's the reason people will write honestly.
3. **Works offline, always.** Every prayer, verse, and flow is bundled in the
   app. No connection needed, ever. Faith doesn't wait for a signal.
4. **Fast in a crisis.** Rescue is a permanent bottom-tab. From temptation to
   the first Scripture on screen should be two taps and under five seconds.
5. **Calm, not gamified.** No points, no badges, no leaderboards, no confetti.
   The visual language is warm and reverent — deep greens, warm gold, cream —
   designed to feel like a quiet room, not a game.

---

## 6. Core Experience

Five permanent destinations in the bottom navigation:

| Tab | Purpose |
|---|---|
| **Home** | Today's dashboard — check in, see your verse, get one next step |
| **Scripture** | Verse library, saving, notes, and memorisation |
| **Rescue** | Emergency help in the moment of temptation or distress |
| **Journal** | Private writing — prayers, gratitude, confessions, reflections |
| **Profile** | Identity, progress summaries, settings, and the Armour of God |

---

## 7. Feature Specifications

### 7.1 Onboarding

A short, warm first-run that personalises everything downstream.

- **Name** — used throughout the app so it feels personal, not generic.
- **Focus areas** (choose any): Temptation and self-control · Anxiety and fear ·
  Anger and forgiveness · Purity and relationships · Prayer consistency · Bible
  reading discipline · Social media distraction · Stress and burnout ·
  Loneliness · Building stronger faith
- **Goals** (choose any, each with a frequency of Daily / 3× a week / Weekly):
  Pray daily · Read Scripture daily · Journal weekly · Practice gratitude ·
  Memorise Bible verses · Reduce distraction time · Join a fasting routine
- **Reminder times** — Morning (default 7:00am, on), Midday (12:30pm, off),
  Evening (9:00pm, on), and a "high-risk hour" reminder (10:00pm, off) for the
  time of day the user knows is hardest for them.

Chosen goals automatically switch on the matching daily practices, so the user
lands on a tracker already tailored to them rather than an empty list.

**Requirement:** Onboarding must be completable in under 90 seconds and must
never ask for an email, phone number, or account.

### 7.2 Home — Today's Dashboard

The screen that makes the app a daily habit.

- **Heart check-in.** "How is your heart today?" with nine moods: Peaceful,
  Hopeful, Grateful, Tired, Anxious, Tempted, Lonely, Angry, Discouraged. Each
  returns a short line of grace-centred support plus one relevant action — check
  in "Tempted" and the app offers Rescue; check in "Grateful" and it offers to
  help you write it down.
- **Verse of the day.** Rotates automatically each calendar day. Saveable in one
  tap.
- **One next step.** A single suggested action, chosen in priority order: first
  responding to today's mood, then to a practice still open today, then to the
  user's stated focus areas. Only ever one suggestion — never a to-do list.
- **Today's practices.** Quick-complete checkboxes for enabled habits.

**Requirement:** Home must be useful on day one with zero data, and must never
show more than one "you should" prompt at a time.

### 7.3 Rescue — Help in the Moment

The differentiating feature. Reachable in one tap from any screen.

The user picks what they're facing: **Lust / sexual temptation · Anxiety · Anger
· Addiction / unhealthy urge · Fear · Loneliness · Jealousy · Social media
distraction · Negative thoughts · Something else.**

The guided flow then walks them through:

1. **Breathe.** An animated breathing circle to physically slow down first.
2. **Scripture.** Verses chosen specifically for that struggle, with "read
   another verse" to cycle through more.
3. **Pray.** A guided prayer matched to the moment.
4. **Choose an action.** A concrete next step to break the moment — get up,
   call someone, put the phone down.
5. **Recovery.** A closing screen that asks how they came through it.

Sessions where the user came out stronger are counted in their progress — this
is the one number in the app that celebrates resistance.

**Requirements:**
- Rescue must work fully offline.
- No step may guilt or interrogate the user about what they did.
- Completing a flow is optional at every stage — the user can leave at any point
  and it still counts as having reached for help.

### 7.4 Scripture

- A curated library of verses organised by real-life need: Anxiety · Anger ·
  Discipline · Faith · Fear · Forgiveness · Healing · Hope · Identity in Christ ·
  Loneliness · Purity · Purpose · Self-Control · Stress · Temptation.
- **Save** any verse to a personal collection.
- **Add private notes** to saved verses.
- **Memorisation** — mark verses as being learned, and test recall with a memory
  quiz that hides words and asks the user to complete the verse.

### 7.5 Journal

The most private surface in the app, and the reason the privacy stance matters.

Six entry types: **Prayer · Gratitude · Reflection · Temptation Trigger ·
Answered Prayer · Personal Note.**

- Entries can be tagged with a mood and linked to a verse.
- **Answered prayer tracking** — mark any past prayer as answered. Over time
  this builds a record of prayers God has answered, which is one of the most
  encouraging things a user can look back on.
- An in-app journal privacy toggle for extra discretion.

**Requirement:** Journal entries are never uploaded, analysed, or used to
generate recommendations unless the user has explicitly turned on backup.

### 7.6 Daily Practices (Disciplines)

Habit-building without the shame.

- Eleven built-in practices: Morning prayer · Evening prayer · Bible reading ·
  Devotional · Journal reflection · Gratitude · Verse memorisation · Fasting ·
  Worship time · Helped someone · Reduced distractions.
- Users can add their own custom practices, rename them, choose an icon,
  reorder the list, switch practices on and off, and reset a single practice's
  history without touching the others.
- Each practice has a frequency — Daily, 3× a week, or Weekly — and streaks are
  measured against that target. Someone committed to praying three times a week
  keeps their streak by doing exactly that. The app never penalises a goal the
  user didn't set.

### 7.7 Sacred Focus

Timed sessions for undistracted time with God, in five modes: **Prayer · Bible
Reading · Worship · Quiet Reflection · Resist Distraction.**

Users choose a duration, optionally show a verse on screen and enable ambient
sound, and can write a short reflection when the timer ends.

### 7.8 Prayer Library

Twelve written prayers for the situations people actually reach for one:

Prayer for strength · when tempted · for purity · for anxiety · for forgiveness ·
when angry · before sleep · morning prayer · for discipline · for healing ·
for a loved one · after failure.

Each can be read in a guided view and saved as a favourite.

### 7.9 Progress

A gentle weekly picture, not a report card.

- Seven-day rhythm chart showing practice completion.
- Current streaks for prayer and Scripture reading.
- Weekly consistency across chosen practices.
- Number of rescue journeys completed.
- Most common mood this week, and the Scripture category the user saves from
  most — a quiet mirror on what they've been carrying.

### 7.10 The Armour of God

A reflective section built on Ephesians 6: the Belt of Truth, Breastplate of
Righteousness, Shoes of Peace, Shield of Faith, Helmet of Salvation, and Sword
of the Spirit. Each piece has a plain-language explanation, its Scripture, and a
reflection question. This is the app's namesake and its theological spine.

### 7.11 Reminders

Up to four daily reminders — morning, midday, evening, and a user-chosen
high-risk hour. All times are user-configurable and every reminder can be turned
off individually. Notifications are gentle invitations ("Begin the day anchored
in prayer"), never nags about missed streaks.

### 7.12 Backup — Optional

Off by default. When a user turns it on, their journey is backed up to a private
space only they can reach, so a lost or replaced phone doesn't mean losing years
of journal entries. They can back up on demand, restore, or delete the cloud copy
entirely at any time. No email or account is required even with backup enabled.

**Requirement:** The app must remain fully functional with backup off, forever.
Backup is a convenience, never a gate.

---

## 8. Explicitly Out of Scope (v1)

Stated deliberately, to keep the product focused:

- **No social or community features.** No sharing, feeds, friends, or
  accountability partners. Shame is the enemy of honesty here.
- **No full Bible reader.** Curated verses for real needs, not a replacement for
  a Bible app.
- **No analytics or behavioural tracking.** We do not watch what users do.
- **No ads.**
- **No AI-generated spiritual content.** Prayers and reflections are written and
  reviewed, not generated.
- **No login, email capture, or account system.**

---

## 9. Success Metrics

Chosen to reflect the mission rather than engagement-for-its-own-sake:

**Primary**
- **Day-30 retention** — is this actually becoming a daily practice?
- **Rescue flows completed** — is the app showing up in the moments that matter?
- **Journal entries per active user** — do people trust it enough to be honest?

**Secondary**
- Onboarding completion rate
- % of users with at least one practice active at day 7
- Answered prayers marked (a strong signal of long-term use)
- Reminder opt-in and retention rate

**Deliberately not optimised:** session length and daily open count. A user who
opens the app, prays for two minutes, and closes it has had a perfect session.

---

## 10. Future Considerations

Not committed, listed for direction:

- Extra encryption on journal entries, so even a backup is unreadable by anyone
  but the user.
- Optional account linking so users can move to a new phone by choice.
- Expanded verse and prayer libraries; seasonal and topical plans.
- Audio — spoken prayers and guided focus sessions.
- Scripture translation choice.
- Widgets and watch support for a verse or a one-tap Rescue from the home screen.
