import 'package:bustrack/screens/loading.dart';
import 'package:bustrack/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final db = DataBaseServices();
  var mapController = MapController();
  bool isMapcreated = false;
  recenter(busLang) {
    if (isMapcreated) mapController.move(busLang, 15);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.getMap,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }
          if (timeDiff(snapshot.data!.docs[0]['timestamp'] as Timestamp) > 30) {
            return Center(
              child: Column(children: [
                const Text('Bus Offline'),
                Text(
                    "Last Seen: ${timeDiff(snapshot.data!.docs[0]['timestamp'] as Timestamp)} mins ago.")
              ]),
            );
          }
          LatLng busLang = LatLng(snapshot.data!.docs[0]['latitude'],
              snapshot.data!.docs[0]['longitude']);
          recenter(busLang);
          isMapcreated = true;
          return FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: busLang,
              maxZoom: 17,
              zoom: 15,
              minZoom: 12,
            ),
            nonRotatedChildren: [
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      child: IconButton(
                          icon: const Icon(
                            Icons.directions_bus_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            recenter(busLang);
                          }),
                    ),
                  )),
              AttributionWidget(
                attributionBuilder: (context) =>
                    const Text('flutter_map | © OpenStreetMap'),
                alignment: Alignment.bottomCenter,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Last Updated: ${timeDiff(snapshot.data!.docs[0]['timestamp'] as Timestamp)} mins ago.",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=22ac4282790d4e14882d152ebcddebc9',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: busLang,
                    width: 80,
                    height: 80,
                    builder: (context) => const Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  int timeDiff(Timestamp t) {
    return Timestamp.now().toDate().difference(t.toDate()).inMinutes;
  }
}
