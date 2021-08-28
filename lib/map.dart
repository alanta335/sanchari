import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as l;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
//import 'searchbar.dart';
import 'dart:math';

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
  late String queryS;
  TextEditingController searchQ = TextEditingController();
  var googlePlace = GooglePlace('AIzaSyB7cEmy6yQFIoNGtm1mGlELS_BlbC_fv8w');
  List<AutocompletePrediction> predictions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        buildMaps(),
        floatingSearch(),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        _firLoc();
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(la, lo), zoom: 9)),
        );
      }),
    );
  }

  void addMarker(cordinates) {
    print(cordinates);
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

  _firLoc() async {
    Stream<QuerySnapshot> snap = FirebaseFirestore.instance
        .collection("USERS")
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection("FRIENDS")
        .snapshots();
    snap.forEach(
      (field) {
        field.docs.asMap().forEach(
          (index, data) async {
            print('${data.id}-----------');
            if (data.id.toString() != 'NO_OF_FRIENDS') {
              DocumentSnapshot user = await FirebaseFirestore.instance
                  .collection('USERS')
                  .doc('${data.id}')
                  .get();
              double lati = double.parse(user['lat']);
              double longi = double.parse(user['long']);
              addMarkerOfFriends(data.id, lati, longi, user['name'].toString(),
                  user['location'].toString());
            }
          },
        );
      },
    );
  }

  Widget floatingSearch() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return new FloatingSearchBar(
        hint: "Search",
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        transition: CircularFloatingSearchBarTransition(),
        onQueryChanged: (query) async {
          if (query.isNotEmpty) {
            autoCompleteSearch(query);
          } else {
            if (predictions.length > 0 && mounted) {
              setState(() {
                predictions = [];
              });
            }
          }
        },
        builder: (context, transistion) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: predictions.map((
                  index,
                ) {
                  return Container(
                    child: Text(index.description!),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }

  Widget buildMaps() {
    return GoogleMap(
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
    );
  }

  void addMarkerOfFriends(
      String id, double lat, double long, String name, String loc) {
    setState(() {
      markers.add(
        Marker(
          position: LatLng(lat, long),
          markerId: MarkerId('$id'),
          infoWindow: InfoWindow(title: '$name', snippet: '$loc'),
        ),
      );
    });
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
        print(predictions);
      });
    }
  }
}
