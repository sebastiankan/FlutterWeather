import 'package:flutter_bloc_api/api/APIProvider.dart';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<WeatherResponse> fetchWeather(String cityName) => appApiProvider.fetchWeather(cityName);
}