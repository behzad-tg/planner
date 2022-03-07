// ignore_for_file: file_names

import 'package:flutter/material.dart';

class RighToLeftAnimation extends StatefulWidget {
  final double delay;
  final Widget child;
  const RighToLeftAnimation(
      {Key? key, required this.child, required this.delay})
      : super(key: key);

  @override
  _RighToLeftAnimationState createState() => _RighToLeftAnimationState();
}

class _RighToLeftAnimationState extends State<RighToLeftAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<double> transitionX;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    opacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    transitionX = Tween(begin: 20.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    startAnimation();
    super.initState();
  }

  startAnimation() async {
    await Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(transitionX.value, 0.0),
            child: widget.child,
          ),
        );
      },
    );
  }
}
