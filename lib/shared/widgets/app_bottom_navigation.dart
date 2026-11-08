import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// One destination in the bottom navigation.
class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Custom bottom navigation with an elevated central Rescue shield —
/// visually the strongest action in the bar.
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  /// Order matches the shell branches: Home, Scripture, Rescue, Journal, Profile.
  static const destinations = [
    AppNavDestination(
        icon: Icons.cottage_outlined, selectedIcon: Icons.cottage, label: 'Home'),
    AppNavDestination(
        icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, label: 'Scripture'),
    AppNavDestination(
        icon: Icons.shield_outlined, selectedIcon: Icons.shield, label: 'Rescue'),
    AppNavDestination(
        icon: Icons.edit_note_outlined, selectedIcon: Icons.edit_note, label: 'Journal'),
    AppNavDestination(
        icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Profile'),
  ];

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        // The bar has a fixed height, so labels can only grow so far.
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                _navItem(context, 0),
                _navItem(context, 1),
                _rescueItem(context),
                _navItem(context, 3),
                _navItem(context, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index) {
    final scheme = Theme.of(context).colorScheme;
    final dest = destinations[index];
    final selected = index == currentIndex;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: dest.label,
        child: InkWell(
          onTap: () => onDestinationSelected(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? dest.selectedIcon : dest.icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                dest.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rescueItem(BuildContext context) {
    final selected = currentIndex == 2;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: 'Rescue — immediate spiritual support',
        child: InkWell(
          onTap: () => onDestinationSelected(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.warmGold, Color(0xFFC29142)],
                  ),
                  border: Border.all(
                    color: selected
                        ? AppColors.forestGreen
                        : AppColors.softGold.withValues(alpha: 0.6),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warmGold.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.shield,
                    color: AppColors.deepCharcoal, size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
