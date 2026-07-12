import 'package:flutter/material.dart';

import '../../../shared/models/verse.dart';

/// A guided prayer in the local library. [lines] powers the
/// line-by-line "Pray Now" mode.
class Prayer {
  const Prayer({
    required this.id,
    required this.title,
    required this.icon,
    required this.verse,
    required this.lines,
    required this.reflectionPrompt,
  });

  final String id;
  final String title;
  final IconData icon;
  final Verse verse;
  final List<String> lines;
  final String reflectionPrompt;

  String get body => lines.join(' ');

  /// Rough reading estimate at a slow, prayerful pace.
  Duration get estimatedDuration {
    final words = body.split(' ').length;
    return Duration(seconds: (words / 1.5).ceil().clamp(30, 600));
  }
}

const List<Prayer> prayerLibrary = [
  Prayer(
    id: 'strength',
    title: 'Prayer for strength',
    icon: Icons.fitness_center_outlined,
    verse: Verse(
      text: 'The Lord is my strength and my shield; my heart trusts in him, and he helps me.',
      reference: 'Psalm 28:7',
    ),
    lines: [
      'Father, my own strength runs thin today.',
      'Be the shield I stand behind and the strength beneath my steps.',
      'When I am weary, carry me.',
      'When I waver, hold me steady.',
      'I trust You for this hour, and the next.',
      'Amen.',
    ],
    reflectionPrompt: 'Where do you most need God\'s strength today?',
  ),
  Prayer(
    id: 'tempted',
    title: 'Prayer when tempted',
    icon: Icons.shield_outlined,
    verse: Verse(
      text: 'Watch and pray so that you will not fall into temptation.',
      reference: 'Matthew 26:41',
    ),
    lines: [
      'Lord, give me strength in this moment.',
      'Help me turn away from what pulls me from You.',
      'Show me the way out You have promised.',
      'Fill my heart with peace, self-control, and courage.',
      'I choose to trust You one step at a time.',
      'Amen.',
    ],
    reflectionPrompt: 'What is one faithful step you can take right now?',
  ),
  Prayer(
    id: 'purity',
    title: 'Prayer for purity',
    icon: Icons.spa_outlined,
    verse: Verse(
      text: 'Create in me a pure heart, O God, and renew a steadfast spirit within me.',
      reference: 'Psalm 51:10',
    ),
    lines: [
      'God, make my heart clean and my eyes careful.',
      'Guard what I look at, dwell on, and desire.',
      'Where old habits pull, build new paths.',
      'Renew a steadfast spirit within me.',
      'Amen.',
    ],
    reflectionPrompt: 'What helps you guard your heart best?',
  ),
  Prayer(
    id: 'anxiety',
    title: 'Prayer for anxiety',
    icon: Icons.air_outlined,
    verse: Verse(
      text: 'Cast all your anxiety on him because he cares for you.',
      reference: '1 Peter 5:7',
    ),
    lines: [
      'Father, my mind is racing ahead of me.',
      'One by one, I hand You my worries.',
      'Trade my what-ifs for Your promises.',
      'Let Your peace stand guard over my heart and mind.',
      'Amen.',
    ],
    reflectionPrompt: 'Which worry can you hand to God first?',
  ),
  Prayer(
    id: 'forgiveness',
    title: 'Prayer for forgiveness',
    icon: Icons.volunteer_activism_outlined,
    verse: Verse(
      text: 'If we confess our sins, he is faithful and just and will forgive us our sins.',
      reference: '1 John 1:9',
    ),
    lines: [
      'Father, I bring what I have done into Your light.',
      'I am sorry, and I turn from it.',
      'Thank You that Your mercy is greater than my worst day.',
      'Wash me clean and help me walk in freedom.',
      'Amen.',
    ],
    reflectionPrompt: 'What does it feel like to be fully forgiven?',
  ),
  Prayer(
    id: 'angry',
    title: 'Prayer when angry',
    icon: Icons.local_fire_department_outlined,
    verse: Verse(
      text: 'A gentle answer turns away wrath, but a harsh word stirs up anger.',
      reference: 'Proverbs 15:1',
    ),
    lines: [
      'Lord, this anger is loud inside me.',
      'Slow my heart before I speak.',
      'Show me what is mine to release and Yours to judge.',
      'Let gentleness win in me today.',
      'Amen.',
    ],
    reflectionPrompt: 'What is underneath this anger?',
  ),
  Prayer(
    id: 'sleep',
    title: 'Prayer before sleep',
    icon: Icons.nightlight_outlined,
    verse: Verse(
      text: 'In peace I will lie down and sleep, for you alone, Lord, make me dwell in safety.',
      reference: 'Psalm 4:8',
    ),
    lines: [
      'Father, the day is done and I place it in Your hands.',
      'Forgive what fell short. Keep what was good.',
      'Quiet my thoughts and guard my dreams.',
      'I rest because You stay awake.',
      'Amen.',
    ],
    reflectionPrompt: 'What are you most grateful for from today?',
  ),
  Prayer(
    id: 'morning',
    title: 'Morning prayer',
    icon: Icons.wb_sunny_outlined,
    verse: Verse(
      text: 'Because of the Lord\'s great love we are not consumed, for his compassions never fail. They are new every morning.',
      reference: 'Lamentations 3:22-23',
    ),
    lines: [
      'Good morning, Father. This day is Yours before it is mine.',
      'Set my heart on You before the noise begins.',
      'Order my steps, my words, and my thoughts.',
      'Let me walk today one faithful step at a time.',
      'Amen.',
    ],
    reflectionPrompt: 'What is one thing you want to walk through with God today?',
  ),
  Prayer(
    id: 'discipline',
    title: 'Prayer for discipline',
    icon: Icons.timer_outlined,
    verse: Verse(
      text: 'No discipline seems pleasant at the time, but painful. Later on, however, it produces a harvest.',
      reference: 'Hebrews 12:11',
    ),
    lines: [
      'Lord, I want to be faithful in the small things.',
      'Strengthen me to keep showing up — in prayer, in Your Word, in my commitments.',
      'When motivation fades, be my reason.',
      'Grow in me a harvest of righteousness and peace.',
      'Amen.',
    ],
    reflectionPrompt: 'Which small habit matters most to keep this week?',
  ),
  Prayer(
    id: 'healing',
    title: 'Prayer for healing',
    icon: Icons.healing_outlined,
    verse: Verse(
      text: 'He heals the brokenhearted and binds up their wounds.',
      reference: 'Psalm 147:3',
    ),
    lines: [
      'Father, You see the places that hurt — in my body, my mind, my heart.',
      'Bring Your healing where medicine and time cannot reach.',
      'Bind up what is broken in me.',
      'And while I wait, be my comfort and my hope.',
      'Amen.',
    ],
    reflectionPrompt: 'Where are you inviting God\'s healing today?',
  ),
  Prayer(
    id: 'loved_one',
    title: 'Prayer for a loved one',
    icon: Icons.favorite_outline,
    verse: Verse(
      text: 'I pray that out of his glorious riches he may strengthen you with power through his Spirit in your inner being.',
      reference: 'Ephesians 3:16',
    ),
    lines: [
      'Father, I lift up someone I love to You now.',
      'You know their name, their needs, and their heart.',
      'Protect them, provide for them, and draw them close to You.',
      'Do in their life what I cannot.',
      'Amen.',
    ],
    reflectionPrompt: 'Who are you praying for, and what do they need most?',
  ),
  Prayer(
    id: 'after_failure',
    title: 'Prayer after failure',
    icon: Icons.restart_alt_outlined,
    verse: Verse(
      text: 'Though the righteous fall seven times, they rise again.',
      reference: 'Proverbs 24:16',
    ),
    lines: [
      'Father, I fell — and I am tempted to stay down.',
      'Thank You that falling is not the end of my story.',
      'Lift my eyes from my failure to Your faithfulness.',
      'Teach me what this moment has to teach.',
      'I begin again with You, right now.',
      'Amen.',
    ],
    reflectionPrompt: 'What would beginning again look like today?',
  ),
];

Prayer? prayerById(String id) {
  for (final p in prayerLibrary) {
    if (p.id == id) return p;
  }
  return null;
}
