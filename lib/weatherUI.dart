import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

var loc;
var w;

class Weatherui extends StatefulWidget {
  var locality;

  Weatherui({required this.locality});
  @override
  _WeatheruiState createState() => _WeatheruiState(loc: locality);
}

class _WeatheruiState extends State<Weatherui> {
  _WeatheruiState({required this.loc});
  var loc;
  String area = '';
  String temp = '';
  String we = '';

  String icon = '';
  String weather = '';
  List<Widget> _widgetchoose = <Widget>[
    BoxedIcon(
      WeatherIcons.cloud,
      color: Color.fromRGBO(255, 255, 255, 1), //scattered clouds few clouds
      size: 65,
    ),
    BoxedIcon(
      WeatherIcons.snowflake_cold,
      color: Color.fromRGBO(255, 255, 255, 1), //snow
      size: 65,
    ),
    BoxedIcon(
      WeatherIcons.fog,
      color: Color.fromRGBO(255, 255, 255, 1), //mist
      size: 65,
    ),
    BoxedIcon(
      WeatherIcons.day_sunny,
      color: Color.fromRGBO(255, 255, 255, 1), //claerday
      size: 65,
    ),
    BoxedIcon(
      WeatherIcons.thunderstorm,
      color: Color.fromRGBO(255, 255, 255, 1), //thundestorm
      size: 65,
    ),
    BoxedIcon(
      WeatherIcons.night_clear,
      color: Color.fromRGBO(255, 255, 255, 1), //night claer
      size: 65,
    ),
    BoxedIcon(
      WeatherIcons.showers,
      color: Color.fromRGBO(255, 255, 255, 1), //rain shower
      size: 65,
    ),
    BoxedIcon(
      WeatherIcons.rain,
      color: Color.fromRGBO(255, 255, 255, 1), //rain
      size: 65,
    ),
  ];
  int a = 3;
  List<Weather> _data = [];
  WeatherFactory wf = new WeatherFactory("f6f05e62a44e4f9ba8eb4b805ef44e74");
  bool isget = false;
  void queryWeather() async {
    Weather w = await wf.currentWeatherByCityName(loc);
    print(w.areaName);
    setState(() {
      area = w.areaName!;
      temp = w.tempMax.toString();
      we = w.weatherMain!;
      print(we);
    });
  }

  void fivedayWeather() async {
    List<Weather> forecast = await wf.fiveDayForecastByCityName(loc);
    print(forecast);
    _data = forecast;
    print(_data.elementAt(1).areaName);
  }

  Widget contentFinishedDownload() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _data.length,
      itemBuilder: (context, index) {
        return Container(child: Text(_data[index].areaName!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (area == '') {
      queryWeather();
      fivedayWeather();
    } else {
      bool isget = true;
    }

    if (we == 'Rain') {
      print('dsjdiklsjdaksajdksadjksadjksajdl' + we);
      a = 7;
    } else if (we == 'Clouds') {
      a = 0;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(37, 36, 39, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: width * .8,
                height: height * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: _widgetchoose.elementAt(a),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            area,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SFProDisplay',
                                fontSize: 20),
                          ),
                          Text(
                            temp,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SFProDisplay',
                                fontSize: 25),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Check out the whole forecast',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(37, 36, 39, 1),
                      ),
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ]),
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Trip Forecast',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SFProDisplay',
                      fontSize: 22),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: width * .7,
              height: 120,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Avg Temp'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Days Precipitation'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Sunny days'),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('26°'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('1'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('4'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, .1),
                    blurRadius: 20.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
