import 'package:flutter/material.dart';

class AppMotion {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 340);

  static Curve standard(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Curves.easeOutCubic;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Curves.fastOutSlowIn;
    }
  }

  static Curve spring(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Curves.easeOutBack;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Curves.easeOutCubic;
    }
  }

  static bool reduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  static Duration maybe(Duration duration, BuildContext context) {
    return reduceMotion(context) ? Duration.zero : duration;
  }

  static Curve maybeCurve(Curve curve, BuildContext context) {
    return reduceMotion(context) ? Curves.linear : curve;
  }
}
