import 'package:flutter/material.dart';

class BackBtnWidget extends StatelessWidget {
  final Color color;
  const BackBtnWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.navigate_before_rounded,
            size: 40,
            color: color,
            shadows: const [Shadow(blurRadius: 20, color: Colors.black26)],
          )),
    );
  }
}
