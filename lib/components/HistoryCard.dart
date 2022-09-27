import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final DateTime startTime;
  final DateTime closingTime;
  const HistoryCard(
      {Key? key, required this.startTime, required this.closingTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat("dd/MM/yyyy").format(startTime),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.green),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const Icon(
                Icons.punch_clock,
                size: 36,
                color: AppColors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                  flex: 1,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "In",
                                  style: TextStyle(color: AppColors.pink),
                                ),
                                Text(
                                  "${DateFormat("HH:mm").format(startTime)} GMT",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(color: AppColors.gray, width: 2),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Out",
                                  style: TextStyle(color: AppColors.green),
                                ),
                                Text(
                                  "${DateFormat("HH:mm").format(closingTime)} GMT",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Work Time: ${DateFormat("HH:mm").format(calcWorkHours(startTime, closingTime))} H",
              style: const TextStyle(color: AppColors.gray),
            ),
          )
        ],
      ),
    );
  }

  DateTime calcWorkHours(DateTime startTime, DateTime endTime) {
    int startMins = startTime.hour * 60 + startTime.minute;
    int endMins = endTime.hour * 60 + endTime.minute;
    int workMins = endMins - startMins;

    int workHour = workMins % 60;
    int workMinute = workMins - (workHour * 60);

    return DateTime(2022, 0, 0, workHour, workMinute);
  }
}
