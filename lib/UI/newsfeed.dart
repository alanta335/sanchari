import 'package:flutter/material.dart';
import 'package:san/news.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/model/source.dart';
import 'package:location/location.dart' as l;
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:san/news2.dart';

class Newsfeed extends StatefulWidget {
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  var loc;
  l.Location location = new l.Location();
  var _currentAddress;
  late bool _serviceEnabled;
  late l.PermissionStatus _permissionGranted;
  late l.LocationData _locationData;
  late Placemark place_sos;
  bool _isGetLocation = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isCompleted = false;

  Future getloc() async {
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.15),
            child: AppBar(
              elevation: 0,
              toolbarHeight: 100,
              backgroundColor: Colors.white,
              bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                        child: Text(
                      'Weather',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                    Tab(
                        child: Text(
                      'News',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                  ]),
            )),
        backgroundColor: Colors.white,
        body: TabBarView(children: [
          Text('hhjfsdkhfjsk'),
          News2(locality: 'america'),
        ]),
      ),
    );
  }
}
