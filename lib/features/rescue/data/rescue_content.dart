import 'package:flutter/material.dart';

import '../../../shared/models/verse.dart';

/// The struggles a Rescue journey can be tailored to.
enum RescueCategory {
  lust('Lust / sexual temptation', Icons.spa_outlined),
  anxiety('Anxiety', Icons.air_outlined),
  anger('Anger', Icons.local_fire_department_outlined),
  addiction('Addiction / unhealthy urge', Icons.link_off_outlined),
  fear('Fear', Icons.dark_mode_outlined),
  loneliness('Loneliness', Icons.person_outline),
  jealousy('Jealousy', Icons.visibility_outlined),
  socialMedia('Social media distraction', Icons.phone_iphone_outlined),
  negativeThoughts('Negative thoughts', Icons.psychology_outlined),
  other('Something else', Icons.shield_outlined);

  const RescueCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Scriptures for each rescue category. The first verse is shown first;
/// "Read another verse" cycles through the rest.
const Map<RescueCategory, List<Verse>> rescueVerses = {
  RescueCategory.lust: [
    Verse(
      text: 'No temptation has overtaken you except what is common to mankind. And God is faithful; he will not let you be tempted beyond what you can bear.',
      reference: '1 Corinthians 10:13',
    ),
    Verse(
      text: 'How can a young person stay on the path of purity? By living according to your word.',
      reference: 'Psalm 119:9',
    ),
    Verse(
      text: 'Create in me a pure heart, O God, and renew a steadfast spirit within me.',
      reference: 'Psalm 51:10',
    ),
  ],
  RescueCategory.anxiety: [
    Verse(
      text: 'Cast all your anxiety on him because he cares for you.',
      reference: '1 Peter 5:7',
    ),
    Verse(
      text: 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.',
      reference: 'Philippians 4:6',
    ),
    Verse(
      text: 'Peace I leave with you; my peace I give you. Do not let your hearts be troubled and do not be afraid.',
      reference: 'John 14:27',
    ),
  ],
  RescueCategory.anger: [
    Verse(
      text: 'A gentle answer turns away wrath, but a harsh word stirs up anger.',
      reference: 'Proverbs 15:1',
    ),
    Verse(
      text: 'Everyone should be quick to listen, slow to speak and slow to become angry.',
      reference: 'James 1:19',
    ),
    Verse(
      text: 'In your anger do not sin: do not let the sun go down while you are still angry.',
      reference: 'Ephesians 4:26',
    ),
  ],
  RescueCategory.addiction: [
    Verse(
      text: 'It is for freedom that Christ has set us free. Stand firm, then, and do not let yourselves be burdened again by a yoke of slavery.',
      reference: 'Galatians 5:1',
    ),
    Verse(
      text: 'So if the Son sets you free, you will be free indeed.',
      reference: 'John 8:36',
    ),
    Verse(
      text: 'I can do all this through him who gives me strength.',
      reference: 'Philippians 4:13',
    ),
  ],
  RescueCategory.fear: [
    Verse(
      text: 'For God has not given us a spirit of fear, but of power and of love and of a sound mind.',
      reference: '2 Timothy 1:7',
    ),
    Verse(
      text: 'When I am afraid, I put my trust in you.',
      reference: 'Psalm 56:3',
    ),
    Verse(
      text: 'So do not fear, for I am with you; do not be dismayed, for I am your God.',
      reference: 'Isaiah 41:10',
    ),
  ],
  RescueCategory.loneliness: [
    Verse(
      text: 'The Lord is close to the brokenhearted and saves those who are crushed in spirit.',
      reference: 'Psalm 34:18',
    ),
    Verse(
      text: 'Never will I leave you; never will I forsake you.',
      reference: 'Hebrews 13:5',
    ),
    Verse(
      text: 'God sets the lonely in families.',
      reference: 'Psalm 68:6',
    ),
  ],
  RescueCategory.jealousy: [
    Verse(
      text: 'A heart at peace gives life to the body, but envy rots the bones.',
      reference: 'Proverbs 14:30',
    ),
    Verse(
      text: 'Love is patient, love is kind. It does not envy, it does not boast, it is not proud.',
      reference: '1 Corinthians 13:4',
    ),
    Verse(
      text: 'But godliness with contentment is great gain.',
      reference: '1 Timothy 6:6',
    ),
  ],
  RescueCategory.socialMedia: [
    Verse(
      text: 'Set your minds on things above, not on earthly things.',
      reference: 'Colossians 3:2',
    ),
    Verse(
      text: 'Be very careful, then, how you live — not as unwise but as wise, making the most of every opportunity.',
      reference: 'Ephesians 5:15-16',
    ),
    Verse(
      text: 'Teach us to number our days, that we may gain a heart of wisdom.',
      reference: 'Psalm 90:12',
    ),
  ],
  RescueCategory.negativeThoughts: [
    Verse(
      text: 'We take captive every thought to make it obedient to Christ.',
      reference: '2 Corinthians 10:5',
    ),
    Verse(
      text: 'Whatever is true, whatever is noble, whatever is right, whatever is pure, whatever is lovely — think about such things.',
      reference: 'Philippians 4:8',
    ),
    Verse(
      text: 'You will keep in perfect peace those whose minds are steadfast, because they trust in you.',
      reference: 'Isaiah 26:3',
    ),
  ],
  RescueCategory.other: [
    Verse(
      text: 'The Lord is my strength and my shield; my heart trusts in him, and he helps me.',
      reference: 'Psalm 28:7',
    ),
    Verse(
      text: 'God is our refuge and strength, an ever-present help in trouble.',
      reference: 'Psalm 46:1',
    ),
    Verse(
      text: 'Come to me, all you who are weary and burdened, and I will give you rest.',
      reference: 'Matthew 11:28',
    ),
  ],
};

/// Category-specific guided prayers, written line by line so the
/// "Pray This Slowly" mode can reveal them one line at a time.
const Map<RescueCategory, List<String>> rescuePrayers = {
  RescueCategory.lust: [
    'Lord, give me strength in this moment.',
    'Help me turn away from what pulls me from You.',
    'Fill my heart with peace, self-control, and courage.',
    'I choose to trust You one step at a time.',
    'Amen.',
  ],
  RescueCategory.anxiety: [
    'Father, my heart feels heavy and restless.',
    'I hand You each worry, one by one.',
    'Breathe Your peace into the places fear has filled.',
    'Hold me steady, for You care for me.',
    'Amen.',
  ],
  RescueCategory.anger: [
    'Lord, this anger burns hot within me.',
    'Slow my heart. Soften my words.',
    'Help me release what I cannot control into Your hands.',
    'Let Your gentleness lead me now.',
    'Amen.',
  ],
  RescueCategory.addiction: [
    'Jesus, You are stronger than this pull on me.',
    'I bring my weakness into Your light.',
    'Break the chain of this urge, link by link.',
    'Lead me into the freedom You paid for.',
    'Amen.',
  ],
  RescueCategory.fear: [
    'God, You have not given me a spirit of fear.',
    'I choose power, love, and a sound mind.',
    'Stand with me in this shadow.',
    'You are bigger than what I am facing.',
    'Amen.',
  ],
  RescueCategory.loneliness: [
    'Father, I feel unseen and far away.',
    'Remind me that You are closer than my breath.',
    'Fill this quiet with Your presence.',
    'Lead me toward the people You have for me.',
    'Amen.',
  ],
  RescueCategory.jealousy: [
    'Lord, envy has crept into my heart.',
    'Teach me to celebrate what You give others.',
    'Open my eyes to the gifts already in my hands.',
    'Make contentment my quiet strength.',
    'Amen.',
  ],
  RescueCategory.socialMedia: [
    'Father, my attention is scattered and pulled thin.',
    'Gather my mind back to what matters.',
    'Give me courage to put this distraction down.',
    'Set my eyes on things above.',
    'Amen.',
  ],
  RescueCategory.negativeThoughts: [
    'Lord, my thoughts are turning against me.',
    'I take each one captive and hand it to You.',
    'Replace the lies with what is true and lovely.',
    'Renew my mind in Your peace.',
    'Amen.',
  ],
  RescueCategory.other: [
    'Lord, You know what I carry right now, even when words are hard.',
    'Meet me in this moment.',
    'Steady my heart and clear my mind.',
    'I take the next faithful step with You.',
    'Amen.',
  ],
};

/// Practical next-step actions offered in Step 4 of the Rescue flow.
class RescueAction {
  const RescueAction({required this.label, required this.icon, this.route});

