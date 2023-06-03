import 'package:bustrack/screens/attendance/attendancelist.dart';
import 'package:bustrack/screens/home/attentance_button.dart';
import 'package:bustrack/screens/home/profile.dart';
import 'package:bustrack/screens/home/today.dart';
import 'package:bustrack/screens/home/location_button.dart';
import 'package:bustrack/screens/map/currentloc.dart';
import 'package:bustrack/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  Future signOut() async {
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Track Flut'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              await signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const ProfileCard(),
            TodayCard(),
            Row(
              children: const [
                LocationButton(pointer: CurLoc()),
                AttentanceButton(
                  pointer: AttendanceList(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
