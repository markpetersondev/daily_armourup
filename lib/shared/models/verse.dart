/// A Scripture verse shown in the daily rotation.
class Verse {
  const Verse({required this.text, required this.reference});

  final String text;
  final String reference;
}

/// Local verse data for the Home rotation — no network required.
const List<Verse> dailyVerses = [
  Verse(
    text: 'The Lord is my strength and my shield; my heart trusts in him, and he helps me.',
    reference: 'Psalm 28:7',
  ),
  Verse(
    text: 'Put on the full armor of God, so that you can take your stand against the devil\'s schemes.',
    reference: 'Ephesians 6:11',
  ),
  Verse(
    text: 'No temptation has overtaken you except what is common to mankind. And God is faithful; he will not let you be tempted beyond what you can bear.',
    reference: '1 Corinthians 10:13',
  ),
  Verse(
    text: 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.',
    reference: 'Philippians 4:6',
  ),
  Verse(
    text: 'Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.',
    reference: 'Joshua 1:9',
  ),
  Verse(
    text: 'Come to me, all you who are weary and burdened, and I will give you rest.',
    reference: 'Matthew 11:28',
  ),
  Verse(
    text: 'I can do all this through him who gives me strength.',
    reference: 'Philippians 4:13',
  ),
  Verse(
    text: 'The Lord is close to the brokenhearted and saves those who are crushed in spirit.',
    reference: 'Psalm 34:18',
  ),
  Verse(
    text: 'But those who hope in the Lord will renew their strength. They will soar on wings like eagles.',
    reference: 'Isaiah 40:31',
  ),
  Verse(
    text: 'Watch and pray so that you will not fall into temptation. The spirit is willing, but the flesh is weak.',
    reference: 'Matthew 26:41',
  ),
];
