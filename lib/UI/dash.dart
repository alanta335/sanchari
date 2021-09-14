import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:san/UI/login.dart';
import 'package:san/UI/tripfriends.dart';
import 'package:san/trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:san/main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

var x = 'Ready for your trip';

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;
  var loc;

  TextEditingController tripnameController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.15),
            child: AppBar(
              actions: [
                IconButton(
                  icon: SvgPicture.asset('images/Edit.svg'),
                  iconSize: 25,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                    Alert(
                      content: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .05),
                                blurRadius: 10.0,
                                spreadRadius: 5)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 8, right: 8, bottom: 8),
                          child: TextFormField(
                            controller: tripnameController,
                            style: TextStyle(
                              color: Color.fromRGBO(148, 153, 162, 1),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Trip name',
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(148, 153, 162, 1),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      context: context,
                      title: "Change trip name",
                      buttons: [
                        DialogButton(
                          color: Color.fromRGBO(37, 36, 39, 1),
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection('USERS')
                                .doc(
                                    '${FirebaseAuth.instance.currentUser!.uid}')
                                .collection('PLAN')
                                .doc('${tripnameController.text}')
                                .collection('personName')
                                .doc(
                                    '${FirebaseAuth.instance.currentUser!.uid}')
                                .set({
                              'name': FirebaseAuth
                                  .instance.currentUser!.displayName,
                            });
                            setState(() {
                              x = tripnameController.text;
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            "change",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DialogButton(
                          color: Color.fromRGBO(37, 36, 39, 1),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "no change",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ).show();
                  },
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '$x',
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
              bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                        child: Text(
                      'Location',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                    Tab(
                        child: Text(
                      'friends',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                  ]),
            )),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
              ),
              Positioned(
                bottom: height * -.078,
                right: 0,
                child: Container(
                  width: width * .35,
                  height: height * .75,
                  child: SvgPicture.asset('images/san.svg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
              TabBarView(children: [
                Trip(),
                Container(
                  child: TripFriendsUI(),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _tabSection(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: TabBar(
                indicatorColor: Color.fromRGBO(0, 0, 0, 1),
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: Text(
                      'Location',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'SFProDisplay'),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Friends',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'SFProDisplay'),
                    ),
                  ),
                ]),
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            child: Text(''),
          ),
        ),
      ],
    ),
  );
}
