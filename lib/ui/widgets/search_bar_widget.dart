import 'package:flutter/material.dart';
import 'package:wallrio/ui/theme/theme_data.dart';

import '../views/search_page.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: blackColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchPage())),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Search...",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Icon(
              Icons.search,
              color: blackColor.withOpacity(0.2),
            )
          ]),
        ),
      ),
    );
  }
}
