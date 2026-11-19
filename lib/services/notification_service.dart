import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // Gunakan named parameter: settings:
    await _notificationsPlugin.initialize(settings: settings);

    // Minta izin notifikasi (Android 13+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showDeleteNotification(String spellName) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'fav_spell_channel',
          'Favorite Spells',
          channelDescription: 'Notifikasi penghapusan spell favorit',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // Gunakan named parameters: id:, title:, body:, notificationDetails:
    await _notificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: 'Delete notification',
      body: 'You deleted $spellName from your fav list!',
      notificationDetails: details,
    );
  }
}
