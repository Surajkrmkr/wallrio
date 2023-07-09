import 'package:flutter/material.dart';
import 'package:wallrio/model/export.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/services/export.dart';
import 'package:wallrio/ui/views/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class ImageBottomSheet extends StatelessWidget {
  final Walls wallModel;
  const ImageBottomSheet({super.key, required this.wallModel});

  void _onTapHandler(context, model) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageViewPage(wallModel: model)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Wrap(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  wallModel.name,
                  style: Theme.of(context).textTheme.displayMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "Designed By ${wallModel.author}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Hero(
            tag: wallModel.url,
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
          const AdsWidget(bottomPadding: 20),
          PrimaryBtnWidget(
              btnText: "Apply",
              onTap: () =>
                  Provider.of<WallActionProvider>(context, listen: false)
                      .setWall(wallModel.url, context)),
        ])
      ]),
    );
  }
}
