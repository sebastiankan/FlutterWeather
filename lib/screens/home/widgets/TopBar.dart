import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';
import 'package:flutter_bloc_api/screens/search/search_screen.dart';


class TopBar extends StatelessWidget {
  const TopBar({
    Key? key,
    required this.weather,
  }) : super(key: key);

  final WeatherResponse? weather;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(children: [
          IconButton(
            onPressed: ()=> {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> SearchScreen(), fullscreenDialog: true))
            }, 
            icon: Icon(Icons.search, color: Colors.white,)
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,),
        Row(children: [
          Text(weather == null ? "Somthing went wrong" : weather!.location.name, 
          style: TextStyle(color: Colors.white),
        ),
        Padding(padding: EdgeInsets.only(top: 32))
        ],
        mainAxisAlignment: MainAxisAlignment.center,)
      ]
    );
  }
}