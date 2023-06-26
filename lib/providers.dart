import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'provider/auth.dart';
import 'provider/dark_theme.dart';
import 'provider/favourite.dart';
import 'provider/navigation.dart';
import 'provider/subscription.dart';
import 'provider/wall_action.dart';
import 'provider/wall_details.dart';
import 'provider/wall_rio.dart';

List<SingleChildWidget> providers(context) => [
      ChangeNotifierProvider(
        create: ((context) => AuthProvider()),
      ),
      ChangeNotifierProvider(
        create: ((context) => SubscriptionProvider()),
      ),
      ChangeNotifierProvider(
        create: ((context) => DarkThemeProvider()),
      ),
      ChangeNotifierProvider(
        create: ((context) => WallRio()),
      ),
      ChangeNotifierProvider(
        create: ((context) => Navigation()),
      ),
      ChangeNotifierProvider(
        create: ((context) => WallDetails()),
      ),
      ChangeNotifierProvider(
        create: ((context) => WallActionProvider()),
      ),
      ChangeNotifierProvider(
        create: ((context) => FavouriteProvider()),
      )
    ];
