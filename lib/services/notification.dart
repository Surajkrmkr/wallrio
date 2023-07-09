import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wallrio/services/packages/export.dart';

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
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/splash');

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
      // onDidReceiveBackgroundNotificationResponse:
      //     (NotificationResponse notificationResponse) {
      //   if (notificationResponse.notificationResponseType ==
      //       NotificationResponseType.selectedNotification) {

      //       }
      // },
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

  void onDidReceiveLocalNotification(String payload) {}

  void initFirebaseListeners() {
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
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
            priority: Priority.high,
            importance: Importance.high,
            styleInformation: BigTextStyleInformation(notification.body!),
          ),
        ),
        payload: message.data["category"]);
  }
}
