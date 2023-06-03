import 'package:bustrack/screens/attendance/attendancetile.dart';
import 'package:bustrack/services/database.dart';
import 'package:flutter/material.dart';

class AttendanceSheet extends StatefulWidget {
  const AttendanceSheet({super.key});

  @override
  State<AttendanceSheet> createState() => _AttendanceSheetState();
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  final db = DataBaseServices();
  final List<bool> _time = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  if (index == 0) {
                    _time[0] = true;
                    _time[1] = false;
                  } else {
                    _time[0] = false;
                    _time[1] = true;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.green[700],
              selectedColor: Colors.white,
              fillColor: Colors.green,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              color: Colors.green[400],
              constraints: BoxConstraints(
                minHeight: 80,
                minWidth: MediaQuery.of(context).size.width / 2 - 36,
              ),
              isSelected: _time,
              children: const [
                Text(
                  'Morning',
                ),
                Text('Evening')
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: db.getStudents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, idx) {
                      final stddoc = snapshot.data!.docs[idx];
                      return StreamBuilder(
                          stream: db.getAttendance(stddoc.id),
                          builder: (context, snap) {
                            return AttendanceTile(
                              attendanceSnap: snap,
                              studentDoc: stddoc,
                              isPickup: _time[0],
                            );
                          });
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
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
