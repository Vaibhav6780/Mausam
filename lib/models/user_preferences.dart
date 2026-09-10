class UserProfile {
  final String name;

  UserProfile({required this.name});
}

class UserPreferences {
  final List<String> interests;
  final List<String> activities;
  final bool useCurrentLocation;
  final LocationModel? savedLocation;
  final List<String> activeAlerts;

  UserPreferences({
    this.interests = const [],
    this.activities = const [],
    this.useCurrentLocation = true,
    this.savedLocation,
    this.activeAlerts = const [],
  });

  UserPreferences copyWith({
    List<String>? interests,
    List<String>? activities,
    bool? useCurrentLocation,
    LocationModel? savedLocation,
    List<String>? activeAlerts,
  }) {
    return UserPreferences(
      interests: interests ?? this.interests,
      activities: activities ?? this.activities,
      useCurrentLocation: useCurrentLocation ?? this.useCurrentLocation,
      savedLocation: savedLocation ?? this.savedLocation,
      activeAlerts: activeAlerts ?? this.activeAlerts,
    );
  }
}

class LocationModel {
  final String name;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
