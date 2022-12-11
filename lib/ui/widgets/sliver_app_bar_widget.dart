import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/widgets/search_bar_widget.dart';

class SliverAppBarWidget extends StatelessWidget {
  const SliverAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: false,
      pinned: false,
      floating: true,
      toolbarHeight: MediaQuery.of(context).size.height * 0.14,
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
                      'Wallpapers',
                      style: Theme.of(context).textTheme.headline1,
                      colors: const [Color(0xFFFF4949), Color(0xFF5344FF)],
                    ),
                    const SizedBox(height: 4),
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
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(40), child: SearchBarWidget()),
    );
  }
}
