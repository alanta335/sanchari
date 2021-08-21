import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:san/main.dart';
import 'package:location/location.dart' as l;
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addfriends.dart';
import 'ViewFriends.dart';
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFriends()));
                },
                child: Text("add friends")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewFriends()));
                },
                child: Text("View Friends")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Feed(data: loc)));
                },
                child: Text("go to feeds")),
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
}
