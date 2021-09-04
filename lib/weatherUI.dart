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
  List<Weather> _data = [];
  WeatherFactory wf = new WeatherFactory("f6f05e62a44e4f9ba8eb4b805ef44e74");

  Future<Weather> queryWeather() async {
    Weather w = await wf.currentWeatherByCityName(loc);
    print(w.areaName);
    return w;
  }

  void fivedayWeather() async {
    List<Weather> forecast = await wf.fiveDayForecastByCityName(loc);
    print(forecast);
    _data = forecast;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    w = queryWeather();
    fivedayWeather();
    return Scaffold(
      body: Column(
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
              children: <Widget>[
                Text(_data.first.areaName!),
                BoxedIcon(
                  WeatherIcons.cloudy,
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(50.0),
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
          )
        ],
      ),
    );
  }
}
