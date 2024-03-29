import 'dart:math';

import 'package:wallrio/services/export.dart';
import 'package:wallrio/services/firebase/export.dart';
import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class NotificationService {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'new_walls_notifications',
    'New Content Notifications',
    description: 'This channel is used for new content notifications.',
    playSound: true,
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Permission.notification.request();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          onDidReceiveLocalNotification(notificationResponse.payload ?? "");
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    initFirebaseListeners();
  }

  void onDidReceiveLocalNotification(String payload) {
    if (payload.isNotEmpty) {
      launch(payload);
    }
  }

  void initFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotifications(message: message);
    });
  }

  Future<void> showNotifications({required RemoteMessage message}) async {
    final RemoteNotification notification = message.notification!;
    final int id = Random().nextInt(900) + 10;
    await flutterLocalNotificationsPlugin.show(
        id,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            channelShowBadge: true,
            playSound: true,
            color: bgDarkAccentColor,
            priority: Priority.high,
            importance: Importance.high,
            styleInformation: BigTextStyleInformation(notification.body!),
          ),
        ),
        payload: message.data["link"]);
  }

  void launch(String url) => LaunchUrlWidget.launch(url);
}
