class WeatherData {
  final double currentTemp;
  final double feelsLike;
  final int weatherCode;
  final double rainProbability;
  final double humidity;
  final double windSpeed;
  final double visibility;
  final int uvIndex;
  final DateTime sunrise;
  final DateTime sunset;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherData({
    required this.currentTemp,
    required this.feelsLike,
    required this.weatherCode,
    required this.rainProbability,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.hourly,
    required this.daily,
  });
}

class HourlyWeather {
  final DateTime time;
  final double temp;
  final int weatherCode;
  final double rainProbability;
  final int uvIndex;
  final double humidity;

  HourlyWeather({
    required this.time,
    required this.temp,
    required this.weatherCode,
    required this.rainProbability,
    required this.uvIndex,
    required this.humidity,
  });
}

class DailyWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;
  final double rainProbability;
  final double windSpeed;
  final double humidity;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
    required this.rainProbability,
    required this.windSpeed,
    required this.humidity,
  });
}

class AirQualityData {
  final int aqi;
  final double pm25;
  final double pm10;
  final double co;
  final double no2;
  final double so2;
  final double o3;

  AirQualityData({
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.co,
    required this.no2,
    required this.so2,
    required this.o3,
  });

  String get aqiCategory {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Poor';
    return 'Very Poor';
  }
}

class MarineData {
  final double waveHeight;
  final double waveDirection;
  final double wavePeriod;
  final double seaSurfaceTemperature;
  final List<HourlyMarine> hourly;

  MarineData({
    required this.waveHeight,
    required this.waveDirection,
    required this.wavePeriod,
    required this.seaSurfaceTemperature,
    required this.hourly,
  });
}

class HourlyMarine {
  final DateTime time;
  final double waveHeight;
  final double waveDirection;
  final double wavePeriod;

  HourlyMarine({
    required this.time,
    required this.waveHeight,
    required this.waveDirection,
    required this.wavePeriod,
  });
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final String severity; // 'High', 'Medium', 'Low'
  final DateTime timestamp;
  final DateTime endTime;
  final String locationName;
  final List<String> protocols;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
    required this.endTime,
    required this.locationName,
    this.protocols = const [],
  });
}
