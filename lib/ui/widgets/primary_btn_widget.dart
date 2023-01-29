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
        onPressed: onTap,
        child: Center(
            child: Text(btnText,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: whiteColor, fontWeight: FontWeight.bold))));
  }
}
