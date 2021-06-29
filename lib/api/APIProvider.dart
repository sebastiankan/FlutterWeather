import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';

class ApiProvider {
  Client client = Client();
  final _baseUrl =
      "https://api.weatherapi.com/v1/";
  final _forcast = "forecast.json";

  Future<WeatherResponse> fetchWeather(String cityName) async {
    Map<String, String> jsonMap = {
      'key':'06a7c8c3b527432fb1142703213105',
      'q': cityName,
      'days':'7',
      'api':'no',
      'alerts':'no'
    };

    Uri uri = Uri.parse("$_baseUrl + $_forcast");

    final response = await client.post(uri, body: jsonMap); 
    print(response.body.toString());

    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}