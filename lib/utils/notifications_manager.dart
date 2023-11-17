import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager {
  static final NotificationsManager shared = NotificationsManager._internal();

  factory NotificationsManager() => shared;

  NotificationsManager._internal();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'DrinkWatter Channel', // id
    'DrinkWatter', // title
    importance: Importance.max,
  );

  initializeLocalPushs() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'ic_notification_logo',
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (_) {},
    );
  }

  Future<void> setupForegroundNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  showRememberNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'remember_notification',
      'remember',
      channelDescription: 'repeating description',
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: 'remember_notification',
      threadIdentifier: 'remember',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      macOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'Já bebeu água?',
      'Se ainda não, que tal fazer uma pausa e beber agora?',
      notificationDetails,
    );
  }
}
