// ignore_for_file: avoid_print

import 'package:date_piker/animations/dialog_animation.dart';
import 'package:date_piker/animations/scale_fade.dart';
import 'package:date_piker/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../controller.dart';

class PlanPage extends StatefulWidget {
  final Plan plan;
  final Color color;
  const PlanPage({Key? key, required this.color, required this.plan})
      : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  DateGetxController dateGetxControlle = Get.put(DateGetxController());
  PlanController planController = Get.put(PlanController());
  EditPlanController editPlanController = Get.put(EditPlanController());
  refreshPlan() {
    editPlanController.titleInputController.text = widget.plan.title;
    editPlanController.textInputController.text = widget.plan.text!;
    editPlanController.selectDate.value =
        Jalali.fromDateTime(DateTime.parse(widget.plan.date));
    editPlanController.selectTime.value = TimeOfDay(
        hour: DateTime.parse(widget.plan.date).hour,
        minute: DateTime.parse(widget.plan.date).minute);
  }

  @override
  void initState() {
    refreshPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ScaleFadeAnimation(
              delay: 0.3,
              child: Obx(
                () => editPlanController.isChanged.value
                    ? InkWell(
                        onTap: () async {
                          Plan updateplan = Plan(
                            id: widget.plan.id,
                            title: editPlanController.titleInputController.text,
                            text: editPlanController.textInputController.text,
                            date: Jalali(
                              editPlanController.selectDate.value.year,
                              editPlanController.selectDate.value.month,
                              editPlanController.selectDate.value.day,
                              editPlanController.selectTime.value.hour,
                              editPlanController.selectTime.value.minute,
                            ).toDateTime().toString(),
                            isdone: widget.plan.isdone,
                          );
                          await PlanDatabase.instance.update(updateplan);
                          await planController.updatePlanList(
                              dateGetxControlle.selectDate.value.toDateTime());
                          editPlanController.isChanged.value = false;
                        },
                        child: const Icon(
                          Icons.check,
                          size: 25,
                          color: Colors.black,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                deletePlanDialog(context, widget.plan.id),
                          );
                        },
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 30),
          ],
          leadingWidth: 60,
          leading: ScaleFadeAnimation(
            delay: 0.2,
            child: IconButton(
              onPressed: () async {
                refreshPlan();
                editPlanController.isChanged.value = false;
                Navigator.pop(context);
              },
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.close,
                size: 25,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: editPlanController.titleInputController,
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (text) {
                      if (widget.plan.title !=
                          editPlanController.titleInputController.text) {
                        editPlanController.isChanged.value = true;
                      } else {
                        editPlanController.isChanged.value = false;
                      }
                    },
                  ),
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      Obx(
                        () => InkWell(
                          onTap: () async {
                            editPlanController.isChanged.value = true;
                            Jalali? picked = await showPersianDatePicker(
                              context: context,
                              initialDate: Jalali.now(),
                              firstDate: Jalali(1385, 8),
                              lastDate: Jalali(1450, 9),
                            );
                            if (picked != null &&
                                picked != editPlanController.selectDate.value) {
                              editPlanController.selectDate.value = picked;
                              editPlanController.isChanged.value = true;
                            } else {
                              editPlanController.isChanged.value = false;
                            }
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontFamily: 'Samim'),
                              children: [
                                TextSpan(
                                  text: editPlanController
                                      .selectDate.value.formatter.d,
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: editPlanController
                                      .selectDate.value.formatter.mN,
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: editPlanController
                                      .selectDate.value.formatter.y,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Text(' - '),
                      Obx(
                        () => InkWell(
                          onTap: () async {
                            var picked = await showPersianTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: PTimePickerEntryMode.input,
                              builder: (BuildContext context, Widget? child) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: child ?? Container(),
                                );
                              },
                            );
                            if (picked != null) {
                              editPlanController.selectTime.value = picked;
                              editPlanController.isChanged.value = true;
                            } else {
                              editPlanController.isChanged.value = false;
                            }
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontFamily: 'Samim'),
                              children: [
                                TextSpan(
                                  text: editPlanController.selectTime.value.hour
                                      .toString(),
                                ),
                                const TextSpan(text: ':'),
                                TextSpan(
                                  text: editPlanController
                                      .selectTime.value.minute
                                      .toString(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  TextFormField(
                    autofocus: false,
                    controller: editPlanController.textInputController,
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (text) {
                      if (widget.plan.text !=
                          editPlanController.textInputController.text) {
                        editPlanController.isChanged.value = true;
                      } else {
                        editPlanController.isChanged.value = false;
                      }
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: widget.plan.isdone == 1
            ? InkWell(
                onTap: () async {
                  Plan updateplan = Plan(
                    id: widget.plan.id,
                    title: editPlanController.titleInputController.text,
                    text: editPlanController.textInputController.text,
                    date: Jalali(
                      editPlanController.selectDate.value.year,
                      editPlanController.selectDate.value.month,
                      editPlanController.selectDate.value.day,
                      editPlanController.selectTime.value.hour,
                      editPlanController.selectTime.value.minute,
                    ).toDateTime().toString(),
                    isdone: 0,
                  );
                  await PlanDatabase.instance.update(updateplan);
                  Navigator.pop(context);
                },
                child: ScaleFadeAnimation(
                  delay: 0.4,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: () async {
                  Plan updateplan = Plan(
                    id: widget.plan.id,
                    title: editPlanController.titleInputController.text,
                    text: editPlanController.textInputController.text,
                    date: Jalali(
                      editPlanController.selectDate.value.year,
                      editPlanController.selectDate.value.month,
                      editPlanController.selectDate.value.day,
                      editPlanController.selectTime.value.hour,
                      editPlanController.selectTime.value.minute,
                    ).toDateTime().toString(),
                    isdone: 1,
                  );
                  await PlanDatabase.instance.update(updateplan);
                  Navigator.pop(context);
                },
                child: ScaleFadeAnimation(
                  delay: 0.4,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

deletePlanDialog(BuildContext context, int? id) {
  DateGetxController dateGetxControlle = Get.put(DateGetxController());
  PlanController planController = Get.put(PlanController());
  return DialogAnimation(
    delay: 0,
    child: AlertDialog(
      content: const Text("ایا از حذف این پلن مطمعن هستین؟"),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await PlanDatabase.instance.remove(id!);
            Navigator.pop(context);
            await planController.updatePlanList(
                dateGetxControlle.selectDate.value.toDateTime());
          },
          child: const Text('حذف'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('لغو'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.start,
    ),
  );
}
