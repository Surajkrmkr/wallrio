import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallrio/model/export.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/ui/views/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

/// Minimal glue between the native Android home-screen widgets and the
/// existing in-app detail pages. There is no generic deep-link framework in
/// this app, so this intentionally stays small and contained: it reads a
/// one-shot "pending launch" map from the native
/// `com.shadowteam.wallrio/home_widget` MethodChannel (set by MainActivity
/// when the app is opened from a widget tap) and either switches tabs or
/// pushes the right detail page with the looked-up model.
///
/// Gating for premium content is intentionally NOT duplicated here: the
/// existing detail pages already gate the apply/download action at tap-time,
/// so navigating straight to a premium item's detail page is safe.
class HomeWidgetLaunchService {
  static const MethodChannel _channel =
      MethodChannel('com.shadowteam.wallrio/home_widget');

  /// Asks the current launcher to place the given widget type
  /// ('static' / 'video' / 'desktop') directly on the home screen
  /// (`AppWidgetManager.requestPinAppWidget`, Android 8.0+ only). Returns
  /// false — never throws — if unsupported (old Android, or a launcher that
  /// doesn't implement pin requests), so callers should fall back to telling
  /// the user to long-press their home screen instead.
  static Future<bool> requestPinWidget(String type) async {
    if (!Platform.isAndroid) return false;
    try {
      final result =
          await _channel.invokeMethod<bool>('requestPinWidget', {'type': type});
      return result ?? false;
    } catch (e) {
      debugPrint('HomeWidgetLaunchService: requestPinWidget failed: $e');
      return false;
    }
  }

  /// Reads the currently-cached selection for a widget type
  /// ('static' / 'video' / 'desktop') — the same items the native widget on
  /// the home screen is showing right now — so the "Home Screen Widgets"
  /// preview sheet can render real thumbnails instead of placeholder icons.
  /// The thumbnail files live under this app's own private storage
  /// (native widget_cache/), so they're readable directly via `Image.file`
  /// once we have the path; no native image transport needed. Returns an
  /// empty list (never throws) if nothing has been cached yet.
  static Future<List<Map<String, dynamic>>> getCachedWidgetItems(
      String type) async {
    if (!Platform.isAndroid) return [];
    try {
      final result = await _channel
          .invokeMethod<List<dynamic>>('getCachedWidgetItems', {'type': type});
      if (result == null) return [];
      return result
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      debugPrint('HomeWidgetLaunchService: getCachedWidgetItems failed: $e');
      return [];
    }
  }

  /// Call once, after the root MaterialApp/navigator is up (e.g. from
  /// SplashPage/NavigationPage), never during main()/before the widget tree
  /// exists.
  static Future<void> handleLaunch() async {
    if (!Platform.isAndroid) return;
    try {
      final dynamic raw = await _channel.invokeMethod('getLaunchWidgetAction');
      if (raw == null) return;
      final map = Map<Object?, Object?>.from(raw as Map);
      final String? type = map['type'] as String?;
      final String? action = map['action'] as String?;
      final int? itemId = map['itemId'] as int?;
      if (type == null || action == null) return;

      final context = ToastWidget.navigatorKey.currentContext;
      if (context == null) return;

      if (action == 'open_section') {
        _openSection(context, type);
        return;
      }

      if (action == 'open_item' && itemId != null) {
        await _openItem(context, type, itemId);
      }
    } catch (e) {
      debugPrint('HomeWidgetLaunchService: failed to handle widget launch: $e');
    }
  }

  static void _openSection(BuildContext context, String type) {
    final navigation = Provider.of<Navigation>(context, listen: false);
    // pages.dart tab order: 0 = HomePage (static), 1 = LivePage (video),
    // 2 = CollectionPage, 3 = CategoryPage, 4 = FavouritePage. There is no
    // dedicated "desktop" tab today, so desktop widget taps land on Home.
    switch (type) {
      case 'video':
        navigation.setIndex = 1;
        break;
      default:
        navigation.setIndex = 0;
    }
  }

  static Future<void> _openItem(
      BuildContext context, String type, int itemId) async {
    switch (type) {
      case 'video':
        await _openLiveItem(context, itemId);
        break;
      case 'desktop':
        await _openDesktopItem(context, itemId);
        break;
      case 'static':
      default:
        await _openStaticItem(context, itemId);
        break;
    }
  }

  static Future<void> _openStaticItem(BuildContext context, int itemId) async {
    final wallRio = Provider.of<WallRio>(context, listen: false);
    if (wallRio.originalWallList.isEmpty) {
      wallRio.getListFromAPI(context);
      await _waitUntil(() => wallRio.originalWallList.isNotEmpty);
    }
    final wall = _findWall(wallRio.originalWallList, itemId);
    if (wall == null) {
      _fallbackToHome(context, 'Couldn\'t find that wallpaper anymore');
      return;
    }
    if (!context.mounted) return;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => FullImage(wallModel: wall)));
  }

  static Future<void> _openDesktopItem(
      BuildContext context, int itemId) async {
    final wallRio = Provider.of<WallRio>(context, listen: false);
    if (wallRio.desktopWallList.isEmpty) {
      await wallRio.fetchDesktopWallpapers();
    }
    final wall = _findWall(wallRio.desktopWallList, itemId);
    if (wall == null) {
      _fallbackToHome(context, 'Couldn\'t find that wallpaper anymore');
      return;
    }
    if (!context.mounted) return;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DesktopWallpaperDetailPage(wallModel: wall)));
  }

  static Future<void> _openLiveItem(BuildContext context, int itemId) async {
    final liveProvider =
        Provider.of<LiveWallpaperProvider>(context, listen: false);
    if (liveProvider.wallList.isEmpty) {
      await liveProvider.getListFromAPI();
    }
    LiveWallpaper? wall;
    for (final w in liveProvider.wallList) {
      if (w.id == itemId) {
        wall = w;
        break;
      }
    }
    if (wall == null) {
      _fallbackToHome(context, 'Couldn\'t find that wallpaper anymore');
      return;
    }
    if (!context.mounted) return;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => LiveDetailPage(wall: wall!)));
  }

  static Walls? _findWall(List<Walls> list, int id) {
    for (final w in list) {
      if (w.id == id) return w;
    }
    return null;
  }

  static void _fallbackToHome(BuildContext context, String message) {
    ToastWidget.showToast(message);
    Provider.of<Navigation>(context, listen: false).setIndex = 0;
  }

  static Future<void> _waitUntil(bool Function() condition,
      {Duration timeout = const Duration(seconds: 8)}) async {
    final deadline = DateTime.now().add(timeout);
    while (!condition() && DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
