import 'package:flutter/material.dart';

/// One piece of the armour of God (Ephesians 6:10–18).
class ArmourPiece {
  const ArmourPiece({
    required this.title,
    required this.icon,
    required this.explanation,
    required this.verseText,
    required this.verseReference,
    required this.reflection,
  });

  final String title;
  final IconData icon;
  final String explanation;
  final String verseText;
  final String verseReference;
  final String reflection;
}

const armourPieces = [
  ArmourPiece(
    title: 'Belt of Truth',
    icon: Icons.workspace_premium_outlined,
    explanation:
        'Truth holds everything else in place. When you live honestly before '
        'God and others, the enemy\'s lies lose their grip.',
    verseText:
        'Stand firm then, with the belt of truth buckled around your waist.',
    verseReference: 'Ephesians 6:14',
    reflection:
        'Is there a lie — about God, yourself, or your struggle — that you '
        'need to replace with truth today?',
  ),
  ArmourPiece(
    title: 'Breastplate of Righteousness',
    icon: Icons.favorite_outline,
    explanation:
        'Righteousness guards the heart. It is not perfection, but a life '
        'turned toward God, covered by the righteousness of Christ.',
    verseText: 'With the breastplate of righteousness arrayed.',
    verseReference: 'Ephesians 6:14',
    reflection:
        'What area of your heart needs to be brought back under God\'s '
        'covering today?',
  ),
  ArmourPiece(
    title: 'Shoes of Peace',
    icon: Icons.directions_walk_outlined,
    explanation:
        'Peace with God steadies every step. Ready feet carry His peace into '
        'anxious rooms and hard conversations.',
    verseText:
        'With your feet fitted with the readiness of the gospel of peace.',
    verseReference: 'Ephesians 6:15',
    reflection:
        'Where are you being sent today, and who needs the peace you carry?',
  ),
  ArmourPiece(
    title: 'Shield of Faith',
    icon: Icons.shield_outlined,
    explanation:
        'Use faith to stand against fear, doubt, and temptation. Faith does '
        'not remove the arrows — it stops them.',
    verseText:
        'Take up the shield of faith, with which you can extinguish all the flaming arrows of the evil one.',
    verseReference: 'Ephesians 6:16',
    reflection:
        'What fear or temptation do you need to place behind the shield of '
        'faith today?',
  ),
  ArmourPiece(
    title: 'Helmet of Salvation',
    icon: Icons.psychology_outlined,
    explanation:
        'Salvation protects the mind. When you remember whose you are, '
        'shame and condemnation lose their voice.',
    verseText: 'Take the helmet of salvation.',
    verseReference: 'Ephesians 6:17',
    reflection:
        'What thought pattern needs to be renewed by the certainty of your '
        'salvation?',
  ),
  ArmourPiece(
    title: 'Sword of the Spirit',
    icon: Icons.auto_stories_outlined,
    explanation:
        'The Word of God is the one weapon in the armour. Scripture spoken '
        'in the moment of battle cuts through every deception.',
    verseText:
        'The sword of the Spirit, which is the word of God.',
    verseReference: 'Ephesians 6:17',
    reflection:
        'Which verse could you keep ready this week for the moment you need '
        'it most?',
  ),
];
