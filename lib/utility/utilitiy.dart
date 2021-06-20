import 'dart:core';
import 'dart:ui';
import 'package:intl/intl.dart';

class Utility {
  static String getAsset(int isDay, String icon) {
    String dayNightString = isDay == 1 ? "day" : "night";
    String iconName = icon.split("/").last;
    return "lib/res/icon/" + dayNightString + "/" + iconName;
  }

  static Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      color = "0xFF" + color;
    } else if (color.length == 8) {
      color = "0x" + color;
    }
    return Color(int.parse(color));
  }

  static String dateFormat(int timeStamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    int currentMon = date.month;
    String monthName = Utility.months[currentMon - 1];
    return monthName + '-' + DateFormat('dd-yyyy').format(date);
  }

  static const List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
}
