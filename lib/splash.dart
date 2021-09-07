import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:san/UI/homescreen.dart';
import 'dart:async';

class Ss extends StatefulWidget {
  @override
  _SsState createState() => _SsState();
}

class _SsState extends State<Ss> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: SvgPicture.asset('images/san.svg'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
