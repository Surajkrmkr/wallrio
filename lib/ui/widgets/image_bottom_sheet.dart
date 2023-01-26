import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/model/wall_rio_model.dart';
import 'package:wallrio/provider/favourite.dart';
import 'package:wallrio/ui/widgets/image_widget.dart';
import 'package:wallrio/ui/widgets/primary_btn_widget.dart';

import '../../provider/wall_action.dart';
import '../theme/theme_data.dart';
import '../views/image_view_page.dart';

class ImageBottomSheet extends StatelessWidget {
  final Walls wallModel;
  const ImageBottomSheet({super.key, required this.wallModel});

  void _onTapHandler(context, model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageViewPage(wallModel: model)));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Padding(
          padding: const EdgeInsets.all(25.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    wallModel.name!,
                    style: Theme.of(context).textTheme.displayMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Designed By ${wallModel.author!}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Hero(
              tag: wallModel.url!,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CNImage(imageUrl: wallModel.thumbnail),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onTapHandler(context, wallModel),
                              splashColor: blackColor.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ))),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryBtnWidget(
                      btnText: "Apply",
                      onTap: () => Provider.of<WallActionProvider>(context,
                              listen: false)
                          .setWall(wallModel.url, context)),
                ),
                const SizedBox(width: 20),
                Consumer<FavouriteProvider>(builder: (context, provider, _) {
                  final bool isFav = provider.isSelectedAsFav(wallModel.url!);
                  return FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: null,
                    child: AnimatedIconButton(
                      size: 24,
                      initialIcon: isFav ? 1 : 0,
                      onPressed: () => isFav
                          ? provider.removeFromFav(wallModel.url!)
                          : provider.addToFav(wallModel),
                      icons: const [
                        AnimatedIconItem(
                          icon: Icon(Icons.favorite_border_rounded),
                        ),
                        AnimatedIconItem(
                          icon: Icon(Icons.favorite_rounded),
                        ),
                      ],
                    ),
                  );
                })
              ],
            )
          ]))
    ]);
  }
}
