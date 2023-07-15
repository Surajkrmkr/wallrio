import 'package:flutter/material.dart';
import 'package:wallrio/services/export.dart';

class VerifyIconWidget extends StatelessWidget {
  final double padding;
  final Alignment alignment;
  final bool visibility;
  const VerifyIconWidget(
      {super.key,
      this.padding = 10,
      this.alignment = Alignment.topRight,
      this.visibility = false});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: visibility,
      child: IgnorePointer(
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: const Icon(
              Icons.verified_rounded,
              color: whiteColor,
              shadows: [BoxShadow(blurRadius: 20, color: Colors.black45)],
            ),
          ),
        ),
      ),
    );
  }
}
