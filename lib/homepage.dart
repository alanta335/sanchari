import 'dart:async';
import 'dart:core';
import 'map.dart';
import 'sosmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:san/main.dart';
import 'package:location/location.dart' as l;
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:san/sosmessage.dart';
import 'addfriends.dart';
import 'dircontact.dart';
import 'viewFriends.dart';
import 'feed.dart';

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  var loc;
  FirebaseAuth auth = FirebaseAuth.instance;

  l.Location location = new l.Location();
  var _currentAddress;
  late bool _serviceEnabled;
  late l.PermissionStatus _permissionGranted;
  late l.LocationData _locationData;
  late Placemark place_sos;
  bool _isGetLocation = false;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("homepage"),
        actions: [
          TextButton(
            child: Text(
              "log out",
              style: TextStyle(
                color: Color(0xFFC108F0),
              ),
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.loggedout();
            },
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user.photoURL!),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
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
              },
              child: Text("get location"),
            ),
            _isGetLocation
                ? Text(
                    "location : ${_locationData.latitude}/${_locationData.longitude}")
                : Container(),
            if (_currentAddress != null) Text(_currentAddress),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFriends(),
                    ),
                  );
                },
                child: Text("add friends")),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewFriends(),
                  ),
                );
              },
              child: Text("View Friends"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DirContact(),
                    ),
                  );
                },
                child: Text("direct contact")),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Feed(data: loc),
                  ),
                );
              },
              child: Text("go to feeds"),
            ),
            ElevatedButton(
              onPressed: () async {
                _sosLoc();
                const tm = Duration(seconds: 30);
                Timer.periodic(tm, (Timer t) => _sosLoc());
              },
              child: Text("send s0s message"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SosMessage(),
                  ),
                );
              },
              child: Text("see sos message"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                        lat: _locationData.latitude,
                        long: _locationData.longitude),
                  ),
                );
              },
              child: Text("map"),
            ),
          ],
        ),
      ),
    );
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _locationData.latitude!, _locationData.longitude!);

      Placemark place = placemarks[0];
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
