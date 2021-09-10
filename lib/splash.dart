import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:san/UI/homescreen.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:location/location.dart' as l;
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ss extends StatefulWidget {
  @override
  _SsState createState() => _SsState();
}

class _SsState extends State<Ss> {
  var loc;
  late l.LocationData _locationData;

  FirebaseAuth auth = FirebaseAuth.instance;
  l.Location location = new l.Location();
  var _currentAddress;
  late bool _serviceEnabled;
  late l.PermissionStatus _permissionGranted;

  late Placemark place_sos;
  bool _isGetLocation = false;
  bool _isCompleted = false;
  int _selected_item = 0;
  double latt = 0;
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(locality: loc))));
    for (int x = 0; x < 2; x++) {
      _getLoc();
      print('$loc*&&&&&&&&');
    }
    print('$loc++++++______+_+_+_+_');
  }

  late Placemark place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 8,
              child: SvgPicture.asset('images/san1.svg'),
            ),
          ],
        ),
      ),
    );
  }

  _getLoc() async {
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
    setState(() async {
      _locationData = await location.getLocation();

      la = _locationData.latitude!;
      lo = _locationData.longitude!;
      _isGetLocation = true;
      _getAddressFromLatLng();
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _locationData.latitude!, _locationData.longitude!);

      setState(() {
        place = placemarks[0];
        place_sos = place;
        loc = place.locality;
        print('$loc*************');
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
}
