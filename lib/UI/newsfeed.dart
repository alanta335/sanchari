import 'package:flutter/material.dart';
import 'package:san/news.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/model/source.dart';
import 'package:location/location.dart' as l;
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:san/news2.dart';
import 'package:san/weatherUI.dart';
import 'homescreen.dart';
import 'package:weather/weather.dart';

class Newsfeed extends StatefulWidget {
  var locality;

  Newsfeed({required this.locality});
  @override
  _NewsfeedState createState() => _NewsfeedState(loc: locality);
}

class _NewsfeedState extends State<Newsfeed> {
  var loc;
  WeatherFactory wf = new WeatherFactory("f6f05e62a44e4f9ba8eb4b805ef44e74");
  void queryWeather() async {
    Weather w = await wf.currentWeatherByCityName(loc);
    print(w.tempMax);
  }

  _NewsfeedState({required this.loc});
  final HomeScreen news = new HomeScreen();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    queryWeather();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.15),
            child: AppBar(
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
                      'Weather',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                    Tab(
                        child: Text(
                      'News',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay'),
                    )),
                  ]),
            )),
        backgroundColor: Colors.white,
        body: TabBarView(children: [
          Weatherui(locality: loc),
          News2(locality: loc),
        ]),
      ),
    );
  }
}
