// ignore_for_file: prefer_const_constructors

import 'package:alarmapp/Controller/minute_hand_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Create Minute Hand
class MinuteHand extends StatelessWidget {

  /// init all value form minute hand
  final MinuteHandController _minuteHandController =
      Get.put(MinuteHandController());

  MinuteHand({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _minuteHandController.panUpdateHandlerMinute,
      onPanEnd: _minuteHandController.panEndHandlerMinute(),
      child: Container(
        height: (_minuteHandController.wheelSize / 2) * 2,
        width: (_minuteHandController.wheelSize / 2) * 2,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
        ),
        child: Align(
          alignment: Alignment(0, 0),
          child: AnimatedBuilder(
            animation: _minuteHandController.ctrlMinute,
            builder: (ctx, w) {
              return Transform.rotate(
                angle: _minuteHandController
                    .degreeToRadians(_minuteHandController.ctrlMinute.value),
                child: Container(
                  width: 6,
                  height: 196,
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
