import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;

class MapScreen extends StatefulWidget {
  final lat, long;

  MapScreen({@required this.lat, @required this.long});

  @override
  _MapScreenState createState() => _MapScreenState(la: lat, lo: long);
}

class _MapScreenState extends State<MapScreen> {
  var la, lo;
  l.Location location = new l.Location();
  _MapScreenState({@required this.la, @required this.lo});
  late GoogleMapController _controller;
  final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("map screen"),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(target: LatLng(la, lo), zoom: 19),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
            markers.add(
              Marker(
                position: LatLng(la, lo),
                markerId: MarkerId('current_location'),
                infoWindow:
                    InfoWindow(title: 'my location', snippet: '$la / $lo'),
              ),
            );
          });
        },
        markers: markers.toSet(),
        onLongPress: (cordinates) {
          addMarker(cordinates);
        },
        onTap: (cordinates) {
          _controller.animateCamera(CameraUpdate.newLatLng(cordinates));
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        //_locationData = await location.getLocation();
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(la, lo), zoom: 16)),
        );
      }),
    );
  }

  void addMarker(cordinates) {
    setState(() {
      markers.add(
        Marker(
          position: cordinates,
          markerId: MarkerId('orgin'),
          infoWindow: InfoWindow(title: 'origin', snippet: 'starting position'),
        ),
      );
    });
  }
}
