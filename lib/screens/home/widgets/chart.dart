import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';
import 'package:flutter_bloc_api/theme.dart';

LineChartData ChartView(WeatherResponse weather) {
  WeatherResponse _weather = weather;
  var day = _weather.forecast.forecastday.first;

  List<Color> gradientColors = [
    AppTheme.blueColor,
    // Colors.white,
  ];

  return LineChartData(
    lineTouchData: LineTouchData(
        touchTooltipData:
            LineTouchTooltipData(tooltipBgColor: AppTheme.GlassyColor)),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '1:00 AM';
            case 12:
              return '12:00 PM';
            case 23:
              return '11:00 PM';
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
          if (value.toInt() == day.day.mintempC.toInt()) {
            return value.toInt().toString() + "°";
          } else if (value.toInt() == day.day.maxtempC) {
            return value.toInt().toString() + "°";
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 0)),
    minX: 0,
    maxX: 23,
    minY: day.day.mintempC.toInt().toDouble(),
    maxY: (day.day.maxtempC + 1).toInt().toDouble(),
    lineBarsData: [
      LineChartBarData(
        spots: getSpotList(_weather.forecast.forecastday.first),
        isCurved: true,
        colors: [Colors.white],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}

List<FlSpot> getSpotList(Forecastday day) {
  List<FlSpot> spots = [];
  for (var i = 0; i < day.hour.length; i++) {
    spots.add(FlSpot(i.toDouble(), day.hour[i].tempC));
  }
  return spots;
}
