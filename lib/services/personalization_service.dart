import '../models/user_preferences.dart';
import '../models/weather_data.dart';
import '../models/personalization_data.dart';

class PersonalizationService {
  
  PersonalizedInsight generateInsight(
    UserPreferences prefs,
    WeatherData weather,
    AirQualityData aqiData,
  ) {
    if (prefs.interests.contains('Outdoor Fitness') || prefs.activities.contains('Running')) {
      return _generateFitnessInsight(weather, aqiData);
    } else if (prefs.interests.contains('Travel')) {
      return _generateTravelInsight(weather, aqiData);
    } else if (prefs.interests.contains('Farming & Gardening')) {
      return _generateFarmingInsight(weather, aqiData);
    } else if (prefs.interests.contains('Beach & Water')) {
      return _generateBeachInsight(weather, aqiData);
    } else if (prefs.interests.contains('Health & Wellness')) {
      return _generateHealthInsight(weather, aqiData);
    }

    // Default insight
    return _generateDefaultInsight(weather, aqiData);
  }

  PersonalizedInsight _generateFitnessInsight(WeatherData weather, AirQualityData aqiData) {
    int score = _calculateFitnessScore(weather, aqiData);
    String category = score > 80 ? 'Excellent' : score > 60 ? 'Good' : score > 40 ? 'Moderate' : 'Poor';
    
    // Find best time
    DateTime? bestStart;
    DateTime? bestEnd;
    double bestTemp = 0;
    int bestAqi = 0;
    String reason = "Conditions are generally good.";

    // Simple deterministic logic: find a 2-hour window with lowest temp & lowest rain
    double minTemp = 100;
    for (int i = 0; i < weather.hourly.length - 2; i++) {
      var h = weather.hourly[i];
      if (h.temp < minTemp && h.rainProbability < 30 && h.uvIndex < 5) {
        minTemp = h.temp;
        bestStart = h.time;
        bestEnd = weather.hourly[i+2].time;
        bestTemp = h.temp;
        bestAqi = aqiData.aqi; // Simplification
      }
    }

    if (bestStart != null && bestEnd != null) {
      if (bestStart.hour < 10) {
        reason = "Cooler temperatures and lower UV exposure make this the better window for your run.";
      } else {
        reason = "This window offers the most comfortable temperature with low rain chance.";
      }
    }

    BestTimeRecommendation? bestTimeRec;
    if (bestStart != null && bestEnd != null) {
      bestTimeRec = BestTimeRecommendation(
        activity: 'Running',
        startTime: bestStart,
        endTime: bestEnd,
        temp: bestTemp,
        aqi: bestAqi,
        uvStatus: 'Low',
        reason: reason,
      );
    }

    String insightText = "Your morning looks better for outdoor activity. Temperatures rise quickly after 10 AM, while UV becomes stronger.";
    if (score < 50) {
      insightText = "Running conditions are poor right now due to high temperature and poor air quality. Consider the suggested window.";
    }

    return PersonalizedInsight(
      title: "Best time for you today",
      insightText: insightText,
      bestTime: bestTimeRec,
      activityScore: ActivityScore(score: score, category: category),
      priorityCards: [
        PriorityCard(title: 'AQI', value: '${aqiData.aqi}', subtitle: aqiData.aqiCategory, iconName: 'air'),
        PriorityCard(title: 'UV', value: '${weather.uvIndex}', subtitle: weather.uvIndex < 3 ? 'Low' : 'High', iconName: 'wb_sunny_outlined'),
        PriorityCard(title: 'Humidity', value: '${weather.humidity.round()}%', subtitle: '', iconName: 'water_drop_outlined'),
        PriorityCard(title: 'Rain', value: '${weather.rainProbability.round()}%', subtitle: '', iconName: 'umbrella_outlined'),
      ]
    );
  }

  PersonalizedInsight _generateTravelInsight(WeatherData weather, AirQualityData aqiData) {
    int score = 100;
    if (weather.rainProbability > 50) score -= 30;
    if (weather.visibility < 5) score -= 40;
    if (weather.windSpeed > 30) score -= 20;

    String category = score > 80 ? 'Excellent' : score > 60 ? 'Good' : score > 40 ? 'Moderate' : 'Poor';
    
    return PersonalizedInsight(
      title: "Good time to travel",
      insightText: score > 70 
          ? "Road conditions are clear with good visibility. No severe weather expected on your commute."
          : "Exercise caution. Reduced visibility or rain may affect your travel today.",
      bestTime: null,
      activityScore: ActivityScore(score: score, category: category),
      priorityCards: [
        PriorityCard(title: 'Rain', value: '${weather.rainProbability.round()}%', subtitle: '', iconName: 'umbrella_outlined'),
        PriorityCard(title: 'Visibility', value: '${weather.visibility} km', subtitle: '', iconName: 'visibility_outlined'),
        PriorityCard(title: 'Wind', value: '${weather.windSpeed} km/h', subtitle: '', iconName: 'air'),
        PriorityCard(title: 'Alerts', value: 'None', subtitle: '', iconName: 'warning_amber_rounded'),
      ]
    );
  }

