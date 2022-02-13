// ignore_for_file: prefer_const_constructors

import 'package:alarmapp/Controller/hour_hand_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Create Hour Hand
class HourHand extends StatelessWidget {

  /// initialize all value form hour hand
  final HourHandController _hourHandController = Get.put(HourHandController());

  HourHand({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _hourHandController.panUpdateHandlerHour,
      onPanEnd: _hourHandController.panEndHandlerHour(),
      child: Container(
        height: (_hourHandController.wheelSize / 2) * 1.5,
        width: (_hourHandController.wheelSize / 2) * 1.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Align(
          alignment: Alignment(0, 0),
          child: AnimatedBuilder(
            animation: _hourHandController.ctrlHour,
            builder: (ctx, w) {
              return Transform.rotate(
                angle: _hourHandController
                    .degreeToRadians(_hourHandController.ctrlHour.value),
                child: Container(
                  width: 8,
                  height: 156,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topCenter,
                          colors: const [
                            Colors.transparent,
                            Colors.blue,
                            Colors.blue,
                          ]),
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
