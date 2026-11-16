import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The installed app's version, read from the build so it never goes stale.
class AppInfo {
  const AppInfo({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  /// e.g. "1.0.0 (2)".
  String get label => buildNumber.isEmpty ? version : '$version ($buildNumber)';
}

final appInfoProvider = FutureProvider<AppInfo?>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(version: info.version, buildNumber: info.buildNumber);
  } catch (_) {
    // Only expected in tests without platform channels; screens show no version.
    return null;
  }
});
