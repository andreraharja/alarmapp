// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:alarmapp/Controller/hour_hand_controller.dart';
import 'package:alarmapp/Controller/minute_hand_controller.dart';
import 'package:alarmapp/Controller/my_alarm_controller.dart';
import 'package:alarmapp/View/hour_hand.dart';
import 'package:alarmapp/View/minute_hand.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'analog_clock_painter.dart';

class MyAlarmApp extends StatelessWidget {

  ///initialize all value in controller
  final MyAlarmController _myAlarmController = Get.put(MyAlarmController());
  final HourHandController _hourHandController = Get.put(HourHandController());
  final MinuteHandController _minuteHandController =
      Get.put(MinuteHandController());

  MyAlarmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///initialize painter to create clock
    ClockPainter clockPainter = ClockPainter(
        wheelSize: _myAlarmController.wheelSize,
        longNeedleHeight: _myAlarmController.longNeedleHeight,
        shortNeedleHeight: _myAlarmController.shortNeedleHeight,
        context: context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Alarm',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          ///for turn on and turn off alarm
          Obx(() => Align(
                alignment: Alignment.center,
                child: Text(
                  _myAlarmController.isActive.value ? 'Active' : 'Off',
                  style: TextStyle(
                    color: _myAlarmController.isActive.value
                        ? Colors.green
                        : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          Obx(() => Switch(
              value: _myAlarmController.isActive.value,
              activeColor: const Color(0xff65D1BA),
              onChanged: (value) {
                _myAlarmController.updateSwitch(value);
                if (_myAlarmController.isActive.value == true) {
                  _myAlarmController.showNotificationSchedule(
                      title: 'Alarm',
                      body: 'Your alarm is active',
                      payload: _myAlarmController
                          .setAlarm(_hourHandController.hour.value,
                              _minuteHandController.minute.value)
                          .toString(),
                      scheduleDate: _myAlarmController.setAlarm(
                          _hourHandController.hour.value,
                          _minuteHandController.minute.value));
                  Get.snackbar("Message", "Your Alarm is Active",
                      borderRadius: 0,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white);
                } else {
                  _myAlarmController.cancel();
                }
              }))
        ],
      ),
      body: Column(
        children: [
          ///show time in digital format HH:mm, when the first application is opened, the clock will show 00:00 AM
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text(_hourHandController.hour.value,
                    style: const TextStyle(
                        fontSize: 54, fontWeight: FontWeight.bold))),
                const SizedBox(
                  width: 5,
                ),
                const Text(':',
                    style:
                        TextStyle(fontSize: 54, fontWeight: FontWeight.bold)),
                const SizedBox(
                  width: 5,
                ),
                Obx(() => Text(_minuteHandController.minute.value,
                    style: const TextStyle(
                        fontSize: 54, fontWeight: FontWeight.bold))),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 0,
                          groupValue: _myAlarmController.radioValue.value,
                          onChanged: (value) {
                            _myAlarmController.handleRadioValueChange(0);
                          })),
                      Text(
                        'Am',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Obx(() => Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 1,
                          groupValue: _myAlarmController.radioValue.value,
                          onChanged: (value) {
                            _myAlarmController.handleRadioValueChange(1);
                          })),
                      Text(
                        'Pm',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              ///Make a circle to form the clock and the numbers
              SizedBox(
                width: _myAlarmController.wheelSize,
                height: _myAlarmController.wheelSize,
                child: Container(
                    color: Colors.transparent,
                    child: Center(child: CustomPaint(painter: clockPainter))),
              ),
              Container(
                width: _myAlarmController.wheelSize,
                height: _myAlarmController.wheelSize,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              /// make hands for minutes
              MinuteHand(),
              /// make hands for hours
              HourHand(),
            ],
          )
        ],
      ),
    );
  }
}
