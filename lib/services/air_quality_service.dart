import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/user_preferences.dart';
import '../data/mock/mock_weather_data.dart';

class AirQualityService {
  bool useMockData = false;

  Future<AirQualityData> getAirQuality(LocationModel location) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      return MockData.getMockAirQuality(location.name);
    }

    try {
      final url = Uri.parse(
          'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=${location.latitude}&longitude=${location.longitude}&current=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone,uv_index&timezone=auto');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];

        // Calculate a basic AQI for demonstration purposes based on PM2.5
        // (A real implementation would use proper EPA formulas)
        double pm25 = current['pm2_5'].toDouble();
        int calculatedAqi = (pm25 * 3).round(); // simplified mapping

        return AirQualityData(
          aqi: calculatedAqi,
          pm25: pm25,
          pm10: current['pm10'].toDouble(),
          co: current['carbon_monoxide'].toDouble(),
          no2: current['nitrogen_dioxide'].toDouble(),
          so2: current['sulphur_dioxide'].toDouble(),
          o3: current['ozone'].toDouble(),
        );
      } else {
        throw Exception('Failed to load air quality data');
      }
    } catch (e) {
      return MockData.getMockAirQuality(location.name);
    }
  }
}
