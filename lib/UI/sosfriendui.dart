import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:san/addfriends.dart';
import 'package:clipboard/clipboard.dart';

class SosFriendsUI extends StatefulWidget {
  const SosFriendsUI({Key? key}) : super(key: key);

  @override
  _SosFriendsUIState createState() => _SosFriendsUIState();
}

class _SosFriendsUIState extends State<SosFriendsUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('EME_FR');
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("Erroor fetching");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Text("Waiting to get data...."),
              ),
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              ListView(
                addAutomaticKeepAlives: false,
                cacheExtent: 300,
                reverse: false,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () {},
                    onLongPress: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10, bottom: 10),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .05),
                                blurRadius: 10.0,
                                spreadRadius: 5)
                          ],
                        ),
                        child: Center(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.person,
                                          size: 25,
                                          color: Color.fromRGBO(37, 36, 39, 1),
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '${document.get('name')}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SFProDisplay'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
