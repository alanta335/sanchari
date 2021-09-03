import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

var loc;

class Weatherui extends StatefulWidget {
  var locality;

  Weatherui({required this.locality});
  @override
  _WeatheruiState createState() => _WeatheruiState(loc: locality);
}

class _WeatheruiState extends State<Weatherui> {
  var loc;
  WeatherFactory wf = new WeatherFactory("f6f05e62a44e4f9ba8eb4b805ef44e74");
  void queryWeather() async {
    Weather w = await wf.currentWeatherByCityName(loc);
    print(w.tempMax);
  }

  void fivedayWeather() async {
    List<Weather> forecast = await wf.fiveDayForecastByCityName(loc);
  }

  _WeatheruiState({required this.loc});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    queryWeather();
    fivedayWeather();
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
