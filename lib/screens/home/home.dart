import 'package:bustrack/screens/map/currentloc.dart';
import 'package:bustrack/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bustrack/models/models.dart';

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
      body: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => Provider<AppUser>.value(
                      value: Provider.of<AppUser>(context),
                      child: const CurLoc())),
            ),
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(8),
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: const [
                    Text('Current Bus Location',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Icon(Icons.directions_bus, color: Colors.white)
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
