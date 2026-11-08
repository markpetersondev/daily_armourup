import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/armour_content.dart';

/// “My Armour” — the armour of God from Ephesians 6, piece by piece.
class ArmourScreen extends StatelessWidget {
  const ArmourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Armour')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                PremiumCard(
                  padding: const EdgeInsets.all(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.warmGold.withValues(alpha: 0.16),
                      theme.colorScheme.surfaceContainer,
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Put on the full armour of God',
                          style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 6),
                      Text(
                        '“…so that you can make your stand against the '
                        'devil’s schemes.” — Ephesians 6:11',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                for (final (index, piece) in armourPieces.indexed) ...[
                  _ArmourTile(
                      piece: piece, isLast: index == armourPieces.length - 1),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArmourTile extends StatelessWidget {
  const _ArmourTile({required this.piece, required this.isLast});

  final ArmourPiece piece;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warmGold.withValues(alpha: 0.16),
                    border: Border.all(
                        color: AppColors.warmGold.withValues(alpha: 0.5)),
                  ),
                  child:
                      Icon(piece.icon, size: 18, color: AppColors.warmGold),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.warmGold.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: PremiumCard(
                padding: const EdgeInsets.all(18),
                onTap: () => _openDetail(context),
                semanticLabel: '${piece.title}. Tap for reflection.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(piece.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(
                      piece.explanation,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      piece.verseReference,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.warmGold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.warmGold.withValues(alpha: 0.16),
                    ),
                    child: Icon(piece.icon, color: AppColors.warmGold),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(piece.title,
                        style: theme.textTheme.headlineSmall),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(piece.explanation,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55)),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '“${piece.verseText}”',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic, height: 1.55),
                    ),
                    const SizedBox(height: 8),
                    Text(piece.verseReference,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.warmGold)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text('Reflection', style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(piece.reflection,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.55)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.push(AppRoutes.prayers);
                  },
                  icon: const Icon(Icons.wb_twilight_outlined, size: 18),
                  label: const Text('Pray about this'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
