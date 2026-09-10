import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/user_preferences.dart';

/// Fetches ocean/sea condition data from the Open-Meteo Marine API.
/// Only meaningful for coastal locations; the API returns null values
/// for land-locked coordinates.
class MarineService {
  Future<MarineData?> getMarineData(LocationModel location) async {
    try {
      final url = Uri.parse(
          'https://marine-api.open-meteo.com/v1/marine?latitude=${location.latitude}&longitude=${location.longitude}&current=wave_height,wave_direction,wave_period,sea_surface_temperature&hourly=wave_height,wave_direction,wave_period&timezone=auto');

      final response = await http.get(url);

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);
      final current = data['current'];
      final hourly = data['hourly'];

      if (current == null || current['wave_height'] == null) {
        // Not a coastal/marine location.
        return null;
      }

      final hourlyTimes = (hourly['time'] as List<dynamic>).length;

      return MarineData(
        waveHeight: (current['wave_height'] as num).toDouble(),
        waveDirection: (current['wave_direction'] as num).toDouble(),
        wavePeriod: (current['wave_period'] as num).toDouble(),
        seaSurfaceTemperature:
            (current['sea_surface_temperature'] as num?)?.toDouble() ?? 0.0,
        hourly: List.generate(hourlyTimes.clamp(0, 24), (index) {
          return HourlyMarine(
            time: DateTime.parse(hourly['time'][index]),
            waveHeight: (hourly['wave_height'][index] as num).toDouble(),
            waveDirection: (hourly['wave_direction'][index] as num).toDouble(),
            wavePeriod: (hourly['wave_period'][index] as num).toDouble(),
          );
        }),
      );
    } catch (e) {
      return null;
    }
  }
}
