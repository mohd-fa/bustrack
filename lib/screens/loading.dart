import 'package:bustrack/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: SpinKitFadingCircle(
                color: Colors.blue[300],
                size: 50,
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () => AuthService().signOut(),
                  child: const Text(
                    'signout',
                    style: TextStyle(fontSize: 5),
                  ),
                ))
          ],
        ));
  }
}
