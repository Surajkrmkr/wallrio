import 'package:flutter/material.dart';
import 'package:wallrio/model/wall_rio_model.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/widgets/image_widget.dart';
import 'package:wallrio/ui/widgets/primary_btn_widget.dart';

class ImageBottomSheet extends StatelessWidget {
  final Walls wallModel;
  const ImageBottomSheet({super.key, required this.wallModel});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Padding(
          padding: const EdgeInsets.all(25.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              children: [
                Text(
                  wallModel.name!,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(width: 10),
                Text(
                  "Designed By ${wallModel.author!}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CNImage(imageUrl: wallModel.thumbnail))),
            const SizedBox(height: 20),
            PrimaryBtnWidget(btnText: "Apply", onTap: () {})
          ]))
    ]);
  }
}
