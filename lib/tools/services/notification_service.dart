import 'dart:async';
import 'dart:io';

import 'package:ateliya/data/models/notification.dart';
import 'package:ateliya/firebase_options.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _localNotifPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> setup() async {
    await _initializeFirebaseNotification();
    await _initializeLocalNotif();
  }

  static Future<void> _initializeFirebaseNotification() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (Platform.isIOS) {
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    } else {
      throw Exception("Permission not granted for notification");
    }
  }

  static Future<void> showNotif(Notification notif) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'ateliya_channel',
      'Ateliya channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifPlugin.show(
      notif.idOrRandom,
      notif.titre,
      notif.libelle,
      platformChannelSpecifics,
    );
  }

  static Future<void> _initializeLocalNotif() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _localNotifPlugin.initialize(initializationSettings);
  }

  static Future<void> onListen({
    void Function(
      RemoteMessage? message,
      Notification notif,
    )? handler,
  }) async {
    FirebaseMessaging.onMessage.listen(
      (message) {
        final notif = Notification.fromRemonteMessage(message);
        if (Platform.isAndroid) showNotif(notif);
        if (handler != null) handler(message, notif);
      },
    );
  }

  static Future<String?> getFcmToken() async {
    try {
      return _messaging.getToken();
    } catch (e, st) {
      DataResponse.error(systemError: e, stackTrace: st);
      return null;
    }
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    var notif = Notification.fromRemonteMessage(message);
    NotificationService.showNotif(notif);
  }
}
