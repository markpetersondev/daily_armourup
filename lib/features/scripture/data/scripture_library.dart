/// A verse in the local Scripture library, tagged with its category.
class LibraryVerse {
  const LibraryVerse({
    required this.text,
    required this.reference,
    required this.category,
  });

  final String text;
  final String reference;
  final String category;
}

const scriptureCategories = [
  'Temptation',
  'Anxiety',
  'Fear',
  'Purity',
  'Self-Control',
  'Anger',
  'Forgiveness',
  'Loneliness',
  'Identity in Christ',
  'Hope',
  'Faith',
  'Stress',
  'Discipline',
  'Healing',
  'Purpose',
];

const List<LibraryVerse> scriptureLibrary = [
  // Temptation
  LibraryVerse(
    text: 'No temptation has seized you except what is common to man. And God is faithful; He will not let you be tempted beyond what you can bear. But when you are tempted, He will also provide an escape, so that you can stand up under it.',
    reference: '1 Corinthians 10:13',
    category: 'Temptation',
  ),
  LibraryVerse(
    text: 'Watch and pray so that you will not enter into temptation. For the spirit is willing, but the body is weak.',
    reference: 'Matthew 26:41',
    category: 'Temptation',
  ),
  LibraryVerse(
    text: 'Submit yourselves, then, to God. Resist the devil, and he will flee from you.',
    reference: 'James 4:7',
    category: 'Temptation',
  ),
  // Anxiety
  LibraryVerse(
    text: 'Cast all your anxiety on Him, because He cares for you.',
    reference: '1 Peter 5:7',
    category: 'Anxiety',
  ),
  LibraryVerse(
    text: 'Be anxious for nothing, but in everything, by prayer and petition, with thanksgiving, present your requests to God.',
    reference: 'Philippians 4:6',
    category: 'Anxiety',
  ),
  LibraryVerse(
    text: 'Peace I leave with you; My peace I give to you. I do not give to you as the world gives. Do not let your hearts be troubled; do not be afraid.',
    reference: 'John 14:27',
    category: 'Anxiety',
  ),
  // Fear
  LibraryVerse(
    text: 'For God has not given us a spirit of fear, but of power, love, and self-control.',
    reference: '2 Timothy 1:7',
    category: 'Fear',
  ),
  LibraryVerse(
    text: 'Do not fear, for I am with you; do not be afraid, for I am your God. I will strengthen you; I will surely help you; I will uphold you with My righteous right hand.',
    reference: 'Isaiah 41:10',
    category: 'Fear',
  ),
  LibraryVerse(
    text: 'The LORD is my light and my salvation—whom shall I fear? The LORD is the stronghold of my life—whom shall I dread?',
    reference: 'Psalm 27:1',
    category: 'Fear',
  ),
  // Purity
  LibraryVerse(
    text: 'Create in me a clean heart, O God, and renew a right spirit within me.',
    reference: 'Psalm 51:10',
    category: 'Purity',
  ),
  LibraryVerse(
    text: 'How can a young man keep his way pure? By guarding it according to Your word.',
    reference: 'Psalm 119:9',
    category: 'Purity',
  ),
  LibraryVerse(
    text: 'Blessed are the pure in heart, for they will see God.',
    reference: 'Matthew 5:8',
    category: 'Purity',
  ),
  // Self-Control
  LibraryVerse(
    text: 'Like a city whose walls are broken down is a man who does not control his temper.',
    reference: 'Proverbs 25:28',
    category: 'Self-Control',
  ),
  LibraryVerse(
    text: 'But the fruit of the Spirit is love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, and self-control. Against such things there is no law.',
    reference: 'Galatians 5:22-23',
    category: 'Self-Control',
  ),
  // Anger
  LibraryVerse(
    text: 'A gentle answer turns away wrath, but a harsh word stirs up anger.',
    reference: 'Proverbs 15:1',
    category: 'Anger',
  ),
  LibraryVerse(
    text: 'Everyone should be quick to listen, slow to speak, and slow to anger.',
    reference: 'James 1:19',
    category: 'Anger',
  ),
  // Forgiveness
  LibraryVerse(
    text: 'Be kind and tenderhearted to one another, forgiving each other just as in Christ God forgave you.',
    reference: 'Ephesians 4:32',
    category: 'Forgiveness',
  ),
  LibraryVerse(
    text: 'If we confess our sins, He is faithful and just to forgive us our sins and to cleanse us from all unrighteousness.',
    reference: '1 John 1:9',
    category: 'Forgiveness',
  ),
  LibraryVerse(
    text: 'As far as the east is from the west, so far has He removed our transgressions from us.',
    reference: 'Psalm 103:12',
    category: 'Forgiveness',
  ),
  // Loneliness
  LibraryVerse(
    text: 'The LORD is near to the brokenhearted; He saves the contrite in spirit.',
    reference: 'Psalm 34:18',
    category: 'Loneliness',
  ),
  LibraryVerse(
    text: 'Never will I leave you, never will I forsake you.',
    reference: 'Hebrews 13:5',
    category: 'Loneliness',
  ),
  // Identity in Christ
  LibraryVerse(
    text: 'Therefore if anyone is in Christ, he is a new creation. The old has passed away. Behold, the new has come!',
    reference: '2 Corinthians 5:17',
    category: 'Identity in Christ',
  ),
  LibraryVerse(
    text: 'I praise You, for I am fearfully and wonderfully made. Marvelous are Your works, and I know this very well.',
    reference: 'Psalm 139:14',
    category: 'Identity in Christ',
  ),
  LibraryVerse(
    text: 'But you are a chosen people, a royal priesthood, a holy nation, a people for God’s own possession.',
    reference: '1 Peter 2:9',
    category: 'Identity in Christ',
  ),
  // Hope
  LibraryVerse(
    text: 'But those who wait upon the LORD will renew their strength; they will mount up with wings like eagles; they will run and not grow weary, they will walk and not faint.',
    reference: 'Isaiah 40:31',
    category: 'Hope',
  ),
  LibraryVerse(
    text: 'For I know the plans I have for you, declares the LORD, plans to prosper you and not to harm you, to give you a future and a hope.',
    reference: 'Jeremiah 29:11',
    category: 'Hope',
  ),
  // Faith
  LibraryVerse(
    text: 'Now faith is the assurance of what we hope for and the certainty of what we do not see.',
    reference: 'Hebrews 11:1',
    category: 'Faith',
  ),
  LibraryVerse(
    text: 'Trust in the LORD with all your heart, and lean not on your own understanding.',
    reference: 'Proverbs 3:5',
    category: 'Faith',
  ),
  // Stress
  LibraryVerse(
    text: 'Come to Me, all you who are weary and burdened, and I will give you rest.',
    reference: 'Matthew 11:28',
    category: 'Stress',
  ),
  LibraryVerse(
    text: 'Be still and know that I am God.',
    reference: 'Psalm 46:10',
    category: 'Stress',
  ),
  // Discipline
  LibraryVerse(
    text: 'No discipline seems enjoyable at the time, but painful. Later on, however, it yields a harvest of righteousness and peace to those who have been trained by it.',
    reference: 'Hebrews 12:11',
    category: 'Discipline',
  ),
  LibraryVerse(
    text: 'Do you not know that in a race all the runners run, but only one receives the prize? Run in such a way as to take the prize.',
    reference: '1 Corinthians 9:24',
    category: 'Discipline',
  ),
  // Healing
  LibraryVerse(
    text: 'He heals the brokenhearted and binds up their wounds.',
    reference: 'Psalm 147:3',
    category: 'Healing',
  ),
  LibraryVerse(
    text: 'Heal me, O LORD, and I will be healed; save me, and I will be saved, for You are my praise.',
    reference: 'Jeremiah 17:14',
    category: 'Healing',
  ),
  // Purpose
  LibraryVerse(
    text: 'For we are God’s workmanship, created in Christ Jesus to do good works, which God prepared in advance as our way of life.',
    reference: 'Ephesians 2:10',
    category: 'Purpose',
  ),
  LibraryVerse(
    text: 'And we know that God works all things together for the good of those who love Him, who are called according to His purpose.',
    reference: 'Romans 8:28',
    category: 'Purpose',
  ),
];
