import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/wall_rio.dart';
import '../views/settings_page.dart';
import 'primary_btn_widget.dart';
import 'shimmer_widget.dart';

class ChangeLog extends StatelessWidget {
  const ChangeLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WallRio>(builder: (context, provider, _) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(provider.isUpdateAvailable ? "Update Available" : "Changelog"),
            const CloseButton()
          ],
        ),
        contentPadding: const EdgeInsets.all(20),
        actions: [
          Offstage(
            offstage: !provider.isUpdateAvailable,
            child: PrimaryBtnWidget(
                btnText: "UPDATE",
                onTap: () => SettingsPage.launch(
                    "https://play.google.com/store/apps/details?id=com.shadowteam.wallrio")),
          ),
        ],
        content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: provider.isLoading
                ? ListView(
                    shrinkWrap: true,
                    children: List.generate(
                        5,
                        (index) => const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: ShimmerWidget(
                                  height: 30, width: 60, radius: 10),
                            )))
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: provider.details.releaseNotes
                        .map((note) => Text(
                              "${(provider.details.releaseNotes.indexOf(note) + 1).toString()}. $note",
                              style: Theme.of(context).textTheme.titleMedium,
                            ))
                        .toList())),
      );
    });
  }
}
