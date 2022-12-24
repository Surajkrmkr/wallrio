import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/wall_rio.dart';

class BackBtnWidget extends StatelessWidget {
  final Color color;
  final bool isActionReset;
  const BackBtnWidget({
    Key? key,
    required this.color,
    this.isActionReset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
            if (isActionReset) {
              Provider.of<WallRio>(context, listen: false).resetToDefault();
            }
          },
          icon: Icon(
            Icons.navigate_before_rounded,
            size: 40,
            color: color,
            shadows: const [Shadow(blurRadius: 20, color: Colors.black26)],
          )),
    );
  }
}
