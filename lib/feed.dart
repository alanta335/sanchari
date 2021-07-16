import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'homepage.dart';

class Feed extends StatefulWidget {
  final data;
  Feed({@required this.data});

  @override
  _FeedState createState() => _FeedState(loc: data);
}

class _FeedState extends State<Feed> {
  var loc;

  _FeedState({@required this.loc});
  FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    print("-----------$loc---------------");
    Query tips = FirebaseFirestore.instance
        .collection('TIPS')
        .doc('${loc.toString()}')
        .collection('info');

    Query feeds = FirebaseFirestore.instance
        .collection('FEEDS')
        .doc('$loc')
        .collection('news');
    return StreamBuilder<QuerySnapshot>(
      stream: tips.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          Alert(
                  context: context,
                  closeFunction: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoggedInWidget()));
                  },
                  title: "Error!",
                  desc: "Failed to load data. Try again!")
              .show();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: SafeArea(
              child: Center(child: Text("loading")),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Visited Database'),
          ),
          body: ListView(
            addAutomaticKeepAlives: false,
            cacheExtent: 300,
            reverse: false,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Card(
                child: ListTile(
                  title: Text('----${document.get('heading')}\n'),
                  subtitle: Text('----${document.get('body')}----\n'),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
