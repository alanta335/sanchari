import 'package:flutter/material.dart';
import 'package:san/UI/viewFriendsui.dart';
import 'package:san/addfriends.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.33),
            child: AppBar(
              toolbarHeight: 300,
              title: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: Image(image: NetworkImage(user.photoURL!))),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.displayName!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'SFProDisplay'),
                  )
                ],
              ),
              centerTitle: true,
              backgroundColor: Color.fromRGBO(37, 36, 39, 1),
              bottom: TabBar(indicatorColor: Color.fromRGBO(0, 0, 0, 1), tabs: [
                Tab(
                    child: Text(
                  'Friends',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'SFProDisplay'),
                )),
                Tab(
                    child: Text(
                  'SOS Contacts',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'SFProDisplay'),
                )),
              ]),
            )),
        body: TabBarView(children: [ViewFriendsUI(), Text('blah bah')]),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(37, 36, 39, 1),
          label: Text(
            'Add Friends',
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontFamily: 'SFProDisplay'),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddFriends()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
