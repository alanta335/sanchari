import 'package:flutter/material.dart';
import 'package:san/UI/viewFriendsui.dart';
import 'package:san/viewFriends.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.33),
            child: AppBar(
              backgroundColor: Color.fromRGBO(37, 36, 39, 1),
              bottom: TabBar(indicatorColor: Color.fromRGBO(0, 0, 0, 1), tabs: [
                Tab(child: Text('Friends')),
                Tab(child: Text('SOS Contacts')),
              ]),
            )),
        body: TabBarView(children: [ViewFriendsUI(), Text('blah bah')]),
      ),
    );
  }
}
