import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_api/Theme.dart';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';
import 'package:flutter_bloc_api/screens/home/WeatherBloc.dart';
import 'package:flutter_bloc_api/screens/home/widgets/TopBar.dart';
import 'package:flutter_bloc_api/screens/home/widgets/backgroundImage.dart';
import 'package:flutter_bloc_api/screens/home/widgets/chart.dart';
import 'package:flutter_bloc_api/screens/home/widgets/dailyList.dart';
import 'package:flutter_bloc_api/screens/search/search_screen.dart';
import 'package:flutter_bloc_api/utility/utilitiy.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    weatherBloc.fetchWeather("Sanandaj");
    var screenSize = MediaQuery.of(context).size;
    String backgroundImage = "lib/res/bluesky.png";
    double hourlyItemWidth = 120;

    return StreamBuilder(
        stream: weatherBloc.weather,
        builder: (context, AsyncSnapshot<WeatherResponse> snapshot) {
          if (snapshot.hasData) {
            WeatherResponse? weather = snapshot.data;
            return Container(
              child: Stack(
                children: [
                  /// Mark - Background image
                  BackgroundImage(
                      backgroundImage: backgroundImage, screenSize: screenSize),

                  /// Mark - Body
                  SafeArea(
                    child: Column(
                      children: [
                        TopBar(weather: weather),
                        Column(
                          children: [
                            /// Current temp text
                            Text(
                                weather == null
                                    ? "?"
                                    : weather.current.tempC.toString() + "°",
                                style: TextStyle(
                                  fontSize: 24,
                                )),

                            /// Condition image
                            weather == null
                                ? Text("cant load image")
                                : Image.asset(Utility.getAsset(
                                    weather.current.isDay,
                                    weather.current.condition.icon)),

                            /// Condition text
                            Text(weather == null
                                ? "Weather condition"
                                : weather.current.condition.text),
                            Padding(padding: EdgeInsets.only(top: 50)),

                            /// Hourly temp (horizontal list)
                            HourlyList(
                                weather: weather,
                                hourlyItemWidth: hourlyItemWidth),
                            Container(
                              height: 12,
                            ),
                            Container(
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: weather!.forecast.forecastday
                                    .map((forecastDay) {
                                  return Container(
                                    width: screenSize.width,
                                    color: AppTheme.GlassyColor,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                        ),
                                        Container(
                                          child: Text(
                                            Utility.dateFormat(
                                                forecastDay.dateEpoch),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                height: 2.5, fontSize: 14),
                                          ),
                                          height: 14 * 2.5,
                                        ),
                                        Spacer(),
                                        Image.asset(
                                            Utility.getAsset(
                                                weather.current.isDay,
                                                forecastDay.day.condition.icon),
                                            height: 14 * 2.5),
                                        Spacer(),
                                        Text(
                                          forecastDay.day.maxtempC.toString(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Spacer(),
                                        Text(
                                          forecastDay.day.mintempC.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                        ),
                                        Container(
                                          width: 12,
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              width: screenSize.width,
                              height: weather.forecast.forecastday.length *
                                  14 *
                                  2.5,
                            ),
                            Container(height: 32,),
                            Container(
                              width: screenSize.width - 40,
                              alignment: Alignment.center,
                              child: Stack(children: <Widget>[
                                AspectRatio(
                                  aspectRatio: 1.70,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(18),
                                        ),
                                        color: Colors.transparent),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 18.0,
                                          left: 12.0,
                                          top: 24,
                                          bottom: 12),
                                      child: LineChart(
                                        ChartView(weather),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              width: screenSize.width,
              height: screenSize.height,
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
