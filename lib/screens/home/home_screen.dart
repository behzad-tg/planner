import 'package:date_piker/animations/down_to_up_animation.dart';
import 'package:date_piker/animations/scale_Fade.dart';
import 'package:date_piker/screens/home/controller.dart';
import 'package:date_piker/screens/home/pages/add_plan.dart';
import 'package:date_piker/screens/home/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateGetxController dateGetxControlle = Get.put(DateGetxController());
  PlanController planController = Get.put(PlanController());
  @override
  void initState() {
    dateGetxControlle.getToday();

    planController
        .updatePlanList(dateGetxControlle.selectDate.value.toDateTime());
    Future.delayed(const Duration(milliseconds: 100), () {
      dateGetxControlle.calenderHorizonalController
          .jumpToSelection(dateGetxControlle.selectDate.value.toDateTime());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 0,
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        DownToUpAnimation(
                          delay: 0.0,
                          child: Text(
                            'فلاتر تی جی',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // DownToUpAnimation(
                        //   delay: 0.3,
                        //   child: Icon(
                        //     Icons.more_vert_outlined,
                        //     color: Colors.white,
                        //     size: 20,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const DownToUpAnimation(
                      delay: 0.4,
                      child: Text(
                        '360 روز گذشت',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    DownToUpAnimation(
                      delay: 0.5,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 100,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 8,
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const HomePage(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ScaleFadeAnimation(
          delay: 1,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black38,
                // barrierDismissible: true,
                builder: (context) => const AddPlanDialog(),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),

        // floatingActionButton: DownToUpFade(
        //   delay: 1.6,
        //   child: OpenContainer(

        //     openColor: Colors.transparent,
        //     transitionType: ContainerTransitionType.fade,

        //     openBuilder: (context, action) {
        //       return AddPlanDialog();
        //     },
        //     closedColor: Colors.black,
        //     closedElevation: 4.0,
        //     closedShape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(25),
        //       ),
        //     ),
        //     closedBuilder: (context, action) => Container(
        //       padding: const EdgeInsets.all(20),
        //       child: const Icon(
        //         Icons.add,
        //         color: Colors.white,
        //         size: 25,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
