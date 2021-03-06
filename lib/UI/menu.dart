import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:san/UI/profile.dart';
import 'package:san/UI/sosfriendui.dart';
import 'package:san/UI/viewFriendsui.dart';
import 'package:san/addfriends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:san/main.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.15),
            child: AppBar(
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  ' Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                        child: Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                    Tab(
                        child: Text(
                      'Friends',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                    Tab(
                        child: Text(
                      'SOS ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                  ]),
            )),
        body:
            TabBarView(children: [Profile(), ViewFriendsUI(), SosFriendsUI()]),
      ),
    );
  }
}
