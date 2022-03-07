import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DayWidget extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final Color? selectDayColor;
  final Color? selectDayTextColor;
  final double width;
  final Function? onDaySelected;
  const DayWidget({
    Key? key,
    required this.date,
    required this.isSelected,
    this.selectDayColor,
    this.selectDayTextColor,
    this.onDaySelected,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jalalidate = Jalali.fromDateTime(date);
    return InkWell(
      onTap: () {
        // Check if onDateSelected is not null
        if (onDaySelected != null) {
          // Call the onDateSelected Function
          onDaySelected!(date);
        }
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.only(top: 8, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18.0)),
          color: isSelected
              ? (selectDayColor ?? Colors.brown.withOpacity(0.5))
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              jalalidate.formatter.wN.substring(0, 1), // WeekDay
              style: TextStyle(
                color: isSelected
                    ? (selectDayTextColor ?? Colors.black54)
                    : Colors.black54,
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              jalalidate.formatter.d, // Date
              style: TextStyle(
                color: isSelected
                    ? (selectDayTextColor ?? Colors.black)
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            // Text(
            //   jalalidate.formatter.mN, // WeekDay
            //   style: const TextStyle(
            //     color: Colors.black38,
            //     fontSize: 12,
            //     // fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
