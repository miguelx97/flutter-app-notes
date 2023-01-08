import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/models/note.dart';
import 'package:flutter_app_notas/models/reminder_time.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  if (kIsWeb) return;
  _configureLocalTimeZone();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  _notificationPermission();
}

Future<void> _notificationPermission() async {
  var status = await Permission.notification.status;
  if (status.isDenied) {
    _wellcomeNotificacion();
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

NotificationDetails _getNotificationDetails() {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'notes_notification',
    'Notificación de notas',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  return notificationDetails;
}

Future<void> setNoteNotificacion(Note note) async {
  if (note.date == null) return;

  NotificationDetails notificationDetails = _getNotificationDetails();

  tz.TZDateTime scheduledNotificationDateTime = tz.TZDateTime.from(
    note.date!,
    tz.local,
  );

  await _setNotificacion(
    note.title,
    Utils.dateTimeFormat(note.date, hasTime: note.hasTime),
    scheduledNotificationDateTime,
    note.createionDate,
    notificationDetails,
  );

  if (!note.hasTime || note.reminderTime == 0) return;

  scheduledNotificationDateTime = scheduledNotificationDateTime
      .subtract(Duration(minutes: note.reminderTime));

  await _setNotificacion(
    note.title,
    "Evento para dentro de ${ReminderTime.name(note.reminderTime)}.",
    scheduledNotificationDateTime,
    note.createionDate + 1,
    notificationDetails,
  );
}

Future<void> deleteNoteNotification(Note note) async {
  await deleteNotification(note.createionDate);
  if (note.reminderTime > 0) await deleteNotification(note.createionDate + 1);
}

Future<void> _wellcomeNotificacion() async {
  NotificationDetails notificationDetails = _getNotificationDetails();

  await flutterLocalNotificationsPlugin.show(
      1, 'Bienvenido a Taskii', '', notificationDetails);
}

Future<void> _setNotificacion(
  String title,
  String description,
  tz.TZDateTime date,
  int id,
  NotificationDetails notificationDetails,
) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    description,
    date,
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> deleteNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(0);
}
