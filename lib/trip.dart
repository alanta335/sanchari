import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Trip extends StatefulWidget {
  const Trip({Key? key}) : super(key: key);

  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<Trip> {
  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('TRIP')
        .orderBy('added_time', descending: false);
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
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(38.0),
            child: ListView(
              addAutomaticKeepAlives: false,
              cacheExtent: 300,
              reverse: false,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                if (document.get('name') != '') {
                  return ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      Alert(
                        context: context,
                        title: "Make changes",
                        buttons: [
                          DialogButton(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text("No change",
                                style: TextStyle(color: Colors.white)),
                          ),
                          DialogButton(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('USERS')
                                  .doc(
                                      '${FirebaseAuth.instance.currentUser!.uid}')
                                  .collection('TRIP')
                                  .doc(document.id)
                                  .update({'name': ""});
                              Navigator.pop(context);
                            },
                            child: Text("REMOVE",
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ).show();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * .85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, .2),
                              blurRadius: 10.0,
                            )
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Container(
                              child: ListTile(
                                title: Center(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_sharp,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('${document.get('name')}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
