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
                return ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {},
                  onLongPress: () {
                    Alert(
                      context: context,
                      title: "Make changes",
                      buttons: [
                        DialogButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text("EDIT"),
                        ),
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("REMOVE"),
                        )
                      ],
                    ).show();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .85,
                    color: Colors.white,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 25),
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
                          subtitle: Text('\n'),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
