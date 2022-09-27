import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/components/HistoryCard.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:monitor_lizard/providers/AttendanceProvider.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadData();
  }

  loadData() async {
    await context.read<AttendanceProvider>().retrieveAllLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: const Text(
            "History",
          ),
          centerTitle: true,
          foregroundColor: AppColors.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<AttendanceProvider>(
          builder: (context, attendance, child) => ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: attendance.allLogs.length,
              itemBuilder: ((context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6),
                    child: HistoryCard(
                        startTime: attendance.allLogs[index].startTime.toDate(),
                        closingTime:
                            attendance.allLogs[index].endTime.toDate()),
                  ))),
        ));
  }
}
