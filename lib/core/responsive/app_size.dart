import 'package:flutter/material.dart';

class AppSize {
  static late MediaQueryData _media;
  static late double w; // width
  static late double h; // height
  static late double r; // responsive multiplier

  static void init(BuildContext context) {
    _media = MediaQuery.of(context);
    w = _media.size.width;
    h = _media.size.height;

    // responsive scale based on width (390 = iPhone size baseline)
    r = w / 390;
  }

  // responsive font
  static double font(double size) => size * r;

  // responsive width
  static double width(double value) => value * r;

  // responsive height
  static double height(double value) => value * r;

  // width percentage
  static double wp(double percent) => w * percent;

  // height percentage
  static double hp(double percent) => h * percent;
}
