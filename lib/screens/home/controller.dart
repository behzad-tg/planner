import 'package:date_piker/database.dart';
import 'package:date_piker/screens/home/shamsi_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

// --------------------------Date-----------------------------------------
class DateGetxController extends GetxController {
  CalenderHorizonalController calenderHorizonalController =
      CalenderHorizonalController();
  Rx<Jalali> selectDate = Jalali.fromDateTime(DateTime.now()).obs;
  RxBool isGetingToday = false.obs;
  getToday() {
    selectDate.value = Jalali.fromDateTime(DateTime.now());
  }
}

// ---------------------------Plans--------------------------------------
class PlanController extends GetxController {
  Rx<Color> planColor = Colors.white.obs;
  RxList<Plan> selectDayPlans = <Plan>[].obs;

  updatePlanList(DateTime time) async {
    List<Plan> plans = await PlanDatabase.instance.getPlans();
    selectDayPlans.value = plans.where((plan) {
      var getdate = DateTime.parse(plan.date);
      return getdate.day == time.day &&
          getdate.month == time.month &&
          getdate.year == time.year;
    }).toList();
    selectDayPlans.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
  }
}

// --------------------------Plan Service--------------------------------
class AddPlanController extends GetxController {
  TextEditingController titleInputController = TextEditingController();
  TextEditingController textInputController = TextEditingController();
  Rx<Jalali> selectDate = Jalali.now().obs;
  Rx<TimeOfDay> selectTime = TimeOfDay.now().obs;
}

class EditPlanController extends GetxController {
  TextEditingController titleInputController = TextEditingController();
  TextEditingController textInputController = TextEditingController();
  Rx<Jalali> selectDate = Jalali.now().obs;
  Rx<TimeOfDay> selectTime = TimeOfDay.now().obs;
  RxBool isChanged = false.obs;
}

// --------------------------waterfall Controller--------------------------------
class WaterfallController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void onInit() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    super.onInit();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
