import 'package:flutter/material.dart';

import '../theme/theme_data.dart';

class PrimaryBtnWidget extends StatelessWidget {
  final String btnText;
  final Function() onTap;
  const PrimaryBtnWidget({
    Key? key,
    required this.btnText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            backgroundColor: blackColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: onTap,
        child: Center(
            child: Text(btnText,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: whiteColor))));
  }
}
