import 'package:flutter/material.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/views/image_view_page.dart';
import 'package:wallrio/ui/widgets/image_bottom_sheet.dart';

import '../../model/wall_rio_model.dart';
import '../widgets/image_widget.dart';
import '../widgets/refresh_indicator_widget.dart';
import '../widgets/sliver_app_bar_widget.dart';

class GridPage extends StatelessWidget {
  final String categoryName;
  final List<Walls?> walls;
  const GridPage({super.key, required this.categoryName, required this.walls});

  void _onLongPressHandler(context, model) {
    showModalBottomSheet(
        context: context,
        backgroundColor: whiteColor,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        barrierColor: Colors.black12,
        builder: (context) => ImageBottomSheet(wallModel: model));
  }

  void _onTapHandler(context, model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageViewPage(wallModel: model)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicatorWidget(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBarWidget(
                  showLogo: false,
                  showSearchBar: false,
                  text: categoryName,
                  showBackBtn: true),
              _buildListUI(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListUI(context) {
    return SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.7),
            delegate: SliverChildBuilderDelegate(
                childCount: walls.length,
                (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(fit: StackFit.expand, children: [
                      CNImage(imageUrl: walls[index]!.thumbnail),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () => _onTapHandler(context, walls[index]),
                              onLongPress: () =>
                                  _onLongPressHandler(context, walls[index]),
                              splashColor: blackColor.withOpacity(0.3)))
                    ])))));
  }
}
