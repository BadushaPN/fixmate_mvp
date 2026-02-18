import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_motion.dart';

class AppReveal extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final double offsetY;

  const AppReveal({
    required this.child,
    this.delayMs = 0,
    this.offsetY = 0.04,
    super.key,
  });

  @override
  State<AppReveal> createState() => _AppRevealState();
}

class _AppRevealState extends State<AppReveal> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: widget.delayMs), () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.maybe(AppMotion.slow, context);
    final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);
    return AnimatedSlide(
      duration: duration,
      curve: curve,
      offset: _visible ? Offset.zero : Offset(0, widget.offsetY),
      child: AnimatedOpacity(
        duration: duration,
        curve: curve,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
