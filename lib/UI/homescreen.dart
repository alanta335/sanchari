import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:san/homepage.dart';
import 'package:san/news.dart';
import 'package:san/news2.dart';
import 'dash.dart';
import 'dart:async';
import 'dart:core';
import 'mappage.dart';
import 'menu.dart';
import 'newsfeed.dart';
import 'package:location/location.dart' as l;
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var loc;

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  l.Location location = new l.Location();
  var _currentAddress;
  late bool _serviceEnabled;
  late l.PermissionStatus _permissionGranted;
  late l.LocationData _locationData;
  late Placemark place_sos;
  bool _isGetLocation = false;
  bool _isCompleted = false;
  int _selected_item = 0;
  List<Widget> _widgetchoose = <Widget>[
    Home(),
    Newsfeed(locality: loc),
    Map(),
    LoggedInWidget(),
    Menu()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetchoose.elementAt(_selected_item),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            bulidNavBarItem(0, 'images/dash.svg'),
            bulidNavBarItem(1, 'images/feed.svg'),
            bulidNavBarItem(2, 'images/map.svg'),
            bulidNavBarItem(3, 'images/four.svg'),
            bulidNavBarItem(4, 'images/menu.svg'),
          ],
        ),
      ),
    );
  }

  Widget bulidNavBarItem(
    int index,
    String image,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          for (int i = 0; i <= 1; i++) {
            _getLoc();
          }
          if (_selected_item == 1) {}
          _selected_item = index;
        });
      },
      child: Container(
        height: 65,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Container(child: SvgPicture.asset(image)),
            ),
            Container(
              height: _selected_item == index ? 10 : 0,
              width: MediaQuery.of(context).size.width * .1,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            )
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
    _locationData = await location.getLocation();
    setState(() {
      _isGetLocation = true;
      _getAddressFromLatLng();
    });
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
