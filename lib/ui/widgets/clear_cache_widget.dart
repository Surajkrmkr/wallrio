import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'toast_widget.dart';

class ClearCacheWidget extends StatelessWidget {
  const ClearCacheWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Clear Cache"),
      content: Text(
        "Clearing cache will free up some memory",
        style: Theme.of(context).textTheme.labelLarge,
      ),
      actions: [
        FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        OutlinedButton(
            onPressed: () {
              DefaultCacheManager().emptyCache();
              Navigator.pop(context);
              ToastWidget.showToast("Cache Cleared");
            },
            child: const Text("Clear"))
      ],
    );
  }
}
