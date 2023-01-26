import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../theme/theme_data.dart';
import '../views/search_page.dart';
import 'back_btn_widget.dart';
import 'user_bottom_sheet.dart';

class SliverAppBarWidget extends StatelessWidget {
  final bool showLogo;
  final bool showSearchBtn;
  final String text;
  final bool showBackBtn;
  final bool centeredTitle;
  final bool showUserProfileIcon;
  const SliverAppBarWidget(
      {super.key,
      required this.showLogo,
      required this.text,
      required this.showSearchBtn,
      this.showBackBtn = false,
      this.centeredTitle = true,
      this.showUserProfileIcon = false});

  void _onLongPressHandler(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: whiteColor,
        enableDrag: true,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        barrierColor: Colors.black12,
        builder: (context) => const UserBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: false,
      pinned: false,
      floating: true,
      automaticallyImplyLeading: showBackBtn,
      leadingWidth: showBackBtn || showUserProfileIcon ? 60 : 0,
      leading: Row(
        children: [
          Offstage(
              offstage: !showUserProfileIcon,
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.account_circle_rounded,
                      ),
                      onPressed: () => _onLongPressHandler(context)))),
          Offstage(
              offstage: !showBackBtn,
              child: const BackBtnWidget(color: Colors.black))
        ],
      ),
      toolbarHeight: MediaQuery.of(context).size.height * 0.10,
      centerTitle: centeredTitle,
      title: Column(
        children: [
          GradientText(
            text,
            style: Theme.of(context).textTheme.displayLarge,
            colors: const [Color(0xFFFF4949), Color(0xFF5344FF)],
          ),
          Offstage(
            offstage: !showLogo,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
              child: Text(
                "Team Shadow",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          )
        ],
      ),
      actions: [
        Offstage(
          offstage: !showSearchBtn,
          child: IconButton(
              iconSize: 30,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage())),
              icon: const Icon(Icons.search_rounded)),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