  final String label;
  final IconData icon;

  /// Optional in-app route this action opens after completing the flow.
  final String? route;
}

const rescueActions = [
  RescueAction(label: 'Move away from the trigger', icon: Icons.directions_walk_outlined),
  RescueAction(label: 'Put your phone down for 10 minutes', icon: Icons.phonelink_erase_outlined),
  RescueAction(label: 'Drink water', icon: Icons.water_drop_outlined),
  RescueAction(label: 'Go for a short walk', icon: Icons.park_outlined),
  RescueAction(label: 'Message an accountability partner', icon: Icons.chat_bubble_outline),
  RescueAction(label: 'Start a focus session', icon: Icons.self_improvement_outlined, route: '/focus'),
  RescueAction(label: 'Read another verse', icon: Icons.menu_book_outlined, route: '/scripture'),
  RescueAction(label: 'Write in journal', icon: Icons.edit_note_outlined, route: '/journal'),
];

/// Forgiveness content for the Recovery flow.
const recoveryVerse = Verse(
  text: 'If we confess our sins, he is faithful and just and will forgive us our sins and purify us from all unrighteousness.',
  reference: '1 John 1:9',
);

const recoveryPrayer = [
  'Father, I come back to You just as I am.',
  'I confess this moment and lay it at Your feet.',
  'Thank You that Your mercy is new this very minute.',
  'Wash me, teach me, and walk with me from here.',
  'I begin again with You.',
  'Amen.',
];
