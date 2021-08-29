import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:san/homepage.dart';
import 'dash.dart';
import 'frnds.dart';
import 'mappage.dart';
import 'menu.dart';
import 'newsfeed.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selected_item = 0;
  List<Widget> _widgetchoose = <Widget>[
    Home(),
    Newsfeed(),
    Map(),
    LoggedInWidget(),
    Menu()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetchoose.elementAt(_selected_item),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            bulidNavBarItem(0, 'images/dash.svg'),
            bulidNavBarItem(1, 'images/feed.svg'),
            bulidNavBarItem(2, 'images/map.svg'),
            bulidNavBarItem(3, 'images/four.svg'),
            bulidNavBarItem(4, 'images/menu.svg'),
          ],
        ),
      ),
    );
  }

  Widget bulidNavBarItem(
    int index,
    String image,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected_item = index;
        });
      },
      child: Container(
        height: 65,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Container(child: SvgPicture.asset(image)),
            ),
            Container(
              height: _selected_item == index ? 10 : 0,
              width: MediaQuery.of(context).size.width * .1,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            )
          ],
        ),
      ),
    );
  }
}
