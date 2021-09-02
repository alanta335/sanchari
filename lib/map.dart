import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as l;

//import 'searchbar.dart';

class MapScreen extends StatefulWidget {
  final lat, long;

  MapScreen({@required this.lat, @required this.long});

  @override
  _MapScreenState createState() => _MapScreenState(la: lat, lo: long);
}

class _MapScreenState extends State<MapScreen> {
  var la, lo;
  var result;
  var placeId;
  int countOfP = 0;
  l.Location location = new l.Location();
  _MapScreenState({@required this.la, @required this.lo});
  late GoogleMapController _controller;

  Completer<GoogleMapController> _mapController = Completer();
  TextEditingController searchController = new TextEditingController();
  final Set<Marker> markers = {};
  late String queryS;
  TextEditingController searchQ = TextEditingController();
  var googlePlace = GooglePlace('AIzaSyA1bs9xDzhAEb5IpByX_-e0SzPW1QSXKQU');
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
    print('$cordinates----+++++++');
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
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        TextField(
          onSubmitted: (value) {
            _goToPlace(placeId);
          },
          controller: searchController,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'search',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            autoCompleteSearch(value);
          },
        ),
        Container(
          height: 300.0,
          child: ListView.builder(
            itemCount: countOfP,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text('${predictions.elementAt(index).description}'),
                  onTap: () {
                    searchController.text =
                        predictions.elementAt(index).description!;
                    setState(() {
                      countOfP = 0;
                      placeId = predictions.elementAt(index).placeId;
                      print(placeId);
                      _goToPlace(placeId);
                    });
                  });
            },
          ),
        ),
      ],
    );
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
    result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
        print(predictions);
      });
      predictions.map((
        index,
      ) {
        countOfP++;
      }).toList();
    }
  }

  Future<void> _goToPlace(dynamic placeId) async {
    var result2 = await googlePlace.details.get("$placeId");
    _controller.animateCamera(CameraUpdate.newLatLng(LatLng(
        result2!.result!.geometry!.location!.lat!,
        result2.result!.geometry!.location!.lng!)));
  }
}
