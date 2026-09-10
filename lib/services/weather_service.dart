import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/user_preferences.dart';
import '../data/mock/mock_weather_data.dart';

class WeatherService {
  bool useMockData = true;

  Future<WeatherData> getWeatherData(LocationModel location) async {
    if (useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      return MockData.getMockWeatherData(location.name);
    }

    // Live API integration (Open-Meteo)
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,weather_code,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,visibility,wind_speed_10m,uv_index&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_probability_max,wind_speed_10m_max&timezone=auto');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final current = data['current'];
        final hourly = data['hourly'];
        final daily = data['daily'];

        return WeatherData(
          currentTemp: current['temperature_2m'].toDouble(),
          feelsLike: current['apparent_temperature'].toDouble(),
          weatherCode: current['weather_code'],
          rainProbability: hourly['precipitation_probability'][0].toDouble(), // using next hour
          humidity: current['relative_humidity_2m'].toDouble(),
          windSpeed: current['wind_speed_10m'].toDouble(),
          visibility: hourly['visibility'][0].toDouble() / 1000.0, // convert to km
          uvIndex: daily['uv_index_max'][0].round(),
          sunrise: DateTime.parse(daily['sunrise'][0]),
          sunset: DateTime.parse(daily['sunset'][0]),
          hourly: List.generate(24, (index) {
            return HourlyWeather(
              time: DateTime.parse(hourly['time'][index]),
              temp: hourly['temperature_2m'][index].toDouble(),
              weatherCode: hourly['weather_code'][index],
              rainProbability: hourly['precipitation_probability'][index].toDouble(),
              uvIndex: hourly['uv_index'][index].round(),
              humidity: hourly['relative_humidity_2m'][index].toDouble(),
            );
          }),
          daily: List.generate(7, (index) {
            return DailyWeather(
              date: DateTime.parse(daily['time'][index]),
              maxTemp: daily['temperature_2m_max'][index].toDouble(),
              minTemp: daily['temperature_2m_min'][index].toDouble(),
              weatherCode: daily['weather_code'][index],
              rainProbability: daily['precipitation_probability_max'][index].toDouble(),
              windSpeed: daily['wind_speed_10m_max'][index].toDouble(),
              humidity: 60.0, // Open-Meteo daily doesn't have average humidity directly without custom params
            );
          }),
        );
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return MockData.getMockWeatherData(location.name);
    }
  }

  Future<List<WeatherAlert>> getAlerts(LocationModel location) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.getMockAlerts(location);
    }
    
    // In a real scenario, this would call IMD or another alert API.
    // For now, we fallback to mock since Open-Meteo free tier doesn't have robust alerts for India.
    return MockData.getMockAlerts(location);
  }
}
