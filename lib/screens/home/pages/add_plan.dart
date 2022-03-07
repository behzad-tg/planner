// ignore_for_file: avoid_print

import 'package:date_piker/animations/dialog_animation.dart';
import 'package:date_piker/database.dart';
import 'package:date_piker/screens/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class AddPlanDialog extends StatefulWidget {
  const AddPlanDialog({Key? key}) : super(key: key);

  @override
  _AddPlanDialogState createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<AddPlanDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateGetxController dateGetxControlle = Get.put(DateGetxController());
    AddPlanController addPlanController = Get.put(AddPlanController());
    PlanController planController = Get.put(PlanController());
    return SingleChildScrollView(
      child: DialogAnimation(
        delay: 0,
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'پلن جدید',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: addPlanController.titleInputController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'عنوان...',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    constraints: const BoxConstraints(minHeight: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      controller: addPlanController.textInputController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'پلن شما...',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          Jalali? picked = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1385, 8),
                            lastDate: Jalali(1450, 9),
                          );
                          if (picked != null &&
                              picked != addPlanController.selectDate.value) {
                            addPlanController.selectDate.value = picked;
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range_outlined,
                              size: 25,
                            ),
                            const SizedBox(width: 5),
                            Obx(
                              () => Text(
                                '${addPlanController.selectDate.value.day} ${addPlanController.selectDate.value.formatter.mN} ${addPlanController.selectDate.value.year}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
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
                            addPlanController.selectTime.value = picked;
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.history_toggle_off_rounded,
                              size: 25,
                            ),
                            const SizedBox(width: 5),
                            Obx(
                              () => Text(
                                '${addPlanController.selectTime.value.hour}:${addPlanController.selectTime.value.minute}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      Plan plan = Plan(
                        title: addPlanController.titleInputController.text,
                        text: addPlanController.textInputController.text,
                        date: Jalali(
                          addPlanController.selectDate.value.year,
                          addPlanController.selectDate.value.month,
                          addPlanController.selectDate.value.day,
                          addPlanController.selectTime.value.hour,
                          addPlanController.selectTime.value.minute,
                        ).toDateTime().toString(),
                        isdone: 0,
                      );
                      await PlanDatabase.instance.add(plan);
                      planController.updatePlanList(
                          dateGetxControlle.selectDate.value.toDateTime());
                      addPlanController.titleInputController.text = '';
                      addPlanController.textInputController.text = '';
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'دخیره',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
