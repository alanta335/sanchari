import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';

class TripView extends StatefulWidget {
  const TripView({Key? key}) : super(key: key);

  @override
  _TripViewState createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {
  var la = 12.6498;
  var lo = 52.6754;
  List<LatLng> points = [];
  late GoogleMapController _controller;
  late MapsRoutes route = new MapsRoutes();
  final Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('TRIP')
        .orderBy('added_time', descending: false);
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("Erroor fetching");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Text("Waiting to get data...."),
              ),
            ),
          );
        }
        return Scaffold(
          body: Stack(fit: StackFit.expand, children: [
            buildMaps(),
            Positioned(
              bottom: 10,
              right: 0,
              child: Column(
                children: [],
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget buildMaps() {
    return GoogleMap(
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      polylines: route.routes,
      initialCameraPosition: CameraPosition(target: LatLng(la, lo), zoom: 19),
      onMapCreated: (controller) {
        setState(() async {
          _controller = controller;
          points.add(LatLng(la, lo));
          print(points.toString());
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
      onTap: (cordinates) {
        _controller.animateCamera(CameraUpdate.newLatLng(cordinates));
      },
    );
  }

  void addMarker(cordinates) async {
    print('$cordinates----+++++++');
    points.add(cordinates);
    print(points);
    await route.drawRoute(points, 'trip', Color.fromRGBO(130, 78, 210, 1.0),
        'AIzaSyA1bs9xDzhAEb5IpByX_-e0SzPW1QSXKQU',
        travelMode: TravelModes.driving);
    await Future.delayed(Duration(seconds: 4));
    //this where thre should be loading
    setState(() {
      markers.add(
        Marker(
          position: cordinates,
          markerId: MarkerId('$cordinates'),
          infoWindow:
              InfoWindow(title: '$cordinates', snippet: 'traveling marker'),
        ),
      );
    });
    print("RRRRRRRRROOOOOOOOOOOOUUUUUUUUTE" + route.toString());
  }
}
