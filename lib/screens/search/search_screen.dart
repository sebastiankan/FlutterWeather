import 'package:flutter/material.dart';
import 'package:flutter_bloc_api/screens/home/WeatherBloc.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var cityList = ["Sanandaj", "Kermanshah", "Hamedan", "Tehran"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          leading: IconButton(
              onPressed: () => {Navigator.of(context).pop()},
              icon: Icon(Icons.close)),
        ),
        body: ListView(
            scrollDirection: Axis.vertical,
            children: cityList.map((city) {
              return TextButton(
                  onPressed: () => {
                    onItemPress(city)
                  },
                  child: Container(
                    height: 50,
                    child: Center(
                        child: Container(
                      child: Text(city),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 12, right: 12),
                    )),
                  ));
            }).toList()));
  }

  void onItemPress(String city) {
    weatherBloc.fetchWeather(city);
    Navigator.pop(context);
  }

}
