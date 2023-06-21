import 'package:bustrack/services/auth.dart';
import 'package:bustrack/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/screens/map/map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class CurLoc extends StatefulWidget {
  const CurLoc({super.key});

  @override
  State<CurLoc> createState() => _CurLocState();
}

class _CurLocState extends State<CurLoc> {
  final mapController = MapController();
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
      body: StreamBuilder(
   stream: DataBaseServices().getAttendance(AuthService().currentUser!.uid),

        builder: (context, snapshot) {
          
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .75,
                child: MapWidget(
                  mapController: mapController,
                  snapshot1:snapshot
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Expanded(
                        child: GestureDetector(
                              onTap: () => snapshot.hasData ? mapController.move(LatLng(snapshot.data!['pickuplatitude'],snapshot.data!['pickuplongitude']), 15):null,
                          child: Card(
                              color: Colors.green,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.location_on),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Pick up',
                                        style: TextStyle(fontWeight: FontWeight.bold))
                                  ])),
                        )),
                    Expanded(
                        child: GestureDetector(
                          onTap: () => snapshot.hasData ? mapController.move(LatLng(snapshot.data!['droplatitude'],
                              snapshot.data!['droplongitude']), 15) : null,
                          child: Card(
                              color: Colors.yellow,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.location_on),
                                    SizedBox(height: 5),
                                    Text(
                                      'Drop',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  ])),
                        )),
                  ]),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
