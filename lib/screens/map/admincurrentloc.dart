import 'package:flutter/material.dart';
import 'package:bustrack/screens/map/adminmap.dart';

class AdminCurLoc extends StatefulWidget {
  const AdminCurLoc({super.key});

  @override
  State<AdminCurLoc> createState() => _AdminCurLocState();
}

class _AdminCurLocState extends State<AdminCurLoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Current Location'),
      ),
      body: const AdminMapWidget(),
    );
  }
}
