import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:monitor_lizard/constants/states.dart';
import 'package:monitor_lizard/providers/AttendanceProvider.dart';
import 'package:monitor_lizard/services/authService.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime today = DateTime.now();
  int day = DateTime.now().weekday;
  Color indicatorColor = AppColors.gray;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadData();
  }

  void loadData() async {
    try {
      await context.read<AttendanceProvider>().retrieveEmployeeData();
      // ignore: use_build_context_synchronously
      await context.read<AttendanceProvider>().retrieveOrganizationData();
      // ignore: use_build_context_synchronously
      await context.read<AttendanceProvider>().checkCurrentLogExists();
      // ignore: use_build_context_synchronously
      await context.read<AttendanceProvider>().trackTime();
      // ignore: use_build_context_synchronously
      await context.read<AttendanceProvider>().trackUserLocation();

      // ignore: use_build_context_synchronously
      indicatorColor = context.read<AttendanceProvider>().isWorkingHours
          ? AppColors.pink
          : AppColors.green;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: const Text(
            "Home",
          ),
          centerTitle: true,
          foregroundColor: AppColors.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<AttendanceProvider>(
          builder: (context, attendance, child) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Monday",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "19/08/2022",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    // padding: const EdgeInsets.all(8),
                    child: CircularPercentIndicator(
                      radius: 120,
                      lineWidth: 18,
                      percent: attendance.timePercentage,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(attendance.currentTime),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 54,
                                color: AppColors.dark),
                          ),
                          Text(
                            "${attendance.isWorkingHours ? "Closing Time" : "Work Time"}: ${DateFormat('HH:mm').format(attendance.isWorkingHours ? attendance.organization?.closingTime.toDate() ?? DateTime.now() : attendance.organization?.startingTime.toDate() ?? DateTime.now())}",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: attendance.atWork
                                    ? AppColors.green
                                    : attendance.runningLate
                                        ? AppColors.pink
                                        : AppColors.gray),
                          )
                        ],
                      ),
                      backgroundColor: AppColors.lightgray,
                      progressColor: attendance.atWork
                          ? AppColors.green
                          : attendance.runningLate
                              ? AppColors.pink
                              : AppColors.gray,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Status: ${attendance.atWork ? "At Work" : attendance.runningLate ? "Running Late" : "Out of Office"}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  attendance.runningLate
                      ? Column(
                          children: [
                            Text(
                              "Distance to Office",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: attendance.atWork
                                      ? AppColors.green
                                      : attendance.runningLate
                                          ? AppColors.pink
                                          : AppColors.gray),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${attendance.distanceToOffice}km",
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: attendance.atWork
                                      ? AppColors.green
                                      : attendance.runningLate
                                          ? AppColors.pink
                                          : AppColors.gray),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : const SizedBox(
                          height: 0,
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
