import 'package:url_launcher/url_launcher.dart';

import 'toast_widget.dart';

class LaunchUrlWidget {
  static Future<void> launch(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      ToastWidget.showToast("Couldn't able to launch");
    }
  }
}
