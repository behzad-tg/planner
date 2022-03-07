// ignore_for_file: avoid_print

import 'package:date_piker/animations/down_to_up_animation.dart';
import 'package:date_piker/animations/scale_fade.dart';
import 'package:date_piker/screens/home/controller.dart';
import 'package:date_piker/screens/home/shamsi_calendar/calendar.dart';
import 'package:date_piker/screens/home/widgets/waterfall_plan_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    DateGetxController dateGetxControlle = Get.put(DateGetxController());
    PlanController planController = Get.put(PlanController());
    WaterfallController waterfallController = Get.put(WaterfallController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => DownToUpAnimation(
                  delay: 0.6,
                  child: Row(
                    children: [
                      Text(
                        "${dateGetxControlle.selectDate.value.day}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        dateGetxControlle.selectDate.value.formatter.mN,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DownToUpAnimation(
                delay: 0.7,
                child: Obx(
                  () => dateGetxControlle.isGetingToday.value
                      ? Container(
                          margin: const EdgeInsets.only(left: 20),
                          width: 20,
                          height: 20,
                          child: const CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () async {
                            final recentDate = Jalali(
                                dateGetxControlle.selectDate.value.year,
                                dateGetxControlle.selectDate.value.month,
                                dateGetxControlle.selectDate.value.day);
                            final today = Jalali(Jalali.now().year,
                                Jalali.now().month, Jalali.now().day);
                            if (recentDate != today) {
                              dateGetxControlle.isGetingToday.value = true;
                              dateGetxControlle.selectDate.value = today;
                              await waterfallController.controller.reverse();
                              setState(() {
                                dateGetxControlle.calenderHorizonalController
                                    .setDateAndAnimate(DateTime.now());
                              });
                              await planController
                                  .updatePlanList(DateTime.now());
                              waterfallController.controller.forward();
                              dateGetxControlle.isGetingToday.value = false;
                            }
                          },
                          child: const Text(
                            'برو به امروز',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        DownToUpAnimation(
          delay: 0.8,
          child: CalenderHorizonal(
            controller: dateGetxControlle.calenderHorizonalController,
            startDate: DateTime(DateTime.now().year, DateTime.now().month - 1,
                DateTime.now().day),
            selectDayColor: Colors.black,
            selectDayTextColor: Colors.white,
            width: 45,
            height: 85,
            onDateChange: (date) async {
              dateGetxControlle.selectDate.value = Jalali.fromDateTime(date);
              await waterfallController.controller.reverse();
              await planController.updatePlanList(date);
              waterfallController.controller.forward();
            },
          ),
        ),
        const SizedBox(height: 20),
        DownToUpAnimation(
          delay: 0.9,
          child: Obx(
            () => planController.selectDayPlans.isEmpty
                ? ScaleFadeAnimation(
                    delay: 0,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 100),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.speaker_notes_off_outlined,
                        color: Colors.black12,
                        size: 120,
                      ),
                    ),
                  )
                : WaterfallAnimation(
                    controller: waterfallController.controller,
                  ),
          ),
        ),
      ],
    );
  }
}
