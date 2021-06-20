import 'package:flutter/material.dart';
import 'package:flutter_bloc_api/Theme.dart';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';
import 'package:flutter_bloc_api/utility/utilitiy.dart';
import 'package:intl/intl.dart';

class HourlyList extends StatelessWidget {
  const HourlyList({
    Key? key,
    required this.weather,
    required this.hourlyItemWidth,
  }) : super(key: key);

  final WeatherResponse? weather;
  final double hourlyItemWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: weather == null
            ? []
            : weather!.forecast.forecastday.first.hour.map((hour) {
                return Container(
                  width: hourlyItemWidth,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: AppTheme.GlassyColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                        Container(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                        DateFormat('HH:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                hour.timeEpoch * 1000)),
                                        textAlign: TextAlign.center),
                                  ),
                                  Spacer(),
                                  Image.asset(Utility.getAsset(
                                      weather!.current.isDay,
                                      hour.condition.icon)),
                                  Spacer(),
                                  Text(hour.tempC.toString() + "°")
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  padding: EdgeInsets.only(right: 6, left: 6),
                );
              }).toList(),
      ),
      height: 130,
    );
  }
}