/// A Scripture verse shown in the daily rotation.
class Verse {
  const Verse({required this.text, required this.reference});

  final String text;
  final String reference;
}

/// Local verse data for the Home rotation — no network required.
const List<Verse> dailyVerses = [
  Verse(
    text: 'The LORD is my strength and my shield; my heart trusts in Him, and I am helped.',
    reference: 'Psalm 28:7',
  ),
  Verse(
    text: 'Put on the full armor of God, so that you can make your stand against the devil’s schemes.',
    reference: 'Ephesians 6:11',
  ),
  Verse(
    text: 'No temptation has seized you except what is common to man. And God is faithful; He will not let you be tempted beyond what you can bear. But when you are tempted, He will also provide an escape, so that you can stand up under it.',
    reference: '1 Corinthians 10:13',
  ),
  Verse(
    text: 'Be anxious for nothing, but in everything, by prayer and petition, with thanksgiving, present your requests to God.',
    reference: 'Philippians 4:6',
  ),
  Verse(
    text: 'Have I not commanded you to be strong and courageous? Do not be afraid; do not be discouraged, for the LORD your God is with you wherever you go.',
    reference: 'Joshua 1:9',
  ),
  Verse(
    text: 'Come to Me, all you who are weary and burdened, and I will give you rest.',
    reference: 'Matthew 11:28',
  ),
  Verse(
    text: 'I can do all things through Christ who gives me strength.',
    reference: 'Philippians 4:13',
  ),
  Verse(
    text: 'The LORD is near to the brokenhearted; He saves the contrite in spirit.',
    reference: 'Psalm 34:18',
  ),
  Verse(
    text: 'But those who wait upon the LORD will renew their strength; they will mount up with wings like eagles; they will run and not grow weary, they will walk and not faint.',
    reference: 'Isaiah 40:31',
  ),
  Verse(
    text: 'Watch and pray so that you will not enter into temptation. For the spirit is willing, but the body is weak.',
    reference: 'Matthew 26:41',
  ),
];
