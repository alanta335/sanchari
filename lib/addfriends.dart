import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: Text("Add Friends"),
      ),
      body: Container(
        child: Column(
          children: [
            Text('my id ${FirebaseAuth.instance.currentUser!.uid}'),
            Text('add friend id'),
            TextField(
              controller: addFriendIdController,
              decoration: InputDecoration(
                hintText: 'Enter your friends id',
                labelText: 'friends id',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
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
                  FirebaseFirestore.instance
                      .collection('USERS')
                      .doc('${FirebaseAuth.instance.currentUser!.uid}')
                      .collection('FRIENDS')
                      .doc('${addFriendIdController.text}')
                      .set({});
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
                      .set({});
                  setState(() {
                    addSuccess = 'add friend successfully';
                  });
                } catch (e) {}
              },
              child: Text('add as friend'),
            ),
            Text('$addSuccess'),
          ],
        ),
      ),
    );
  }
}
