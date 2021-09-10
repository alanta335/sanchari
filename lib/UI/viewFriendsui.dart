import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:san/UI/dash.dart';
import 'package:san/addfriends.dart';
import 'package:clipboard/clipboard.dart';

class ViewFriendsUI extends StatefulWidget {
  const ViewFriendsUI({Key? key}) : super(key: key);

  @override
  _ViewFriendsUIState createState() => _ViewFriendsUIState();
}

class _ViewFriendsUIState extends State<ViewFriendsUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('FRIENDS');
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
                  if (document.id == "NO_OF_FRIENDS") {
                    return Card();
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () {},
                    onLongPress: () {
                      Alert(
                        context: context,
                        title: "",
                        buttons: [],
                        content: Container(
                          child: Column(
                            children: [
                              Text(
                                'ADD TO TRIP : $x',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              DialogButton(
                                color: Color.fromRGBO(37, 36, 39, 1),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('USERS')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.uid}')
                                      .collection('PLAN')
                                      .doc('$x')
                                      .collection('personName')
                                      .doc('${document.id}')
                                      .set({
                                    'name': document.get('name'),
                                  });
                                  FirebaseFirestore.instance
                                      .collection('USERS')
                                      .doc('${document.id}')
                                      .collection('PLAN')
                                      .doc('$x')
                                      .collection('personName')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.uid}')
                                      .set({
                                    'name': FirebaseAuth
                                        .instance.currentUser!.displayName,
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              DialogButton(
                                color: Color.fromRGBO(37, 36, 39, 1),
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                'ADD to emergency contact list?',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              DialogButton(
                                color: Color.fromRGBO(37, 36, 39, 1),
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('USERS')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.uid}')
                                      .collection('EME_FR')
                                      .doc('${document.id}')
                                      .set({
                                    'name': document.get('name'),
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DialogButton(
                                color: Color.fromRGBO(37, 36, 39, 1),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ).show();
                    },
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
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromRGBO(37, 36, 39, 1),
            label: Text(
              'Add Friends',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'SFProDisplay'),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddFriends()));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
        ClipboardData(text: FirebaseAuth.instance.currentUser!.uid));
  }
}
