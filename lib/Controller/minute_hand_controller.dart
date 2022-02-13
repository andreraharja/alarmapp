import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MinuteHandController extends GetxController
    with GetTickerProviderStateMixin {

  /// defualt minute
  var minute = "0".obs;

  /// for move / slide minute hand
  late AnimationController ctrlMinute;

  /// init degree for minute hand
  double degreeMinute = 0;
  int valueChooseMinute = 0;
  final double wheelSize = 300;

  @override
  void onInit() {
    minute.value = "00";
    ctrlMinute = AnimationController.unbounded(vsync: this);
    degreeMinute = 0;
    ctrlMinute.value = degreeMinute;
    super.onInit();
  }

  double degreeToRadians(double degrees) => degrees * (pi / 180);

  double roundToBase(double number, int base) {
    double reminder = number % base;
    double result = number;
    if (reminder < (base / 2)) {
      result = number - reminder;
    } else {
      result = number + (base - reminder);
    }
    return result;
  }

  /// Function for show the number in minutes by calculating the width of the angle
  panUpdateHandlerMinute(DragUpdateDetails d) {
    bool onTop = d.localPosition.dy <= wheelSize / 2;
    bool onLeftSide = d.localPosition.dx <= wheelSize / 2;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationalChange = verticalRotation + horizontalRotation;

    double _value = degreeMinute + (rotationalChange / 5);

    degreeMinute = _value > 0 ? _value : 0;
    ctrlMinute.value = degreeMinute;
    double a = 0.0;
    if (degreeMinute < 360) {
      a = degreeMinute.roundToDouble();
    } else {
      a = degreeMinute - 360;
      degreeMinute = a;
    }

    var degrees = roundToBase(a.roundToDouble(), 10);
    valueChooseMinute = degrees ~/ 6 == 60 ? 0 : degrees ~/ 6;
    minute.value = valueChooseMinute.toString();
    if (valueChooseMinute.toString().length < 2) {
      minute.value = '0' + valueChooseMinute.toString();
    }
  }

  panEndHandlerMinute() {
    var a =
        degreeMinute < 360 ? degreeMinute.roundToDouble() : degreeMinute - 360;
    ctrlMinute
        .animateTo(roundToBase(a.roundToDouble(), 10),
            duration: const Duration(milliseconds: 551),
            curve: Curves.easeOutBack)
        .whenComplete(() {
      degreeMinute = roundToBase(a.roundToDouble(), 10);
    });
  }
}
