import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewFriends extends StatefulWidget {
  const ViewFriends({Key? key}) : super(key: key);

  @override
  _ViewFriendsState createState() => _ViewFriendsState();
}

class _ViewFriendsState extends State<ViewFriends> {
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
          appBar: AppBar(
            title: Text('Friend list'),
          ),
          body: ListView(
            addAutomaticKeepAlives: false,
            cacheExtent: 300,
            reverse: false,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              if (document.id == "NO_OF_FRIENDS") {
                return Card(
                  child: ListTile(
                    title: Text('NO OF FRIENDS: ${document.get('no')}'),
                  ),
                );
              }
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
                    title: "ADD to emergency contact list?",
                    buttons: [
                      DialogButton(
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('USERS')
                              .doc('${FirebaseAuth.instance.currentUser!.uid}')
                              .collection('EME_FR')
                              .doc('${document.id}')
                              .set({});
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                      DialogButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      )
                    ],
                  ).show();
                },
                child: Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text('${document.get('name')}'),
                      subtitle: Text(
                          'Phone Number:${document.get('ph_no')} \nEmail: ${document.get('email')}'),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