  PersonalizedInsight _generateFarmingInsight(WeatherData weather, AirQualityData aqiData) {
    return PersonalizedInsight(
      title: "Farming & Crop Care",
      insightText: weather.rainProbability > 40 
          ? "Rain expected today. Hold off on irrigation. Soil moisture will remain high."
          : "Dry conditions today. Good window for spraying or irrigation.",
      bestTime: null,
      activityScore: ActivityScore(score: 85, category: 'Good'),
      priorityCards: [
        PriorityCard(title: 'Rain', value: '${weather.rainProbability.round()}%', subtitle: '', iconName: 'water_drop_outlined'),
        PriorityCard(title: 'Humidity', value: '${weather.humidity.round()}%', subtitle: '', iconName: 'cloud_outlined'),
        PriorityCard(title: 'Temp', value: '${weather.currentTemp.round()}°', subtitle: '', iconName: 'thermostat_outlined'),
        PriorityCard(title: 'Wind', value: '${weather.windSpeed} km/h', subtitle: '', iconName: 'air'),
      ]
    );
  }

  PersonalizedInsight _generateHealthInsight(WeatherData weather, AirQualityData aqiData) {
    return PersonalizedInsight(
      title: "Health & Wellness",
      insightText: aqiData.aqi > 100
          ? "Air quality is degraded today. Sensitive groups should limit outdoor exertion."
          : "Great conditions for general wellness and outdoor breathing.",
      bestTime: null,
      activityScore: ActivityScore(score: aqiData.aqi < 50 ? 95 : aqiData.aqi < 100 ? 75 : 40, category: aqiData.aqiCategory),
      priorityCards: [
        PriorityCard(title: 'AQI', value: '${aqiData.aqi}', subtitle: aqiData.aqiCategory, iconName: 'air'),
        PriorityCard(title: 'PM2.5', value: '${aqiData.pm25}', subtitle: 'µg/m³', iconName: 'masks_outlined'),
        PriorityCard(title: 'UV', value: '${weather.uvIndex}', subtitle: weather.uvIndex < 3 ? 'Low' : 'High', iconName: 'wb_sunny_outlined'),
        PriorityCard(title: 'Heat', value: weather.currentTemp > 35 ? 'High' : 'Moderate', subtitle: '', iconName: 'local_fire_department_outlined'),
      ]
    );
  }

  PersonalizedInsight _generateBeachInsight(WeatherData weather, AirQualityData aqiData) {
    return PersonalizedInsight(
      title: "Beach & Water",
      insightText: weather.windSpeed > 20 || weather.uvIndex > 7
          ? "High UV and strong winds today. Apply sunscreen regularly."
          : "Perfect beach weather. Mild winds and comfortable temperatures.",
      bestTime: null,
      activityScore: ActivityScore(score: 90, category: 'Excellent'),
      priorityCards: [
        PriorityCard(title: 'Wind', value: '${weather.windSpeed} km/h', subtitle: '', iconName: 'air'),
        PriorityCard(title: 'UV', value: '${weather.uvIndex}', subtitle: weather.uvIndex < 3 ? 'Low' : 'High', iconName: 'wb_sunny_outlined'),
        PriorityCard(title: 'Temp', value: '${weather.currentTemp.round()}°', subtitle: '', iconName: 'thermostat_outlined'),
        PriorityCard(title: 'Rain', value: '${weather.rainProbability.round()}%', subtitle: '', iconName: 'umbrella_outlined'),
      ]
    );
  }

  PersonalizedInsight _generateDefaultInsight(WeatherData weather, AirQualityData aqiData) {
    return PersonalizedInsight(
      title: "Daily Summary",
      insightText: "Temperatures are normal for this time of year.",
      bestTime: null,
      activityScore: ActivityScore(score: 70, category: 'Good'),
      priorityCards: [
        PriorityCard(title: 'AQI', value: '${aqiData.aqi}', subtitle: aqiData.aqiCategory, iconName: 'air'),
        PriorityCard(title: 'UV', value: '${weather.uvIndex}', subtitle: weather.uvIndex < 3 ? 'Low' : 'High', iconName: 'wb_sunny_outlined'),
        PriorityCard(title: 'Humidity', value: '${weather.humidity.round()}%', subtitle: '', iconName: 'water_drop_outlined'),
        PriorityCard(title: 'Rain', value: '${weather.rainProbability.round()}%', subtitle: '', iconName: 'umbrella_outlined'),
      ]
    );
  }

  int _calculateFitnessScore(WeatherData weather, AirQualityData aqiData) {
    double score = 100;
    
    // Temperature penalty
    if (weather.currentTemp > 32) score -= (weather.currentTemp - 32) * 5;
    if (weather.currentTemp < 10) score -= (10 - weather.currentTemp) * 3;

    // AQI penalty
    if (aqiData.aqi > 50) score -= (aqiData.aqi - 50) * 0.4;

    // UV penalty
    if (weather.uvIndex > 5) score -= (weather.uvIndex - 5) * 5;

    // Rain penalty
    if (weather.rainProbability > 20) score -= (weather.rainProbability - 20) * 0.5;

    return score.clamp(0, 100).round();
  }
}
