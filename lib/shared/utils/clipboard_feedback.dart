import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _deviceChannel = MethodChannel('armourup/device');
bool? _systemConfirmsCopy;

/// Android 13 (API 33) and later show their own confirmation whenever an app
/// copies to the clipboard, so a SnackBar on top of it would say it twice.
Future<bool> _systemShowsCopyConfirmation() async {
  if (_systemConfirmsCopy != null) return _systemConfirmsCopy!;
  var result = false;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    try {
      final sdk = await _deviceChannel.invokeMethod<int>('sdkInt');
      result = (sdk ?? 0) >= 33;
    } on PlatformException {
      result = false;
    } on MissingPluginException {
      result = false;
    }
  }
  return _systemConfirmsCopy = result;
}

/// Copies [text] and confirms with [message], unless the OS already confirms.
Future<void> copyWithConfirmation(
  BuildContext context, {
  required String text,
  required String message,
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (await _systemShowsCopyConfirmation()) return;
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
