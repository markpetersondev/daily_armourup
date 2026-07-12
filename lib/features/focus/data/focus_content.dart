import 'package:flutter/material.dart';

import '../../../shared/models/focus_session.dart';
import '../../../shared/models/verse.dart';

/// Presentation details for each Sacred Focus mode.
class FocusModeContent {
  const FocusModeContent({
    required this.icon,
    required this.description,
    required this.sessionPrompt,
    required this.verse,
  });

  final IconData icon;
  final String description;

  /// Short line shown during the active session.
  final String sessionPrompt;
  final Verse verse;
}

const Map<FocusMode, FocusModeContent> focusModeContent = {
  FocusMode.prayer: FocusModeContent(
    icon: Icons.wb_twilight_outlined,
    description: 'Unhurried time to talk with God.',
    sessionPrompt: 'Keep your heart steady. He is listening.',
    verse: Verse(
      text: 'Devote yourselves to prayer, being watchful and thankful.',
      reference: 'Colossians 4:2',
    ),
  ),
  FocusMode.bibleReading: FocusModeContent(
    icon: Icons.menu_book_outlined,
    description: 'Open the Word without distraction.',
    sessionPrompt: 'Read slowly. Let the words settle.',
    verse: Verse(
      text: 'Your word is a lamp for my feet, a light on my path.',
      reference: 'Psalm 119:105',
    ),
  ),
  FocusMode.worship: FocusModeContent(
    icon: Icons.music_note_outlined,
    description: 'Turn your attention to who God is.',
    sessionPrompt: 'Lift your eyes. He is worthy.',
    verse: Verse(
      text: 'Come, let us bow down in worship, let us kneel before the Lord our Maker.',
      reference: 'Psalm 95:6',
    ),
  ),
  FocusMode.quietReflection: FocusModeContent(
    icon: Icons.self_improvement_outlined,
    description: 'Sit in stillness before God.',
    sessionPrompt: 'Be still. You are held.',
    verse: Verse(
      text: 'Be still, and know that I am God.',
      reference: 'Psalm 46:10',
    ),
  ),
  FocusMode.resistDistraction: FocusModeContent(
    icon: Icons.shield_outlined,
    description: 'Commit these minutes to staying present.',
    sessionPrompt: 'Stand firm. This time is set apart.',
    verse: Verse(
      text: 'Set your minds on things above, not on earthly things.',
      reference: 'Colossians 3:2',
    ),
  ),
};

const focusDurationPresets = [
  Duration(minutes: 5),
  Duration(minutes: 10),
  Duration(minutes: 15),
  Duration(minutes: 30),
];
