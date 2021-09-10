import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String Username = '';

  String Phonenumber = '';
  String email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Username',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
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
                child: TextFormField(
                  style: TextStyle(
                    color: Color.fromRGBO(148, 153, 162, 1),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Username',
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(148, 153, 162, 1),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      Username = val;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Phonenumber',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: 'SFProDisplay'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Color.fromRGBO(148, 153, 162, 1),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Username',
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(148, 153, 162, 1),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      Phonenumber = val;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * .4,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(37, 36, 39, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SFProDisplay'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: GestureDetector(
                child: Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * .4,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.loggedout();
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'SFProDisplay'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'V 0.1',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'SFProDisplay'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: GestureDetector(
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * .4,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(37, 36, 39, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SFProDisplay'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
