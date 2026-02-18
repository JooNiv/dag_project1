import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "../utils/date_utils.dart";
import '../services/entry_service.dart';

class MonthGrid extends StatelessWidget {
  final int month;

  MonthGrid({super.key, required this.month});

  final EntryService entryService = Get.find<EntryService>();

  @override
  Widget build(BuildContext context) {
    int padBeginningSquares = getIndexOfFirstDayInAMonth(month) - 1 + 7;

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        width: 500,
        padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(children: [
          Text(
            monthNames[month],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: 7),
            itemBuilder: (context, index) {
              if (index < 7) {
                return _buildWeekdayHeader(index);
              }
              else if (index < padBeginningSquares) {
                return _buildPaddingSquare();
              }
              else {
                final day = index + 1 - padBeginningSquares;
                final dateTimeString = "2026-${month + 1}-$day";
                final todayDateTimeString =
                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
                final color = entryService.getColorForDate(dateTimeString);

                return _buildDateSquare(
                  day: day,
                  month: month,
                  color: color,
                  isToday: dateTimeString == todayDateTimeString,
                );
              }
            },
            itemCount: getDaysInAMonth(month) + padBeginningSquares,
          )
        ]));
  }
}

Widget _buildWeekdayHeader(int index) {
  return Container(
    color: Colors.transparent,
    child: Center(
      child: Text(
        weekdayIndexToName(index + 1).substring(0, 3),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget _buildPaddingSquare() {
  return Container(
    color: Colors.transparent,
  );
}

Widget _buildDateSquare(
    {required int day, required month, required Color color, required bool isToday}) {
  final decoration = isToday
      ? BoxDecoration(
          color: color,
          border: Border.all(color: Colors.blue, width: 2),
        )
      : BoxDecoration(color: color);

  return GestureDetector(
    onTap: () {
      Get.toNamed("/entry/${DateTime.now().year}-${month + 1}-$day");
    },
    child: Container(
      decoration: decoration,
      child: Center(child: Text("$day")),
    ),
  );
}
