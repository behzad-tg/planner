import 'package:date_piker/animations/open_screen_animations.dart';
import 'package:date_piker/const.dart';
import 'package:date_piker/screens/home/controller.dart';
import 'package:date_piker/screens/home/pages/plan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaterfallAnimation extends StatefulWidget {
  final AnimationController controller;
  const WaterfallAnimation({Key? key, required this.controller})
      : super(key: key);

  @override
  _WaterfallAnimationState createState() => _WaterfallAnimationState();
}

class _WaterfallAnimationState extends State<WaterfallAnimation> {
  @override
  Widget build(BuildContext context) {
    PlanController planController = Get.put(PlanController());
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: planController.selectDayPlans.length,
      itemBuilder: (context, index) {
        var plan = planController.selectDayPlans[index];
        Color color =
            plan.isdone == 1 ? isDoneColor : colors[index % colors.length];
        final int count = planController.selectDayPlans.length > 10
            ? 10
            : planController.selectDayPlans.length;
        final Animation<double> opacity =
            Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.controller,
            curve:
                Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
          ),
        );
        final Animation<double> transitionY =
            Tween<double>(begin: 40.0, end: 0.0).animate(
          CurvedAnimation(
            parent: widget.controller,
            curve:
                Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
          ),
        );
        widget.controller.forward();
        return AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) => Opacity(
            opacity: opacity.value,
            child: Transform.translate(
              offset: Offset(transitionY.value, 0),
              child: Container(
                padding: const EdgeInsets.only(right: 30, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: OpenContainer(
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionType: ContainerTransitionType.fade,
                        middleColor: color,
                        openColor: color,
                        openElevation: 0,
                        openBuilder: (context, action) {
                          return PlanPage(
                            plan: plan,
                            color: color,
                          );
                        },
                        closedColor: color,
                        closedElevation: 0,
                        closedShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        onClosed: (a) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            setState(() {
                              color = plan.isdone == 1
                                  ? isDoneColor
                                  : colors[index % colors.length];
                            });
                          });
                        },
                        closedBuilder: (context, action) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  plan.title,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                plan.text!.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          plan.text.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          style: const TextStyle(
                                            color: Colors.black38,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      width: 70,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontFamily: 'Samim',
                          ),
                          children: [
                            TextSpan(
                              text: DateTime.parse(plan.date).hour.toString(),
                            ),
                            const TextSpan(text: ':'),
                            TextSpan(
                              text: DateTime.parse(plan.date).minute.toString(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black26,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
