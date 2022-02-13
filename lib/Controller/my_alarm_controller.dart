// ignore_for_file: avoid_print, prefer_const_constructors
import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:alarmapp/View/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class MyAlarmController extends GetxController {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  var controller = StreamController<String?>.broadcast();

  /// flag for Alarm Button
  var isActive = false.obs;

  /// radioValue for AM / PM
  var radioValue = 0.obs;

  /// size for hand clock
  final double wheelSize = 300;
  final double longNeedleHeight = 40;
  final double shortNeedleHeight = 25;

  @override
  void onInit() async {
    /// default AM
    radioValue.value = 0;

    /// initialize notification
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final initializationSettings =
        InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      controller.add(payload!);
    });
    controller.stream.listen(onClickNotification);
    super.onInit();
  }

  /// Function for show bar chart
  void onClickNotification(String? payload) async {
    Get.bottomSheet(
        SingleChildScrollView(
          child: BarChart(
            data: [
              TimeOpen(
                payload,
                DateTime.now().difference(DateTime.parse(payload!)).inSeconds,
                charts.ColorUtil.fromDartColor(
                  const Color(0xff65D1BA),
                ),
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white);
  }

  /// Function for update active alarm
  void updateSwitch(value) {
    isActive(value);
    if (value == false) {
      cancel();
    }
  }

  /// Function for handle am / pm
  void handleRadioValueChange(int value) {
    radioValue.value = value;
  }

  /// Function for set Alarm
  DateTime setAlarm(hour, minute) {
    DateTime now = DateTime.now();
    return DateTime(
        now.year,
        now.month,
        now.hour >
                (radioValue.value == 0 ? int.parse(hour) : int.parse(hour) + 12)
            ? now.day + 1
            : now.hour ==
                        (radioValue.value == 0
                            ? int.parse(hour)
                            : int.parse(hour) + 12) &&
                    now.minute >= int.parse(minute) &&
                    now.second > 0
                ? now.day + 1
                : now.day,
        radioValue.value == 0 ? int.parse(hour) : int.parse(hour) + 12,
        int.parse(minute));
  }

  /// Function for scheduling notification
  Future showNotificationSchedule({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          await notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

  /// Function for notification detail
  Future notificationDetails() async {
    const sound = 'soundalarm.wav';
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id 3',
          'channelName',
          channelDescription: 'your other channel description',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('soundalarm'),
          enableVibration: true,
        ),
        iOS: IOSNotificationDetails(
          sound: sound,
        ));
  }

  /// Function for cancel alarm
  void cancel() => _notifications.cancelAll();
}
