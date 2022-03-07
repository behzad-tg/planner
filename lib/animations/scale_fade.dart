// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ScaleFadeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;
  const ScaleFadeAnimation({Key? key, required this.child, required this.delay})
      : super(key: key);

  @override
  _ScaleFadeAnimationState createState() => _ScaleFadeAnimationState();
}

class _ScaleFadeAnimationState extends State<ScaleFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<double> scale;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    opacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
    scale = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    startAnimation();
    super.initState();
  }

  startAnimation() async {
    await Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.scale(
            scale: scale.value,
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
