import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/widgets/search_bar_widget.dart';

class SliverAppBarWidget extends StatelessWidget {
  final bool showLogo;
  final bool showSearchBar;
  final String text;
  const SliverAppBarWidget(
      {super.key,
      required this.showLogo,
      required this.text,
      required this.showSearchBar});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: false,
      pinned: false,
      floating: true,
      toolbarHeight:
          MediaQuery.of(context).size.height * (showLogo ? 0.14 : 0.10),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      text,
                      style: Theme.of(context).textTheme.headline1,
                      colors: const [Color(0xFFFF4949), Color(0xFF5344FF)],
                    ),
                    const SizedBox(height: 4),
                    if (showLogo)
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          Text("by",
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(width: 4),
                          SvgPicture.asset("assets/team_logo.svg",
                              color: blackColor, height: 10)
                        ],
                      )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: showSearchBar
          ? const PreferredSize(
              preferredSize: Size.fromHeight(40), child: SearchBarWidget())
          : const PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: SizedBox(),
            ),
    );
  }
}
