import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_api/Theme.dart';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';
import 'package:flutter_bloc_api/screens/home/WeatherBloc.dart';
import 'package:flutter_bloc_api/screens/home/widgets/TopBar.dart';
import 'package:flutter_bloc_api/screens/home/widgets/backgroundImage.dart';
import 'package:flutter_bloc_api/screens/home/widgets/dailyList.dart';
import 'package:flutter_bloc_api/utility/utilitiy.dart';
import 'package:intl/intl.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    weatherBloc.fetchLondonWeather();
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


Container(
  height: 200,
  child:   Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                child: LineChart(
                  mainData(weather),
                ),
              ),
            ),
          ),
        ]
  ),
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

    List<Color> gradientColors = [
    AppTheme.blueColor,
    // Colors.white,
  ];

  LineChartData mainData(WeatherResponse weather) {
    WeatherResponse _weather = weather;

    double getLowestTemp(List<Forecastday> forecastDays) {
      double lowestTemp = 100;
      for (var forecastDay in forecastDays) {
        if (forecastDay.day.mintempC < lowestTemp) {
          lowestTemp = forecastDay.day.mintempC;
        }
      }
      return lowestTemp;
    }

    double getHighestTemp(List<Forecastday> forecastDays) {
      double highTemp = -100;
      for (var forecastDay in forecastDays) {
        if (forecastDay.day.mintempC > highTemp) {
          highTemp = forecastDay.day.maxtempC;
        }
      }
      return highTemp;
    }

    double getAverageTemp(List<Forecastday> forecastDays) {
      double min = getLowestTemp(forecastDays);
      double max = getHighestTemp(forecastDays);
      return min + max / 2;
    }

    return LineChartData(
      lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(tooltipBgColor: AppTheme.GlassyColor)),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'Mar';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return (getLowestTemp(_weather.forecast.forecastday) - 2).toString() + "°";
              case 3:
                return getAverageTemp(_weather.forecast.forecastday).toString() + "°";
              case 5:
                return getHighestTemp(_weather.forecast.forecastday).toString() + "°";
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 0)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ] ,
          isCurved: true,
          colors: [Colors.white],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}


