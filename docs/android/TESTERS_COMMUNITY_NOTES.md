# Testers Community: Research Notes

Researched on 15 Nov 2026 from the company's own pages and Trustpilot, to decide how to
set up the closed test before paying. See [PLAY_CLOSED_TESTING_GUIDE.md](PLAY_CLOSED_TESTING_GUIDE.md)
for the full closed-testing plan.

- Website: https://www.testerscommunity.com/
- Support: support@testerscommunity.com
- Pages read: home, [How it works](https://www.testerscommunity.com/how-it-works),
  [FAQ](https://www.testerscommunity.com/faq),
  [Refund policy](https://www.testerscommunity.com/refund-policy),
  [Trustpilot](https://www.trustpilot.com/review/testerscommunity.com)

## Summary

| Question | Answer |
|---|---|
| Do they need a Google Group? | **Probably yes.** The home page says to add their Google Group to your closed test's Testers list. The FAQ instead says you "paste the tester list". Confirm with support before paying |
| What else do they need? | Your opt-in link, entered in their dashboard form. Never your Play Console login |
| When does testing start? | Within about 6 hours of submitting |
| Price | Starter **LKR 3,999** (15 testers). Pro **LKR 6,699** (25 testers) |
| Feedback report | **Included in both plans**, downloadable from about day 10 |
| Production form answers | Pre-filled answers included in both plans |
| Guarantee | Full refund **or** a free 14-day retry, only if Google **rejects** production access |
| Tester replacement | **Not mentioned anywhere.** Ask support |

**Decision:** the **Starter** plan is enough. Pro only adds 10 more testers, an ASO report and
priority support.

## Plans

| | Starter | Pro |
|---|---|---|
| Price per app | LKR 3,999 | LKR 6,699 |
| Testers | 15 | 25 |
| Feedback report | Yes | Yes |
| Pre-filled production form answers | Yes | Yes |
| ASO report | No | Yes |
| Support | Email | Priority |

An optional "Deep Testing" add-on (2 senior testers, 52-point QA report) is offered with any
plan. Its price wasn't shown.

## How it works (from their site)

1. Pay once per app (Stripe).
2. Submit the app in their dashboard with your **opt-in link**.
3. Add **their Google Group** to your closed test's Testers in Play Console, copying the address
   from your dashboard.
4. Testers are assigned and start within about 6 hours, and use the app daily.
5. Feedback reports and pre-filled production form answers arrive by about day 10.
6. Apply for production after 14 days. They run the test for 16 days as a buffer.

Other points from the FAQ:

- Only the **closed testing** track counts. Internal and open testing don't.
- Testers don't need to be in your launch countries.
- Uploading a new version during the test **doesn't reset** the 14-day clock.
- Testers who never accept the invite don't count.
- They say testers are paid people on real Android devices, not emulators or bots. This is
  their claim and can't be checked.

## Guarantee and refund terms

From the refund policy:

- Applies **only if Google rejects production access** after the 14-day test.
- You choose either a **full refund** or a **free retry** (another 14 days of testing).
- **Claim within 14 days** of Google's rejection email.
- To claim, email support@testerscommunity.com with:
  - your account email,
  - proof of purchase (Stripe receipt), and
  - **Google's rejection email**. Requests without it may be denied.
- They reply in about 3–5 business days. Refunds take about 7 business days.
- **No partial refunds.**
- Not covered: delays, testers dropping out, or anything other than a Google rejection.

**Keep:** the Stripe receipt, a screenshot of the plan and guarantee at checkout, and any
Google emails.

## Trustpilot

As shown on 15 Nov 2026:

- TrustScore **5.0**, **2,105 reviews**, 98% five-star.
- Recent reviews (Oct–Nov 2026) mostly say they got production access, some on the first try.
  Several mention the 16-day run and reports arriving as promised.
- No recent complaints about dropouts, rejections or refunds. One reviewer had to fix Play
  Console settings twice before testers could get in.

**Caution:** almost all 2,105 reviews are from the last 12 months and nearly all are five-star.
That pattern can mean incentivised or very selective reviews. Trustpilot itself says it doesn't
fact-check reviews. Treat the reviews as a good sign, not proof.

## Gaps and contradictions to check with support

Email support@testerscommunity.com **before paying**:

1. Do I add **your Google Group** to Play Console, or **paste a list of tester emails**?
2. Can I **keep my own testers** too? (Play Console lets a track use either email lists or
   Google Groups, not both.)
3. If testers drop out, do you **replace** them so the count stays at 12 or more?
4. The How-it-works timeline mentions 25 testers, but Starter lists 15. How many does Starter get?
5. Does anything I do void the guarantee, such as removing your group or changing the track?

## Plan for Armour Up Daily

To be ready either way, set up a Google Group for your own testers in advance:

1. Go to https://groups.google.com → **Create group**.
   - Name: `ArmourUp Testers`
   - Email: e.g. `armourup-testers@googlegroups.com`
   - Who can join: **invited users only**
2. Add your own testers as members: hustlebluprint@gmail.com plus your 7 friends and family.
3. **If Testers Community gives you a Google Group:** in Play Console, go to **Closed testing →
   Alpha → Testers → Google Groups** and enter both groups, separated by a comma:
   ```
   armourup-testers@googlegroups.com, <their-group>@googlegroups.com
   ```
   Then save.
4. **If they give you a list of emails instead:** keep **Email lists** and paste their emails into
   the "ArmourUp testers" list. You won't need your own group.

**When to pay:** after Google approves the closed testing release and the opt-in link appears.
