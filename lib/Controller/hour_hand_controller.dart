import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HourHandController extends GetxController
    with GetTickerProviderStateMixin {
  var hour = "0".obs;
  var minute = "0".obs;
  late AnimationController ctrlHour;
  double degreeHour = 0;
  int valueChooseHour = 0;
  final double wheelSize = 300;

  @override
  void onInit() {
    hour.value = "00";
    ctrlHour = AnimationController.unbounded(vsync: this);
    degreeHour = 0;
    ctrlHour.value = degreeHour;
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

  panUpdateHandlerHour(DragUpdateDetails d) {
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

    double _value = degreeHour + (rotationalChange / 5);

    degreeHour = _value > 0 ? _value : 0;
    ctrlHour.value = degreeHour;
    double a = 0.0;
    if (degreeHour < 360) {
      a = degreeHour.roundToDouble();
    } else {
      a = degreeHour - 360;
      degreeHour = a;
    }

    var degrees = roundToBase(a.roundToDouble(), 10);
    valueChooseHour = degrees ~/ 30 == 12 ? 0 : degrees ~/ 30;
    hour.value = valueChooseHour.toString();
    if (valueChooseHour.toString().length < 2) {
      hour.value = '0' + valueChooseHour.toString();
    }
  }

  panEndHandlerHour() {
    var a = degreeHour < 360 ? degreeHour.roundToDouble() : degreeHour - 360;
    ctrlHour
        .animateTo(roundToBase(a.roundToDouble(), 10),
            duration: const Duration(milliseconds: 551),
            curve: Curves.easeOutBack)
        .whenComplete(() {
      degreeHour = roundToBase(a.roundToDouble(), 10);
    });
  }
}
