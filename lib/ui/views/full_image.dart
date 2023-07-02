import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../../model/wall_rio_model.dart';
import '../theme/theme_data.dart';
import '../widgets/back_btn_widget.dart';
import '../widgets/image_widget.dart';

class FullImage extends StatefulWidget {
  final Walls wallModel;
  const FullImage({super.key, required this.wallModel});

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  Future<void> _secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    _secureScreen();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.wallModel.url,
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
                    imageUrl: widget.wallModel.url,
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
            ),
          ],
        ),
      ),
    );
  }
}
