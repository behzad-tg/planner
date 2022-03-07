import 'package:date_piker/screens/home/shamsi_calendar/day_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../controller.dart';

class CalenderHorizonal extends StatefulWidget {
  final CalenderHorizonalController? controller;
  final DateTime startDate;
  final Color? selectDayColor;
  final Color? selectDayTextColor;
  final double width;
  final double? height;
  final Function? onDateChange;
  const CalenderHorizonal({
    Key? key,
    this.controller,
    required this.startDate,
    this.selectDayColor,
    this.selectDayTextColor,
    this.onDateChange,
    this.width = 50,
    this.height,
  }) : super(key: key);

  @override
  _CalenderHorizonalState createState() => _CalenderHorizonalState();
}

class _CalenderHorizonalState extends State<CalenderHorizonal> {
  DateGetxController dateGetxControlle = Get.put(DateGetxController());
  final ScrollController _scrollController = ScrollController();
  List listDays = [];

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!.setCalenderHorizonalState(this);
    }
    for (var i = 0; i <= 365; i++) {
      listDays.add(widget.startDate.add(Duration(days: i)));
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 100,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listDays.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          DateTime date = widget.startDate.add(Duration(days: index));
          bool isSelected = _compareDate(
              date, dateGetxControlle.selectDate.value.toDateTime());
          return DayWidget(
            date: date,
            isSelected: isSelected,
            selectDayColor: widget.selectDayColor,
            selectDayTextColor: widget.selectDayTextColor,
            width: widget.width,
            onDaySelected: (DateTime date) {
              setState(() {
                if (widget.onDateChange != null) {
                  widget.onDateChange!(date);
                }
              });
            },
          );
        },
      ),
    );
  }
}

bool _compareDate(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}

class CalenderHorizonalController {
  _CalenderHorizonalState? _calenderHorizonalState;

  void setCalenderHorizonalState(_CalenderHorizonalState state) {
    _calenderHorizonalState = state;
  }

  void jumpToSelection(date) {
    assert(_calenderHorizonalState != null,
        'calenderHorizonalState is not attached to any calenderHorizonal View.');
    _calenderHorizonalState!._scrollController.animateTo(
        _calculateDateOffset(date),
        duration: const Duration(milliseconds: 1),
        curve: Curves.ease);
  }

  setDateAndAnimate(DateTime date) {
    assert(_calenderHorizonalState != null,
        'DatePickerController is not attached to any DatePicker View.');

    _calenderHorizonalState!._scrollController.animateTo(
        _calculateDateOffset(date),
        duration: const Duration(seconds: 1),
        curve: Curves.ease);

    DateGetxController dateGetxControlle = Get.put(DateGetxController());
    dateGetxControlle.selectDate.value = Jalali.fromDateTime(date);
  }

  double _calculateDateOffset(DateTime date) {
    final startDate = DateTime(
        _calenderHorizonalState!.widget.startDate.year,
        _calenderHorizonalState!.widget.startDate.month,
        _calenderHorizonalState!.widget.startDate.day);
    int offset = date.difference(startDate).inDays;
    return (offset * _calenderHorizonalState!.widget.width) + (offset * 6);
  }
}
