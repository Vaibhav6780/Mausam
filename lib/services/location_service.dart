import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_preferences.dart';

class LocationService {
  Future<LocationModel> getCurrentLocation() async {
    // No geolocation package wired up yet, so default to a fixed location.
    // Once device coordinates are available, use [reverseGeocode] to resolve
    // them to a place name via Nominatim.
    await Future.delayed(const Duration(milliseconds: 300));
    return LocationModel(
      name: 'Ghaziabad, Uttar Pradesh',
      latitude: 28.6692,
      longitude: 77.4538,
    );
  }

  /// Searches for places by name using the Open-Meteo Geocoding API.
  Future<List<LocationModel>> searchLocation(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final url = Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeQueryComponent(query)}&count=10&language=en&format=json');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>?;

        if (results == null) return [];

        return results.map((r) {
          final parts = [
            r['name'],
            if (r['admin1'] != null) r['admin1'],
            if (r['country'] != null) r['country'],
          ];
          return LocationModel(
            name: parts.join(', '),
            latitude: (r['latitude'] as num).toDouble(),
            longitude: (r['longitude'] as num).toDouble(),
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Resolves coordinates to a human-readable place name using
  /// OpenStreetMap's Nominatim reverse geocoding API.
  Future<LocationModel> reverseGeocode(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude');

      final response = await http.get(
        url,
        headers: {'User-Agent': 'MausamApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] as Map<String, dynamic>?;

        final place = address?['city'] ??
            address?['town'] ??
            address?['village'] ??
            address?['suburb'] ??
            data['name'] ??
            'Unknown location';
        final state = address?['state'];

        return LocationModel(
          name: state != null ? '$place, $state' : place,
          latitude: latitude,
          longitude: longitude,
        );
      }
      throw Exception('Failed to reverse geocode');
    } catch (e) {
      return LocationModel(
        name: 'Lat $latitude, Lon $longitude',
        latitude: latitude,
        longitude: longitude,
      );
    }
  }
}
