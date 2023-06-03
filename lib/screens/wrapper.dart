import 'package:bustrack/models/models.dart';
import 'package:bustrack/screens/authenticate/sign_in.dart';
import 'package:bustrack/screens/home/admin.dart';
import 'package:bustrack/screens/home/home.dart';
import 'package:bustrack/screens/loading.dart';
import 'package:bustrack/services/auth.dart';
import 'package:bustrack/services/database.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  final AuthService _auth = AuthService();
  Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.authStateChanges,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? futureBuilder(snapshot.data!.uid)
              : const SignIn();
        });
  }
}

Widget futureBuilder(uid) => FutureBuilder(
    future: DataBaseServices().getUser(uid),
    builder: (context, snapshot) {
      return snapshot.hasData
          ? MultiProvider(
              providers: [
                Provider<AppUser>(
                    create: (_) => AppUser(
                        admin: snapshot.data['admin'],
                        userType: snapshot.data['type'],
                        name: snapshot.data['name'],
                        clas: snapshot.data['class'],
                        div: snapshot.data['div'],
                        uid: uid))
              ],
              builder: (context, child) => context.read<AppUser>().userType == 0
                  ? Home()
                  : const AdminHome(),
            )
          : const Loading();
    });
