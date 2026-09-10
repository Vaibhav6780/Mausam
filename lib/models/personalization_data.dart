class PersonalizedInsight {
  final String title;
  final String insightText;
  final BestTimeRecommendation? bestTime;
  final ActivityScore activityScore;
  final List<PriorityCard> priorityCards;

  PersonalizedInsight({
    required this.title,
    required this.insightText,
    this.bestTime,
    required this.activityScore,
    required this.priorityCards,
  });
}

class BestTimeRecommendation {
  final String activity;
  final DateTime startTime;
  final DateTime endTime;
  final double temp;
  final int aqi;
  final String uvStatus;
  final String reason;

  BestTimeRecommendation({
    required this.activity,
    required this.startTime,
    required this.endTime,
    required this.temp,
    required this.aqi,
    required this.uvStatus,
    required this.reason,
  });
}

class ActivityScore {
  final int score; // 0-100
  final String category; // 'Excellent', 'Good', 'Moderate', 'Poor'

  ActivityScore({required this.score, required this.category});
}

class PriorityCard {
  final String title;
  final String value;
  final String subtitle;
  final String iconName;

  PriorityCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconName,
  });
}

class TravelData {
  final String fromLocation;
  final String toLocation;
  final DateTime date;
  final double destinationTemp;
  final double rainProbability;
  final String visibility;
  final double windSpeed;
  final int travelReadinessScore; // 0-100
  final String readinessText;
  final bool hasSevereAlerts;

  TravelData({
    required this.fromLocation,
    required this.toLocation,
    required this.date,
    required this.destinationTemp,
    required this.rainProbability,
    required this.visibility,
    required this.windSpeed,
    required this.travelReadinessScore,
    required this.readinessText,
    required this.hasSevereAlerts,
  });
}
