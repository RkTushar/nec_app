import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// A reusable share helper that exposes common share actions.
///
/// Use the static methods for quick actions, or include the
/// [ShareIconButton] for a standard small share icon.
class ShareLinkWidget {
  /// Opens the native share sheet with the provided [text] and optional [subject].
  static Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (e) {
      // Fallback: copy to clipboard if sharing fails
      try {
        await Clipboard.setData(ClipboardData(text: text));
      } catch (_) {}
    }
  }

  /// Attempts to open a platform-specific deep link for a given [baseUrl]
  /// with the [text] as a query parameter. If unavailable, falls back to copying.
  static Future<void> shareViaUrl(String baseUrl, String text, BuildContext context) async {
    final Uri uri = Uri.parse('$baseUrl${Uri.encodeComponent(text)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    } catch (_) {}

    // Fallback: copy to clipboard with snackbar feedback
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Referral text copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }
}

/// A small, rounded share icon button that triggers native share for [text].
class ShareIconButton extends StatelessWidget {
  final String text;
  final String? subject;

  const ShareIconButton({super.key, required this.text, this.subject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ShareLinkWidget.shareText(text, subject: subject),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.share,
          size: 20,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}


