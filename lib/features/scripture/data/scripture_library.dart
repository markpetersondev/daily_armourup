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
    text: 'No temptation has overtaken you except what is common to mankind. And God is faithful; he will not let you be tempted beyond what you can bear.',
    reference: '1 Corinthians 10:13',
    category: 'Temptation',
  ),
  LibraryVerse(
    text: 'Watch and pray so that you will not fall into temptation. The spirit is willing, but the flesh is weak.',
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
    text: 'Cast all your anxiety on him because he cares for you.',
    reference: '1 Peter 5:7',
    category: 'Anxiety',
  ),
  LibraryVerse(
    text: 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.',
    reference: 'Philippians 4:6',
    category: 'Anxiety',
  ),
  LibraryVerse(
    text: 'Peace I leave with you; my peace I give you. Do not let your hearts be troubled and do not be afraid.',
    reference: 'John 14:27',
    category: 'Anxiety',
  ),
  // Fear
  LibraryVerse(
    text: 'For God has not given us a spirit of fear, but of power and of love and of a sound mind.',
    reference: '2 Timothy 1:7',
    category: 'Fear',
  ),
  LibraryVerse(
    text: 'So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you.',
    reference: 'Isaiah 41:10',
    category: 'Fear',
  ),
  LibraryVerse(
    text: 'The Lord is my light and my salvation — whom shall I fear?',
    reference: 'Psalm 27:1',
    category: 'Fear',
  ),
  // Purity
  LibraryVerse(
    text: 'Create in me a pure heart, O God, and renew a steadfast spirit within me.',
    reference: 'Psalm 51:10',
    category: 'Purity',
  ),
  LibraryVerse(
    text: 'How can a young person stay on the path of purity? By living according to your word.',
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
    text: 'Like a city whose walls are broken through is a person who lacks self-control.',
    reference: 'Proverbs 25:28',
    category: 'Self-Control',
  ),
  LibraryVerse(
    text: 'But the fruit of the Spirit is love, joy, peace, forbearance, kindness, goodness, faithfulness, gentleness and self-control.',
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
    text: 'Everyone should be quick to listen, slow to speak and slow to become angry.',
    reference: 'James 1:19',
    category: 'Anger',
  ),
  // Forgiveness
  LibraryVerse(
    text: 'Be kind and compassionate to one another, forgiving each other, just as in Christ God forgave you.',
    reference: 'Ephesians 4:32',
    category: 'Forgiveness',
  ),
  LibraryVerse(
    text: 'If we confess our sins, he is faithful and just and will forgive us our sins and purify us from all unrighteousness.',
    reference: '1 John 1:9',
    category: 'Forgiveness',
  ),
  LibraryVerse(
    text: 'As far as the east is from the west, so far has he removed our transgressions from us.',
    reference: 'Psalm 103:12',
    category: 'Forgiveness',
  ),
  // Loneliness
  LibraryVerse(
    text: 'The Lord is close to the brokenhearted and saves those who are crushed in spirit.',
    reference: 'Psalm 34:18',
    category: 'Loneliness',
  ),
  LibraryVerse(
    text: 'Never will I leave you; never will I forsake you.',
    reference: 'Hebrews 13:5',
    category: 'Loneliness',
  ),
  // Identity in Christ
  LibraryVerse(
    text: 'Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here!',
    reference: '2 Corinthians 5:17',
    category: 'Identity in Christ',
  ),
  LibraryVerse(
    text: 'I praise you because I am fearfully and wonderfully made; your works are wonderful, I know that full well.',
    reference: 'Psalm 139:14',
    category: 'Identity in Christ',
  ),
  LibraryVerse(
    text: 'But you are a chosen people, a royal priesthood, a holy nation, God\'s special possession.',
    reference: '1 Peter 2:9',
    category: 'Identity in Christ',
  ),
  // Hope
  LibraryVerse(
    text: 'But those who hope in the Lord will renew their strength. They will soar on wings like eagles.',
    reference: 'Isaiah 40:31',
    category: 'Hope',
  ),
  LibraryVerse(
    text: '“For I know the plans I have for you,” declares the Lord, “plans to prosper you and not to harm you, plans to give you hope and a future.”',
    reference: 'Jeremiah 29:11',
    category: 'Hope',
  ),
  // Faith
  LibraryVerse(
    text: 'Now faith is confidence in what we hope for and assurance about what we do not see.',
    reference: 'Hebrews 11:1',
    category: 'Faith',
  ),
  LibraryVerse(
    text: 'Trust in the Lord with all your heart and lean not on your own understanding.',
    reference: 'Proverbs 3:5',
    category: 'Faith',
  ),
  // Stress
  LibraryVerse(
    text: 'Come to me, all you who are weary and burdened, and I will give you rest.',
    reference: 'Matthew 11:28',
    category: 'Stress',
  ),
  LibraryVerse(
    text: 'Be still, and know that I am God.',
    reference: 'Psalm 46:10',
    category: 'Stress',
  ),
  // Discipline
  LibraryVerse(
    text: 'No discipline seems pleasant at the time, but painful. Later on, however, it produces a harvest of righteousness and peace.',
    reference: 'Hebrews 12:11',
    category: 'Discipline',
  ),
  LibraryVerse(
    text: 'Do you not know that in a race all the runners run, but only one gets the prize? Run in such a way as to get the prize.',
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
    text: 'Heal me, Lord, and I will be healed; save me and I will be saved, for you are the one I praise.',
    reference: 'Jeremiah 17:14',
    category: 'Healing',
  ),
  // Purpose
  LibraryVerse(
    text: 'For we are God\'s handiwork, created in Christ Jesus to do good works, which God prepared in advance for us to do.',
    reference: 'Ephesians 2:10',
    category: 'Purpose',
  ),
  LibraryVerse(
    text: 'And we know that in all things God works for the good of those who love him, who have been called according to his purpose.',
    reference: 'Romans 8:28',
    category: 'Purpose',
  ),
];
