import 'package:provider/single_child_widget.dart';
import 'package:wallrio/provider/export.dart';

List<SingleChildWidget> providers(context) => [
      AuthProvider(),
      SubscriptionProvider(),
      AdsProvider(),
      DarkThemeProvider(),
      WallRio(),
      Navigation(),
      WallDetails(),
      WallActionProvider(),
      FavouriteProvider()
    ]
        .map((provider) =>
            ChangeNotifierProvider(create: ((context) => provider)))
        .toList();
