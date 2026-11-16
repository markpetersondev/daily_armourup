import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../contact_support.dart';
import '../data/faq_content.dart';

/// Help & FAQ: answers that work offline, and a way to contact support.
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'Answers to common questions. Everything here works '
                  'without internet.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                PremiumCard(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      for (final (i, item) in faqItems.indexed) ...[
                        if (i > 0) const Divider(height: 1),
                        _FaqTile(item: item),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Still need help?',
                  subtitle: 'We read every message.',
                ),
                PrimaryButton(
                  label: 'Contact us',
                  icon: Icons.mail_outline,
                  onPressed: () => contactSupport(context, ref),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: 'Open support page',
                  icon: Icons.open_in_new,
                  onPressed: () => launchUrl(
                    Uri.parse(AppStrings.supportUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.supportEmail,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.item});

  final FaqItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: const EdgeInsets.symmetric(horizontal: 18),
      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      expandedAlignment: Alignment.centerLeft,
      title: Text(item.question, style: theme.textTheme.titleSmall),
      children: [
        Text(
          item.answer,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
