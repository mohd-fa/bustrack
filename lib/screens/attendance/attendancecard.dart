import 'package:bustrack/services/auth.dart';
import 'package:bustrack/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceCard extends StatelessWidget {
  final DateTime date;
  AttendanceCard({super.key , required this.date});
  final _db = DataBaseServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _db.getrAttendance(AuthService().currentUser!.uid,date),
        builder: (context, snapshot) {
          return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMEd().format(date),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Pick up',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(snapshot.data?['pickup'] ?? '-- : --',
                                  style: const TextStyle(fontSize: 30))
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Drop down',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(snapshot.data?['drop'] ?? '-- : --',
                                  style: const TextStyle(fontSize: 30)),
                            ],
                          )
                        ]),
                  ],
                ),
              ));
        });
  }
}
