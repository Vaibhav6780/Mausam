import '../../models/weather_data.dart';
import '../../models/user_preferences.dart';

class MockData {
  static final Map<String, LocationModel> locations = {
    'Ghaziabad': LocationModel(name: 'Ghaziabad, Uttar Pradesh', latitude: 28.6692, longitude: 77.4538),
    'Delhi': LocationModel(name: 'New Delhi, Delhi', latitude: 28.6139, longitude: 77.2090),
    'Mumbai': LocationModel(name: 'Mumbai, Maharashtra', latitude: 19.0760, longitude: 72.8777),
    'Goa': LocationModel(name: 'Goa', latitude: 15.2993, longitude: 74.1240),
    'Bangalore': LocationModel(name: 'Bangalore, Karnataka', latitude: 12.9716, longitude: 77.5946),
    'Manali': LocationModel(name: 'Manali, Himachal Pradesh', latitude: 32.2396, longitude: 77.1887),
  };

  static WeatherData getMockWeatherData(String locationName) {
    DateTime now = DateTime.now();
    
    // Default mock data (e.g. for Ghaziabad)
    double temp = 34.0;
    double feelsLike = 38.0;
    int weatherCode = 2; // Partly Cloudy
    double rainProb = 20.0;
    double humidity = 72.0;
    double windSpeed = 12.0;
    int uv = 7;
    
    if (locationName.contains('Manali')) {
      temp = 18.0; feelsLike = 17.0; uv = 4; humidity = 40.0; weatherCode = 0;
    } else if (locationName.contains('Mumbai')) {
      temp = 31.0; feelsLike = 35.0; humidity = 85.0; rainProb = 80.0; weatherCode = 61; // Rain
    }

    return WeatherData(
      currentTemp: temp,
      feelsLike: feelsLike,
      weatherCode: weatherCode,
      rainProbability: rainProb,
      humidity: humidity,
      windSpeed: windSpeed,
      visibility: 8.0,
      uvIndex: uv,
      sunrise: DateTime(now.year, now.month, now.day, 5, 45),
      sunset: DateTime(now.year, now.month, now.day, 18, 50),
      hourly: List.generate(24, (index) {
        int hour = (now.hour + index) % 24;
        DateTime time = now.add(Duration(hours: index));
        double hTemp = temp - (hour < 6 || hour > 18 ? 4 : 0) + (hour == 14 ? 2 : 0);
        return HourlyWeather(
          time: time,
          temp: hTemp,
          weatherCode: weatherCode,
          rainProbability: rainProb,
          uvIndex: (hour > 10 && hour < 16) ? uv : 1,
          humidity: humidity,
        );
      }),
      daily: List.generate(7, (index) {
        return DailyWeather(
          date: now.add(Duration(days: index)),
          maxTemp: temp + 2,
          minTemp: temp - 6,
          weatherCode: index == 2 ? 61 : weatherCode, // Rain on 3rd day
          rainProbability: index == 2 ? 70.0 : rainProb,
          windSpeed: windSpeed,
          humidity: humidity,
        );
      }),
    );
  }

  static AirQualityData getMockAirQuality(String locationName) {
    if (locationName.contains('Manali')) {
      return AirQualityData(aqi: 35, pm25: 12, pm10: 20, co: 0.1, no2: 5, so2: 2, o3: 30);
    } else if (locationName.contains('Ghaziabad') || locationName.contains('Delhi')) {
      return AirQualityData(aqi: 156, pm25: 68, pm10: 120, co: 0.8, no2: 35, so2: 12, o3: 45);
    }
    return AirQualityData(aqi: 82, pm25: 24, pm10: 45, co: 0.4, no2: 15, so2: 5, o3: 35);
  }

  static List<WeatherAlert> getMockAlerts(LocationModel location) {
    List<WeatherAlert> alerts = [];
    if (location.name.toLowerCase().contains('delhi') || location.name.toLowerCase().contains('ghaziabad')) {
      alerts.add(
        WeatherAlert(
          id: '1',
          title: 'Heavy Rainfall & Thunderstorm Warning',
          description: 'Convective cloud bands developing along the Yamuna basin. Expect rapid accumulation of 35-50mm rainfall accompanied by surface winds reaching 40-50 kmph.',
          severity: 'High',
          timestamp: DateTime.now().add(const Duration(hours: 1)), // 6:00 PM mock
          endTime: DateTime.now().add(const Duration(hours: 4, minutes: 30)), // 9:30 PM mock
          locationName: 'Ghaziabad, Noida & East Delhi NCR',
          protocols: [
            'Avoid waterlogged underpasses along NH-24 and Mohan Nagar interchange.',
            'Secure loose balcony furniture, terrace tin sheds, and solar fixtures.',
            'Commuters advised to wrap evening travel and head indoors prior to 6:30 PM.'
          ],
        ),
      );
    } else {
      alerts.add(
        WeatherAlert(
          id: '2',
          title: 'Heat Wave Advisory',
          description: 'Temperatures expected to exceed 40°C. Stay hydrated.',
          severity: 'Medium',
          timestamp: DateTime.now(),
          endTime: DateTime.now().add(const Duration(days: 1)),
          locationName: location.name,
          protocols: [
            'Drink plenty of fluids, even if not thirsty.',
            'Avoid strenuous activities during peak heat hours.',
          ],
        ),
      );
    }
    return alerts;
  }
}
