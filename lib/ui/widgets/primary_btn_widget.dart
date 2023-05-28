import 'package:flutter/material.dart';

import '../theme/theme_data.dart';

class PrimaryBtnWidget extends StatelessWidget {
  final String btnText;
  final Function() onTap;
  final Widget? icon;
  const PrimaryBtnWidget({
    Key? key,
    required this.btnText,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? ElevatedButton.icon(
            icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                height: 20,
                child: icon!),
            onPressed: onTap,
            label: Text(btnText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: whiteColor, fontWeight: FontWeight.bold)))
        : ElevatedButton(
            onPressed: onTap,
            child: Center(
                child: Text(btnText.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: whiteColor, fontWeight: FontWeight.bold))));
  }
}
