import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:san/UI/login.dart';
import 'package:san/trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:san/main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;
  var loc;
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
                  },
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Escape From Work',
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
                      'Friends',
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
                  child: Text("User Body"),
                ),
              ]),
              Positioned(
                bottom: 0,
                right: 8,
                child: IconButton(
                  icon: SvgPicture.asset('images/chat.svg'),
                  iconSize: 65,
                  onPressed: () {},
                ),
              ),
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
