import 'package:flutter/material.dart';

import '../../model/wall_rio_model.dart';
import '../theme/theme_data.dart';
import '../widgets/back_btn_widget.dart';
import '../widgets/image_widget.dart';

class FullImage extends StatelessWidget {
  final Walls wallModel;
  const FullImage({super.key, required this.wallModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: wallModel.url,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            InteractiveViewer(
              maxScale: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CNImage(
                    imageUrl: wallModel.url,
                    isOriginalImg: true,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: blackColor.withOpacity(0.1),
                  maxRadius: 30,
                  child: const BackBtnWidget(color: whiteColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
