import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SosMessage extends StatefulWidget {
  const SosMessage({Key? key}) : super(key: key);

  @override
  _SosMessageState createState() => _SosMessageState();
}

class _SosMessageState extends State<SosMessage> {
  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('SOS')
        .orderBy('timestamp_of_req', descending: true);
    print(users.toString());
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                  child: Text('error loading snapshots...${snapshot.error}')),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: SafeArea(
              child: Center(child: Text('loading...')),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('SOS Messages'),
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              print('${document.data().toString()}');
              return Card(
                child: ListTile(
                  title: Text('${document.get('name')}'),
                  subtitle: Text(
                      'Current Location : ${document.get('approx_loc')}\nAccurate Location: ${document.get('loc_of_req')}'),
                  trailing: Text(
                      'Time of SOS Call:${document.get('timestamp_of_req')}'),
                  isThreeLine: true,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
