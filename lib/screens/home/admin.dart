import 'dart:async';

import 'package:bustrack/models/models.dart';
import 'package:bustrack/screens/attendance/attendancesheet.dart';
import 'package:bustrack/screens/authenticate/register.dart';
import 'package:bustrack/screens/home/attentancebutton.dart';
import 'package:bustrack/screens/home/locationbutton.dart';
import 'package:bustrack/screens/home/messagebutton.dart';
import 'package:bustrack/screens/messagesentpage.dart';
import 'package:bustrack/services/auth.dart';
import 'package:bustrack/services/database.dart';
import 'package:bustrack/services/location.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/screens/map/admincurrentloc.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AuthService _auth = AuthService();
  final location = LocationService();
  final db = DataBaseServices();
  String? errorMessage;
  StreamSubscription<LocationData>? locSubs;
  var _isJourney = false;
  Future signOut() async {
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
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
      body: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Register new User'),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => Provider<AppUser>.value(
                        value: Provider.of<AppUser>(context),
                        child: const Register()))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: _isJourney
                      ? null
                      : () async {
                          setState(() {
                            _isJourney = true;
                          });
                          listenLocation(
                              Provider.of<AppUser>(context, listen: false).uid);
                        },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Start Journey')),
              ElevatedButton(
                  onPressed: _isJourney
                      ? () => setState(() {
                            _isJourney = false;
                            stopListening();
                          })
                      : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Stop Journey')),
            ],
          ),
          Text(errorMessage ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 14.0)),
          Row(
            children: const [
              LocationButton(pointer: AdminCurLoc()),
              AttentanceButton(pointer: AttendanceSheet()),
            ],
          ),
          Row(
            children: const [
              MessageButton(
                pointer: MessageSent(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> listenLocation(String uid) async {
    locSubs = location.onlocationChanges!.handleError((onError) {
      setState(() {
        errorMessage = onError.toString();
      });
      locSubs?.cancel();
      setState(() {
        locSubs = null;
        _isJourney = false;
      });
    }).listen((LocationData currentlocation) async {
      await db.updateLoc(
          uid, currentlocation.latitude, currentlocation.longitude);
    });
  }

  stopListening() {
    locSubs?.cancel();
    setState(() {
      locSubs = null;
    });
  }
}
