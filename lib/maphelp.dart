import 'dart:async';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as l;
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homepage.dart';

class MapScreen2 extends StatefulWidget {
  var lat, long;

  MapScreen2({@required this.lat, @required this.long});

  @override
  _MapScreen2State createState() => _MapScreen2State(la: lat, lo: long);
}

class _MapScreen2State extends State<MapScreen2> {
  _MapScreen2State({@required this.la, @required this.lo});
  var la, lo;
  var result;
  var _currentAddress;
  late bool _serviceEnabled;
  late l.PermissionStatus _permissionGranted;
  late l.LocationData _locationData;

  bool _isGetLocation = false;
  bool _isCompleted = false;

  var placeId;
  late gc.Placemark place_sos;
  int m = 0;
  var loc;
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

  late GoogleMapController _controller;
  late MapsRoutes route = new MapsRoutes();
  TextEditingController searchController = new TextEditingController();
  final Set<Marker> markers = {};
  late String queryS;
  bool p3 = true;
  bool p2 = true;
  bool p1 = true;
  TextEditingController searchQ = TextEditingController();
  var googlePlace = GooglePlace('AIzaSyA1bs9xDzhAEb5IpByX_-e0SzPW1QSXKQU');
  late BitmapDescriptor map_marker,
      hospital_marker,
      police_marker,
      repair_marker,
      restro_marker,
      hotel_marker,
      map_marker2;
  List<AutocompletePrediction> predictions = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          buildMaps(),
          Positioned(
            top: 40,
            right: 10,
            left: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    p1 = false;
                    p2 = true;
                    p3 = true;
                    _firLoc();
                    _controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                          CameraPosition(target: LatLng(la, lo), zoom: 9)),
                    );
                  },
                  child: Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                          color:
                              p1 ? Colors.white : Color.fromRGBO(37, 36, 39, 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.person,
                            color: p1 ? Colors.black : Colors.white,
                          ),
                          Text(
                            'Friend',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: p1 ? Colors.black : Colors.white,
                                fontSize: 16),
                          ),
                        ],
                      ))),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    p2 = false;
                    p1 = true;
                    p3 = true;
                    _nearRestpolice();
                    _controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                          CameraPosition(target: LatLng(la, lo), zoom: 16)),
                    );
                  },
                  child: Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                          color:
                              p2 ? Colors.white : Color.fromRGBO(37, 36, 39, 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.shield,
                            color: p2 ? Colors.black : Colors.white,
                          ),
                          Text(
                            'Police',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: p2 ? Colors.black : Colors.white,
                                fontSize: 16),
                          ),
                        ],
                      ))),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    p1 = true;
                    p2 = true;
                    p3 = false;
                    _nearResthospital();
                    _controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                          CameraPosition(target: LatLng(la, lo), zoom: 16)),
                    );
                  },
                  child: Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                          color:
                              p3 ? Colors.white : Color.fromRGBO(37, 36, 39, 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.local_hospital,
                            color: p3 ? Colors.black : Colors.white,
                          ),
                          Text(
                            'Hospital',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: p3 ? Colors.black : Colors.white,
                                fontSize: 16),
                          ),
                        ],
                      ))),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(37, 36, 39, 1),
          hoverColor: Colors.white,
          label: Text(
            'SOS',
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontFamily: 'SFProDisplay'),
          ),
          onPressed: () {
            _sosLoc();
            const tm = Duration(seconds: 30);
            Timer.periodic(tm, (Timer t) => _sosLoc());
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void addMarker(cordinates) async {
    print('$cordinates----+++++++');
    points.add(cordinates);
    print(points);
    await route.drawRoute(points, 'trip', Color.fromRGBO(130, 78, 210, 1.0),
        'AIzaSyA1bs9xDzhAEb5IpByX_-e0SzPW1QSXKQU',
        travelMode: TravelModes.walking);
    await Future.delayed(Duration(seconds: 2));
    //this where thre should be loading
    setState(() {
      markers.add(
        Marker(
          icon: map_marker2,
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
        ImageConfiguration(), 'images/petrol.png');

    restro_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/restro.png');
    hotel_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/hotel.png');
    hotel_marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/null.png');
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

  void _nearResthospital() async {
    var result1 = await googlePlace.search
        .getNearBySearch(Location(lat: la, lng: lo), 5000, type: "hospital");

    setState(() {
      searchResultList = result1!.results!;
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
            Alert(
              context: context,
              title: "Do you want to call " + searchResultList[i].name!,
              buttons: [
                DialogButton(
                  color: Color.fromRGBO(37, 36, 39, 1),
                  onPressed: () async {
                    var result6 = await googlePlace.details
                        .get("${searchResultList[i].placeId}");
                    await launch(
                        'tel:${result6!.result!.formattedPhoneNumber}');
                    print("${result6.result!.formattedPhoneNumber}");
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Call",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DialogButton(
                  color: Color.fromRGBO(37, 36, 39, 1),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Direction",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ).show();
          },
        ),
      );
    }
  }

  void _nearRestpolice() async {
    var result2 = await googlePlace.search
        .getNearBySearch(Location(lat: la, lng: lo), 10000, type: "police");

    setState(() {
      searchResultList2 = result2!.results!;
    });

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
            Alert(
              content: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .05),
                        blurRadius: 10.0,
                        spreadRadius: 5)
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 8, right: 8, bottom: 8),
                  child: Text('call'),
                ),
              ),
              context: context,
              title: "Do you want to call",
              buttons: [
                DialogButton(
                  color: Color.fromRGBO(37, 36, 39, 1),
                  onPressed: () async {
                    var result7 = await googlePlace.details
                        .get("${searchResultList2[i].placeId}");
                    await launch(
                        'tel:${result7!.result!.formattedPhoneNumber}');
                    print("${result7.result!.formattedPhoneNumber}");
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Call",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DialogButton(
                  color: Color.fromRGBO(37, 36, 39, 1),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No change",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ).show();
          },
        ),
      );
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<gc.Placemark> placemarks = await gc.placemarkFromCoordinates(
          _locationData.latitude!, _locationData.longitude!);

      gc.Placemark place = placemarks[0];
      place_sos = place;
      loc = place.locality;
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      FirebaseFirestore.instance
          .collection('USERS')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .update({
        'location': "${place.locality},${place.postalCode},${place.country}",
        'lat': '${_locationData.latitude}',
        'long': '${_locationData.longitude}',
        'timestamp_of_loc': DateTime.now().toString(),
        'completedReg': _isCompleted.toString(),
      });
    } catch (e) {
      print(e);
    }
  }

  _sosLoc() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == l.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != l.PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      _isGetLocation = true;
      _getAddressFromLatLng();
    });

    Stream<QuerySnapshot> snap = FirebaseFirestore.instance
        .collection("USERS")
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection("EME_FR")
        .snapshots();
    snap.forEach(
      (field) {
        field.docs.asMap().forEach(
          (index, data) {
            print(data.id);
            FirebaseFirestore.instance
                .collection('USERS')
                .doc('${data.id}')
                .collection('SOS')
                .doc('${FirebaseAuth.instance.currentUser!.uid}')
                .set(
              {
                'name': FirebaseAuth.instance.currentUser!.displayName,
                'id': FirebaseAuth.instance.currentUser!.uid,
                'timestamp_of_req': DateTime.now().toString().substring(0, 16),
                'loc_of_req':
                    "${_locationData.latitude},${_locationData.longitude}",
                'approx_loc':
                    "${place_sos.locality},${place_sos.postalCode},${place_sos.country}"
              },
            );
          },
        );
      },
    );
  }
}
