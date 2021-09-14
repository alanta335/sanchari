import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          floatingActionButton: FloatingActionButton(
              child: Text('stop sos'),
              foregroundColor: Color.fromRGBO(0, 0, 0, 1.0),
              onPressed: () async {
                var _collectionRef = FirebaseFirestore.instance
                    .collection('USERS')
                    .doc('${FirebaseAuth.instance.currentUser!.uid}')
                    .collection('SOS');
                _collectionRef.snapshots().forEach((element) {
                  for (QueryDocumentSnapshot snapshot in element.docs) {
                    snapshot.reference.delete();
                  }
                });
              }),
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
              child: AppBar(
                iconTheme: IconThemeData(
                  color: Color.fromRGBO(37, 36, 39, 1),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'SOS Messages',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                elevation: 0,
                toolbarHeight: 100,
                backgroundColor: Colors.white,
              )),
          body: Stack(children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SvgPicture.asset('images/san.svg'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  print('${document.data().toString()}');
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, .2),
                            blurRadius: 10.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  '${document.get('name')}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  'Current Location : ${document.get('approx_loc')}\nAccurate Location: ${document.get('loc_of_req')}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: 'SFProDisplay',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  'Time of SOS Call:${document.get('timestamp_of_req')}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'SFProDisplay',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text('')),
                    ),
                  );
                }).toList(),
              ),
            ),
          ]),
        );
      },
    );
  }
}
