import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc_api/api/Repository.dart';
import 'package:flutter_bloc_api/model/WeatherResponse.dart';

class WeatherBloc {
  Repository _repository = Repository();

  final _weatherFetcher = PublishSubject<WeatherResponse>();

  Stream<WeatherResponse> get weather => _weatherFetcher.stream;

  fetchWeather(String city) async {
    WeatherResponse weatherResponse = await _repository.fetchWeather(city);
    _weatherFetcher.sink.add(weatherResponse);
  }

  dispose() {
    _weatherFetcher.close();
  }
}

final weatherBloc = WeatherBloc();