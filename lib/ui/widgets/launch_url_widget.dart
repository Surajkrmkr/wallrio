import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

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
