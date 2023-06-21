import 'package:bustrack/screens/loading.dart';
import 'package:bustrack/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Pos{
  double latitude;
  double longitude;
  Timestamp time;
  Pos({required this.latitude, required this.longitude, required this.time});
}

class MapWidget extends StatefulWidget {
  final MapController mapController;
  final AsyncSnapshot snapshot1;
  const MapWidget({super.key, required this.mapController, required this.snapshot1});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final db = DataBaseServices();

  bool isMapcreated = false;
  recenter(busLang) {
    if (isMapcreated) widget.mapController.move(busLang, 15);
  }

   Pos? prevPos;
  Pos? currPos;
  @override
  Widget build(BuildContext context) {
     
    return StreamBuilder(
        stream: db.getMap,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }
          prevPos = currPos;
          currPos = Pos(latitude: snapshot.data!.docs[0]['latitude'], longitude: snapshot.data!.docs[0]['longitude'], time: snapshot.data!.docs[0]['timestamp']);
          double speed = 0;
  
          if (prevPos != null && currPos != null) speed = speedpos(prevPos!,currPos!);
          String speedstring = 'Speed: ${speed}kmph.';

          LatLng busLang = LatLng(snapshot.data!.docs[0]['latitude'],
              snapshot.data!.docs[0]['longitude']);
          recenter(busLang);
          isMapcreated = true;
          return FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
              center: busLang,
              maxZoom: 17,
              zoom: 15,
              minZoom: 12,
            ),
            nonRotatedChildren: [
              (timeDiff(snapshot.data!.docs[0]['timestamp']
                          as Timestamp) <
                      30)
                  ? Align(
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
                      ))
                  : const SizedBox(),
              AttributionWidget(
                attributionBuilder: (context) =>
                    const Text('flutter_map | © OpenStreetMap'),
                alignment: Alignment.bottomCenter,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Last Updated: ${timeDiff(snapshot.data!.docs[0]['timestamp'] as Timestamp)} mins ago. \n$speedstring",
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
                  (timeDiff(snapshot.data!.docs[0]['timestamp']
                              as Timestamp) <
                          30)
                      ? Marker(
                          point: busLang,
                          width: 80,
                          height: 80,
                          builder: (context) {
                            return const Icon(
                              Icons.directions_bus_rounded,
                              color: Colors.red,
                            );
                          })
                      : null,
                  widget.snapshot1.hasData &&
                          widget.snapshot1.data!.containsKey('pickuplatitude')
                      ? Marker(
                          point: LatLng(widget.snapshot1.data!['pickuplatitude'],
                              widget.snapshot1.data!['pickuplongitude']),
                          width: 100,
                          height: 100,
                          builder: (context) => const Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 30,
                          ),
                        )
                      : null,
                  widget.snapshot1.hasData &&
                          widget.snapshot1.data!.containsKey('droplatitude')
                      ? Marker(
                          point: LatLng(widget.snapshot1.data!['droplatitude'],
                              widget.snapshot1.data!['droplongitude']),
                          width: 80,
                          height: 80,
                          builder: (context) => const Icon(
                            Icons.location_on,
                            color: Colors.yellow,
                          ),
                        )
                      : null,
                ].whereType<Marker>().toList(),
              ),
            ],
          );
        });
  }

  int timeDiff(Timestamp t) {
    return Timestamp.now().toDate().difference(t.toDate()).inMinutes;
  }

  double speedpos(Pos prev, Pos curr){
    final sec = curr.time.toDate().difference(prev.time.toDate()).inSeconds;
    
    var p = 0.017453292519943295;
    var a = 0.5 - cos((curr.latitude - prev.latitude) * p)/2 + 
          cos(prev.latitude * p) * cos(curr.latitude * p) * 
          (1 - cos((curr.longitude - prev.longitude) * p))/2;
    final km = 12742 * asin(sqrt(a));
    return (km*60) / sec;
  }
}
