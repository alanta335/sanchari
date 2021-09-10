import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as l;
import 'package:google_maps_routes/google_maps_routes.dart';

class MapScreen extends StatefulWidget {
  var lat, long;

  MapScreen({@required this.lat, @required this.long});

  @override
  _MapScreenState createState() => _MapScreenState(la: lat, lo: long);
}

class _MapScreenState extends State<MapScreen> {
  _MapScreenState({@required this.la, @required this.lo});
  var la, lo;
  var result;
  var placeId;
  int m = 0;
  var cordinates2;
  var result3;
  bool show = false;
  int countOfP = 0;
  List<LatLng> points = [];
  List<SearchResult> searchResultList = [];
  List<SearchResult> searchResultList2 = [];
  List<SearchResult> searchResultList3 = [];
  List<SearchResult> searchResultList4 = [];
  l.Location location = new l.Location();
  bool _load = true;

  late GoogleMapController _controller;
  late MapsRoutes route = new MapsRoutes();
  TextEditingController searchController = new TextEditingController();
  final Set<Marker> markers = {};
  late String queryS;

  TextEditingController searchQ = TextEditingController();
  var googlePlace = GooglePlace('AIzaSyA1bs9xDzhAEb5IpByX_-e0SzPW1QSXKQU');
  late BitmapDescriptor map_marker,hospital_marker,police_marker,repair_marker,restro_marker;
  List<AutocompletePrediction> predictions = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (la == null) {
        _load = false;
      }
    });
    return SafeArea(
        child: _load
            ? Scaffold(
                body: Stack(fit: StackFit.expand, children: [
                  buildMaps(),
                  floatingSearch(),
                  Positioned(
                    bottom: 10,
                    right: 5,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _nearRest();
                            _controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(la, lo), zoom: 16)),
                            );
                          },
                          child: Container(
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(37, 36, 39, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text('nearby'))),
                        ),
                        GestureDetector(
                          onTap: () async {
                            _firLoc();
                            _controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(la, lo), zoom: 9)),
                            );
                          },
                          child: Container(
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(37, 36, 39, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'find friends',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              markers.clear();
                              route.routes.clear();
                              markers.add(
                                Marker(
                                  position: LatLng(la, lo),
                                  markerId: MarkerId('current_location'),
                                  infoWindow: InfoWindow(
                                      title: 'my location',
                                      snippet: '$la / $lo'),
                                ),
                              );
                              points.clear();
                              points.add(LatLng(la, lo));
                            });
                          },
                          child: Container(
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(37, 36, 39, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Clean Routes',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            FirebaseFirestore.instance
                                .collection('USERS')
                                .doc(
                                    '${FirebaseAuth.instance.currentUser!.uid}')
                                .collection('TRIP')
                                .doc()
                                .set({
                              'name': result3!.result!.name!,
                              'placeId': placeId,
                              'lat': result3!.result!.geometry!.location!.lat!,
                              'lng': result3!.result!.geometry!.location!.lng!,
                              'added_time':
                                  DateTime.now().toString().substring(0, 16),
                            });
                          },
                          child: Container(
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(37, 36, 39, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Add trip',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            : CircularProgressIndicator());
  }

  void addMarker(cordinates) async {
    print('$cordinates----+++++++');
    points.add(cordinates);
    print(points);
    await route.drawRoute(points, 'trip', Colors.black54,
        'AIzaSyA1bs9xDzhAEb5IpByX_-e0SzPW1QSXKQU',
        travelMode: TravelModes.walking);
    await Future.delayed(Duration(seconds: 2));
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

      m = 1;
    });

    print("RRRRRRRRROOOOOOOOOOOOUUUUUUUUTE" + route.toString());
    setState(() {
      m = 1;
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .2),
                  blurRadius: 20.0,
                )
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: TextField(
                  style: TextStyle(
                    color: Color.fromRGBO(148, 153, 162, 1),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search_sharp,
                      color: Color.fromRGBO(148, 153, 162, 1),
                    ),
                    hintText: 'search',
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(148, 153, 162, 1),
                    ),
                  ),
                  onSubmitted: (value) async {
                    _goToPlace(placeId);
                    setState(() async {
                      result3 = await googlePlace.details.get("$placeId");
                      cordinates2 = LatLng(
                          result3!.result!.geometry!.location!.lat!,
                          result3.result!.geometry!.location!.lng!);
                      addMarker(cordinates2);
                    });
                  },
                  controller: searchController,
                  onChanged: (value) {
                    autoCompleteSearch(value);
                  },
                ),
              ),
            ),
          ),
        ),
        show
            ? Container(
                height: 300.0,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title:
                            Text('${predictions.elementAt(index).description}'),
                        onTap: () {
                          searchController.text =
                              predictions.elementAt(index).description!;
                          setState(() {
                            countOfP = 0;
                            placeId = predictions.elementAt(index).placeId;
                            print(placeId);
                            show = false;
                            _goToPlace(placeId);
                          });
                        });
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  Widget buildMaps() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      polylines: route.routes,
      initialCameraPosition: CameraPosition(target: LatLng(la, lo), zoom: 19),
      onMapCreated: (controller) {
        setState(() {
          _controller = controller;
          points.add(LatLng(la, lo));
          print(points.toString());
          markers.add(
            Marker(
              icon: map_marker,
              position: LatLng(la, lo),
              markerId: MarkerId('current_location'),
              infoWindow:
                  InfoWindow(title: 'my location', snippet: '$la / $lo'),
            ),
          );
        });
      },
      markers: markers.toSet(),
      onLongPress: (cordinates) async {
        setState(() {
          addMarker(cordinates);
        });
      },
      onTap: (cordinates) {
        _controller.animateCamera(CameraUpdate.newLatLng(cordinates));
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMrker();
  }

  void setCustomMrker() async {
    map_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/markerfrnd.png');
    
     hospital_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/hospital.png');

    police_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/police.png');

    repair_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/repair.png');

    restro_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/restro.png');
  }

  void addMarkerOfFriends(
      String id, double lat, double long, String name, String loc) {
    setState(() {
      markers.add(
        Marker(
          icon: map_marker,
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
        show = true;
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

  void _nearRest() async {
    var result1 = await googlePlace.search
        .getNearBySearch(Location(lat: la, lng: lo), 5000, type: "hospital");
    var result2 = await googlePlace.search
        .getNearBySearch(Location(lat: la, lng: lo), 10000, type: "police");
    var result3 = await googlePlace.search
        .getNearBySearch(Location(lat: la, lng: lo), 1000, type: "restaurant");
    var result4 = await googlePlace.search
        .getNearBySearch(Location(lat: la, lng: lo), 1000, type: "repair");
    setState(() {
      searchResultList = result1!.results!;
      searchResultList2 = result2!.results!;
      searchResultList3 = result3!.results!;
      searchResultList4 = result4!.results!;
    });
    for (int i = 0; i < searchResultList.length; i++) {
      markers.add(
        Marker(
          icon: hospital_marker,
          infoWindow: InfoWindow(
            title: searchResultList[i].name,
          ),
          markerId: MarkerId(searchResultList[i].name!),
          position: LatLng(searchResultList[i].geometry!.location!.lat!,
              searchResultList[i].geometry!.location!.lng!),
          onTap: () {
            print("___________");
          },
        ),
      );
    }
    for (int i = 0; i < searchResultList2.length; i++) {
      markers.add(
        Marker(
          icon: police_marker,
          infoWindow: InfoWindow(
            title: searchResultList2[i].name,
          ),
          markerId: MarkerId(searchResultList2[i].name!),
          position: LatLng(searchResultList2[i].geometry!.location!.lat!,
              searchResultList2[i].geometry!.location!.lng!),
          onTap: () {
            print("___________");
          },
        ),
      );
    }
    for (int i = 0; i < searchResultList3.length; i++) {
      markers.add(
        Marker(
          icon: restro_marker,
          infoWindow: InfoWindow(
            title: searchResultList3[i].name,
          ),
          markerId: MarkerId(searchResultList3[i].name!),
          position: LatLng(searchResultList3[i].geometry!.location!.lat!,
              searchResultList3[i].geometry!.location!.lng!),
          onTap: () {
            print("___________");
          },
        ),
      );
    }
    for (int i = 0; i < searchResultList4.length; i++) {
      markers.add(
        Marker(
          icon:repair_marker,
          infoWindow: InfoWindow(
            title: searchResultList4[i].name,
          ),
          markerId: MarkerId(searchResultList4[i].name!),
          position: LatLng(searchResultList4[i].geometry!.location!.lat!,
              searchResultList4[i].geometry!.location!.lng!),
          onTap: () {
            print("___________");
          },
        ),
      );
    }
  }
}
