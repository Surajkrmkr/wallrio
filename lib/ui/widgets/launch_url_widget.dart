import 'package:url_launcher/url_launcher.dart';

import 'toast_widget.dart';

class LaunchUrlWidget {
  static Future<void> launch(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      ToastWidget.showToast("Couldn't able to launch");
    }
  }

  static Future<void> launchEmail(String email) async {
    if (!await launchUrl(
        Uri(
          scheme: 'mailto',
          path: email,
        ),
        mode: LaunchMode.externalApplication)) {
      ToastWidget.showToast("Couldn't able to launch");
    }
  }
}
