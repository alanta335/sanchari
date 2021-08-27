import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewFriendsUI extends StatefulWidget {
  const ViewFriendsUI({Key? key}) : super(key: key);

  @override
  _ViewFriendsUIState createState() => _ViewFriendsUIState();
}

class _ViewFriendsUIState extends State<ViewFriendsUI> {
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
          body: ListView(
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
                          color: Color.fromRGBO(0, 0, 0, .2),
                          blurRadius: 20.0,
                        )
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
                                  child: Image(
                                    image: AssetImage('images/google.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Image(
                                    image: AssetImage('images/chat1.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
