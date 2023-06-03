import 'package:bustrack/services/auth.dart';
import 'package:bustrack/services/database.dart';
import 'package:flutter/material.dart';

class TodayCard extends StatelessWidget {
  TodayCard({super.key});
  final _db = DataBaseServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _db.getAttendance(AuthService().currentUser!.uid),
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
                    const Text('Today',
                        style: TextStyle(
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
