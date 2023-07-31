import 'package:bustrack/screens/attendance/attendancecard.dart';
import 'package:flutter/material.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                      builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                                textButtonTheme: const TextButtonThemeData(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.blue)))),
                            child: child!,
                          ),
                      initialDate: date,
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  setState(() {
                    date = newDate ?? date;
                  });
                },
                icon: const Icon(Icons.edit_calendar),
                label: const Text('Select Date')),
            AttendanceCard(date: date),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Attendance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
