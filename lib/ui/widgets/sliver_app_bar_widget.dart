import 'package:flutter/material.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/services/export.dart';
import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/views/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class SliverAppBarWidget extends StatelessWidget {
  final bool showLogo;
  final bool showSearchBtn;
  final String text;
  final bool showBackBtn;
  final bool clearSearchedData;
  final bool centeredTitle;
  final bool showUserProfileIcon;
  final bool userProfileIconRight;
  const SliverAppBarWidget(
      {super.key,
      required this.showLogo,
      required this.text,
      required this.showSearchBtn,
      this.showBackBtn = false,
      this.clearSearchedData = false,
      this.centeredTitle = true,
      this.showUserProfileIcon = false,
      this.userProfileIconRight = true});

  void _onLongPressHandler(context) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) => const UserBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: false,
      pinned: false,
      floating: true,
      automaticallyImplyLeading: showBackBtn,
      leadingWidth: showBackBtn || !userProfileIconRight ? 60 : 0,
      leading: Row(
        children: [
          _buildUserProfileIcon(context, userProfileIconRight),
          Offstage(
              offstage: !showBackBtn,
              child: BackBtnWidget(
                  color: Theme.of(context).primaryColorLight,
                  isActionReset: clearSearchedData))
        ],
      ),
      toolbarHeight: MediaQuery.of(context).size.height * 0.10,
      centerTitle: centeredTitle,
      title: Column(
        children: [
          Consumer<DarkThemeProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: EdgeInsets.only(left: centeredTitle ? 0.0 : 10),
                child: GradientText(
                  text,
                  style: Theme.of(context).textTheme.displayLarge,
                  colors: gradientColorMap[provider.gradType]!,
                ),
              );
            },
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
        _buildUserProfileIcon(context, !userProfileIconRight),
        _buildSearchIcon(context),
        const SizedBox(width: 20),
      ],
    );
  }

  Offstage _buildSearchIcon(BuildContext context) {
    return Offstage(
      offstage: !showSearchBtn,
      child: IconButton(
          iconSize: 30,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage())),
          icon: const Icon(Icons.search_rounded)),
    );
  }

  Offstage _buildUserProfileIcon(BuildContext context, bool showRight) {
    return Offstage(
      offstage: showRight,
      child: Offstage(
          offstage: !showUserProfileIcon,
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                  iconSize: 30,
                  icon: Consumer<AuthProvider>(
                    builder: (context, provider, _) {
                      return provider.user.photoURL!.isEmpty
                          ? const Icon(Icons.account_circle_rounded)
                          : CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage:
                                  NetworkImage(provider.user.photoURL!),
                            );
                    },
                  ),
                  onPressed: () => _onLongPressHandler(context)))),
    );
  }
}
