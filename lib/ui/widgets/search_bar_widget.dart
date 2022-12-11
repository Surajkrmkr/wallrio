import 'package:flutter/material.dart';
import 'package:wallrio/ui/theme/theme_data.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: blackColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Search...",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Icon(
          Icons.search,
          color: blackColor.withOpacity(0.2),
        )
      ]),
    );
  }
}
