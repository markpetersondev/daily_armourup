/// Questions and answers shown on the in-app Help & FAQ screen.
///
/// Keep this in step with the support page at `AppStrings.supportUrl`
/// (support.html in the armour-up-privacy repo).
class FaqItem {
  const FaqItem(this.question, this.answer);

  final String question;
  final String answer;
}

const faqItems = [
  FaqItem(
    'Do I need an account?',
    'No. There is no sign-up, login or email. Open the app and begin.',
  ),
  FaqItem(
    'Where is my data stored?',
    'Only on your phone. Your journal, prayers, moods and practices never leave '
        'your device. We cannot see them, and nothing is uploaded.',
  ),
  FaqItem(
    'Is my data backed up?',
    'Not by the app. On Android, app data is left out of Google backups to keep '
        'it private. On iPhone, it may be included in your own iCloud device '
        'backup. If you delete the app or reset it, your data is gone for good.',
  ),
  FaqItem(
    'How do I erase everything?',
    'Go to Profile, then Reset all app data. Uninstalling the app also erases '
        'everything.',
  ),
  FaqItem(
    'Does it work without internet?',
    'Yes. All Scripture, prayers and guided flows are built into the app.',
  ),
  FaqItem(
    'Which Bible translation do you use?',
    'The Berean Standard Bible (BSB), which is dedicated to the public domain.',
  ),
  FaqItem(
    'What is Rescue?',
    'A guided path for hard moments: breathe, read Scripture chosen for what '
        'you are facing, pray, take a concrete next step, and check in. Leaving '
        'early still counts as reaching for help.',
  ),
  FaqItem(
    'Is this a replacement for counselling or professional help?',
    'No. Armour Up Daily supports your walk with God, but it is not medical or '
        'mental health care. If you are in danger or thinking about harming '
        'yourself, contact your local emergency number or a crisis line straight '
        'away.',
  ),
  FaqItem(
    'Why don\'t I get reminders?',
    'Reminders are not in this version yet. They are planned for a future '
        'update.',
  ),
  FaqItem(
    'My streak reset. Why?',
    'Daily practices count consecutive days. If a day is missed, the streak '
        'begins again, and grace covers every day.',
  ),
  FaqItem(
    'How do I suggest a feature or report a problem?',
    'Tap Contact us below. Your app version is added to the email '
        'automatically; please include your phone model and what happened.',
  ),
];
