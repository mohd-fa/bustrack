import 'package:flutter/material.dart';
import 'package:bustrack/screens/map/map.dart';

class CurLoc extends StatefulWidget {
  const CurLoc({super.key});

  @override
  State<CurLoc> createState() => _CurLocState();
}

class _CurLocState extends State<CurLoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bus Track Flut'),
      ),
      body: Column(
        children: const [
          SizedBox(
            height: 500,
            child: MapWidget(),
          ),
        ],
      ),
    );
  }
}
