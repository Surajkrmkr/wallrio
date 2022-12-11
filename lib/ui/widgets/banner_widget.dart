import 'package:flutter/material.dart';
import 'package:wallrio/ui/theme/theme_data.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: blackColor.withOpacity(0.05),
          image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://gitlab.com/piyushkpv/wallrio_wall_data/-/raw/main/Floral/Floral_15.png")),
          borderRadius: BorderRadius.circular(16)),
    );
  }
}
