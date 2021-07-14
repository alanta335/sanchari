import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:san/main.dart';
import 'package:location/location.dart' as l;
import 'package:geocoding/geocoding.dart';

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  l.Location location = new l.Location();
  String _output = '-----';
  var _currentAddress;
  late bool _serviceEnabled;
  late l.PermissionStatus _permissionGranted;
  late l.LocationData _locationData;
  bool _isGetLocation = false;
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
                  child: Text("get location")),
              _isGetLocation
                  ? Text(
                      "location : ${_locationData.latitude}/${_locationData.longitude}")
                  : Container(),
              if (_currentAddress != null) Text(_currentAddress),
            ],
          )),
    );
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _locationData.latitude!, _locationData.longitude!);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
