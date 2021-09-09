import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({Key? key}) : super(key: key);

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  var addSuccess = "";
  DocumentSnapshot? noOfFriends;
  TextEditingController addFriendIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Add Friends",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'SFProDisplay-Regular'))),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: FirebaseAuth.instance.currentUser!.uid));
                },
                icon: Icon(Icons.copy)),
            Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'my id ${FirebaseAuth.instance.currentUser!.uid}',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProDisplay-Regular'),
                  ),
                )),
            SizedBox(height: 10),
            Text(
              'Add Friend\'s id',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'SFProDisplay-Regular'),
            ),
            SizedBox(height: 10),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, .2),
                    blurRadius: 20.0,
                  )
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: addFriendIdController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromRGBO(148, 153, 162, 1),
                      ),
                      hintText: 'Friends Id',
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(148, 153, 162, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  noOfFriends = await FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${FirebaseAuth.instance.currentUser!.uid}')
                      .collection('FRIENDS')
                      .doc('NO_OF_FRIENDS')
                      .get();
                  int i = noOfFriends!['no'];
                  i++;
                  FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${FirebaseAuth.instance.currentUser!.uid}')
                      .collection('FRIENDS')
                      .doc('NO_OF_FRIENDS')
                      .update({'no': i});
                  DocumentSnapshot user = await FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${addFriendIdController.text}')
                      .get();
                  FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${FirebaseAuth.instance.currentUser!.uid}')
                      .collection('FRIENDS')
                      .doc('${addFriendIdController.text}')
                      .set({
                    'un_id': user['userId'],
                    'name': user['name'],
                    'email': user['email'],
                    'ph_no': "",
                  });
                  noOfFriends = await FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${addFriendIdController.text}')
                      .collection('FRIENDS')
                      .doc('NO_OF_FRIENDS')
                      .get();
                  i = noOfFriends!['no'];
                  i++;
                  FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${addFriendIdController.text}')
                      .collection('FRIENDS')
                      .doc('NO_OF_FRIENDS')
                      .update({'no': i});
                  FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${addFriendIdController.text}')
                      .collection('FRIENDS')
                      .doc('${FirebaseAuth.instance.currentUser!.uid}')
                      .set({
                    'un_id': FirebaseAuth.instance.currentUser!.uid,
                    'name': FirebaseAuth.instance.currentUser!.displayName,
                    'email': FirebaseAuth.instance.currentUser!.email,
                    'ph_no': ""
                  });
                  setState(() {
                    addSuccess = 'Added friend successfully';
                  });
                } catch (e) {}
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Add as friend',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SFProDisplay-Regular'),
                    ),
                  )),
            ),
            Text('$addSuccess'),
          ],
        ),
      ),
    );
  }
}
