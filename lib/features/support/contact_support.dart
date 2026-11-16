import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_strings.dart';
import '../../shared/providers/app_info_provider.dart';
import '../../shared/utils/clipboard_feedback.dart';

/// Opens an email to support with the app version filled in. If no email app
/// is available, shows the address with a Copy action instead.
Future<void> contactSupport(BuildContext context, WidgetRef ref) async {
  final version = ref.read(appInfoProvider).valueOrNull?.label ?? 'unknown';
  final platform = switch (defaultTargetPlatform) {
    TargetPlatform.iOS => 'iPhone',
    TargetPlatform.android => 'Android',
    _ => defaultTargetPlatform.name,
  };
  final subject = '${AppStrings.appName} support';
  final body = 'Please tell us what happened or what you would like:\n\n\n'
      '---\n'
      'App: ${AppStrings.appName} $version\n'
      'Platform: $platform\n'
      'Phone model: ';
  // Encode by hand: Uri.queryParameters turns spaces into "+", which some
  // email apps show literally.
  final uri = Uri.parse('mailto:${AppStrings.supportEmail}'
      '?subject=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(body)}');

  var opened = false;
  try {
    opened = await launchUrl(uri);
  } catch (_) {
    opened = false;
  }
  if (opened || !context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text('No email app found. Email us at '
        '${AppStrings.supportEmail}'),
    duration: const Duration(seconds: 8),
    action: SnackBarAction(
      label: 'Copy',
      onPressed: () => copyWithConfirmation(
        context,
        text: AppStrings.supportEmail,
        message: 'Email address copied.',
      ),
    ),
  ));
}
