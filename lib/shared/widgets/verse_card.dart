import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../models/verse.dart';

/// Large featured verse card with a deep-green gradient, subtle light rays,
/// and save / reflect actions.
class VerseCard extends StatelessWidget {
  const VerseCard({
    super.key,
    required this.verse,
    required this.isSaved,
    required this.onSave,
    required this.onReflect,
  });

  final Verse verse;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onReflect;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Daily verse: ${verse.text} — ${verse.reference}',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.forestGreen, AppColors.deepOlive],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.forestGreen.withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Icon(
                  Icons.shield_outlined,
                  size: 170,
                  color: AppColors.softGold.withValues(alpha: 0.08),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -40,
                child: Icon(
                  Icons.wb_sunny_outlined,
                  size: 140,
                  color: AppColors.softGold.withValues(alpha: 0.06),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 16, color: AppColors.softGold.withValues(alpha: 0.9)),
                        const SizedBox(width: 8),
                        Text(
                          'VERSE FOR TODAY',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                            color: AppColors.softGold.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '“${verse.text}”',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 21,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                        color: AppColors.warmWhite,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '— ${verse.reference}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.softGold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _VerseAction(
                          icon: isSaved ? Icons.bookmark : Icons.bookmark_outline,
                          label: isSaved ? 'Saved' : 'Save',
                          onTap: onSave,
                        ),
                        const Spacer(),
                        Material(
                          color: AppColors.warmGold,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: onReflect,
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 44),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Reflect',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.deepCharcoal,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.arrow_forward_rounded,
                                      size: 16, color: AppColors.deepCharcoal),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerseAction extends StatelessWidget {
  const _VerseAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.warmWhite.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 17, color: AppColors.warmWhite),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.warmWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
