import 'package:bustrack/services/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class AdminMapWidget extends StatefulWidget {
  const AdminMapWidget({super.key});

  @override
  State<AdminMapWidget> createState() => _AdminMapWidgetState();
}

class _AdminMapWidgetState extends State<AdminMapWidget> {
  var mapController = MapController();
  bool isMapcreated = false;
  recenter(busLang){if(isMapcreated)mapController.move(busLang, 15);}
  final _loc = LocationService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocationData>(
      stream: _loc.onlocationChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData){
        LatLng busLang = LatLng(snapshot.data!.latitude!, snapshot.data!.longitude!);
        recenter(busLang);
        isMapcreated=true;
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
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            recenter(busLang);
                          })),
                ))
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
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        );}else {
          return  Center(child: Column(
          children: [
            const Text('Location Unavailable'),
            ElevatedButton(onPressed: () {
              _loc.getLocationPermition();
              _loc.getLocationService();
            }, child: const Text('Enable Location'))
          ],
        ),);
        }
      }
    );
  }
}
