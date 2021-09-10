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
  bool fore = false;
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

  String _icon1 = '';
  String _icon2 = '';
  String _icon3 = '';
  String _icon4 = '';
  String _icon5 = '';

  void fivedayWeather() async {
    List<Weather> forecast = await wf.fiveDayForecastByCityName(loc);
    print(forecast);
    _data = forecast;
    setState(() {
      if (_data.isNotEmpty) {
        fore = true;
        _icon1 = 'https://openweathermap.org/img/wn/' +
            _data.elementAt(0).weatherIcon! +
            '@2x.png';
        _icon2 = 'https://openweathermap.org/img/wn/' +
            _data.elementAt(1).weatherIcon! +
            '@2x.png';
        _icon3 = 'https://openweathermap.org/img/wn/' +
            _data.elementAt(2).weatherIcon! +
            '@2x.png';
        _icon4 = 'https://openweathermap.org/img/wn/' +
            _data.elementAt(3).weatherIcon! +
            '@2x.png';
        _icon5 = 'https://openweathermap.org/img/wn/' +
            _data.elementAt(4).weatherIcon! +
            '@2x.png';
        print(_icon4 = 'https://openweathermap.org/img/wn/' +
            _data.elementAt(4).weatherIcon! +
            '@2x.png');
      }
    });
  }

  Widget _buildWeatherListView(List<Weather> _data) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Container(
            child: Column(
              children: [Text('${_data.elementAt(0).temperature}')],
            ),
          ))
        ],
      ),
    );
  }

  Widget contentFinishedDownload() {
    return ListView.builder(
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

    setState(() {
      if (we == 'Rain') {
        print('dsjdiklsjdaksajdksadjksadjksajdl' + we);
        a = 7;
      } else if (we == 'Clouds') {
        a = 0;
      } else if (we == 'Clouds') {
        a = 0;
      } else if (we == 'Clouds') {
        a = 0;
      } else if (we == 'Clouds') {
        a = 0;
      } else if (we == 'Clouds') {
        a = 0;
      } else if (we == 'Clouds') {
        a = 0;
      }
    });

    return Scaffold(
        backgroundColor: Colors.white,
        body: fore
            ? SingleChildScrollView(
                child: Column(
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
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 30),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Check out the whole forecast',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
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
                              child: Icon(Icons.arrow_forward,
                                  color: Colors.white),
                            ),
                          ]),
                    ),
                    fore
                        ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(37, 36, 39, 1),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0,
                                                left: 12.0,
                                                right: 12.0),
                                            child: Text(
                                              'Day 1',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'SFProDisplay'),
                                            ),
                                          ),
                                          Image(image: NetworkImage(_icon1)),
                                          Text(
                                            '${_data.elementAt(0).temperature.toString().replaceAll('Celsius', '°')}'
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SFProDisplay'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(37, 36, 39, 1),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0,
                                                left: 12.0,
                                                right: 12.0),
                                            child: Text(
                                              'Day 2',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'SFProDisplay'),
                                            ),
                                          ),
                                          Image(image: NetworkImage(_icon2)),
                                          Text(
                                            '${_data.elementAt(1).temperature.toString().replaceAll('Celsius', '°')}'
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SFProDisplay'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(37, 36, 39, 1),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0,
                                                left: 12.0,
                                                right: 12.0),
                                            child: Text(
                                              'Day 3',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'SFProDisplay'),
                                            ),
                                          ),
                                          Image(image: NetworkImage(_icon3)),
                                          Text(
                                            '${_data.elementAt(2).temperature.toString().replaceAll('Celsius', '°')}'
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SFProDisplay'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(37, 36, 39, 1),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0,
                                                left: 12.0,
                                                right: 12.0),
                                            child: Text(
                                              'Day 4',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'SFProDisplay'),
                                            ),
                                          ),
                                          Image(image: NetworkImage(_icon4)),
                                          Text(
                                            '${_data.elementAt(3).temperature.toString().replaceAll('Celsius', '°')}'
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SFProDisplay'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(37, 36, 39, 1),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0,
                                                left: 12.0,
                                                right: 12.0),
                                            child: Text(
                                              'Day 5',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'SFProDisplay'),
                                            ),
                                          ),
                                          Image(image: NetworkImage(_icon5)),
                                          Text(
                                            '${_data.elementAt(4).temperature.toString().replaceAll('Celsius', '°')}'
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SFProDisplay'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              )));
  }
}
