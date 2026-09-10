import '../models/user_preferences.dart';

class LocationService {
  Future<LocationModel> getCurrentLocation() async {
    // In a real app, use geolocator package here
    // For this prototype, we simulate returning Ghaziabad
    await Future.delayed(const Duration(seconds: 1));
    return LocationModel(
      name: 'Ghaziabad, Uttar Pradesh',
      latitude: 28.6692,
      longitude: 77.4538,
    );
  }

  Future<List<LocationModel>> searchLocation(String query) async {
    // In a real app, use Open-Meteo Geocoding API or Google Places
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock search results
    final mockDb = [
      LocationModel(name: 'Ghaziabad, Uttar Pradesh', latitude: 28.6692, longitude: 77.4538),
      LocationModel(name: 'New Delhi, Delhi', latitude: 28.6139, longitude: 77.2090),
      LocationModel(name: 'Mumbai, Maharashtra', latitude: 19.0760, longitude: 72.8777),
      LocationModel(name: 'Goa', latitude: 15.2993, longitude: 74.1240),
      LocationModel(name: 'Bangalore, Karnataka', latitude: 12.9716, longitude: 77.5946),
      LocationModel(name: 'Manali, Himachal Pradesh', latitude: 32.2396, longitude: 77.1887),
    ];

    return mockDb.where((loc) => loc.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
