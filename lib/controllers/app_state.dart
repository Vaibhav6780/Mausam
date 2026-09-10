import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';
import '../models/weather_data.dart';
import '../models/personalization_data.dart';
import '../services/weather_service.dart';
import '../services/air_quality_service.dart';
import '../services/location_service.dart';
import '../services/personalization_service.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppState extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final AirQualityService _aqiService = AirQualityService();
  final LocationService _locationService = LocationService();
  final PersonalizationService _personalizationService = PersonalizationService();

  UserPreferences _preferences = UserPreferences();
  WeatherData? _currentWeather;
  AirQualityData? _currentAqi;
  LocationModel? _currentLocation;
  List<WeatherAlert> _activeAlerts = [];
  PersonalizedInsight? _currentInsight;
  bool _isLoading = false;
  bool _isFirstLaunch = true;
  String? _avatarUrl;

  UserPreferences get preferences => _preferences;
  WeatherData? get currentWeather => _currentWeather;
  AirQualityData? get currentAqi => _currentAqi;
  LocationModel? get currentLocation => _currentLocation;
  List<WeatherAlert> get activeAlerts => _activeAlerts;
  PersonalizedInsight? get currentInsight => _currentInsight;
  bool get isLoading => _isLoading;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get useMockData => _weatherService.useMockData;
  String? get avatarUrl => _avatarUrl;

  bool get isAuthenticated => Supabase.instance.client.auth.currentUser != null;
  User? get currentUser => Supabase.instance.client.auth.currentUser;

  Future<void> initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    
    // Load preferences
    List<String> interests = prefs.getStringList('interests') ?? [];
    List<String> activities = prefs.getStringList('activities') ?? [];
    bool useCurrentLocation = prefs.getBool('use_current_location') ?? true;
    
    _preferences = UserPreferences(
      interests: interests,
      activities: activities,
      useCurrentLocation: useCurrentLocation,
    );

    if (!_isFirstLaunch) {
      await fetchWeatherData();
    }
    await _fetchProfile();
    notifyListeners();
  }

  Future<void> _fetchProfile() async {
    if (currentUser == null) return;
    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select('avatar_url')
          .eq('id', currentUser!.id)
          .single();
      _avatarUrl = data['avatar_url'];
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    _isFirstLaunch = false;
    await fetchWeatherData();
    notifyListeners();
  }

  void updatePreferences(UserPreferences newPrefs) async {
    _preferences = newPrefs;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('interests', newPrefs.interests);
    await prefs.setStringList('activities', newPrefs.activities);
    await prefs.setBool('use_current_location', newPrefs.useCurrentLocation);
    
    if (_currentWeather != null && _currentAqi != null) {
      _currentInsight = _personalizationService.generateInsight(_preferences, _currentWeather!, _currentAqi!);
    }
    notifyListeners();
  }

  Future<void> fetchWeatherData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentLocation = await _locationService.getCurrentLocation();
      _currentWeather = await _weatherService.getWeatherData(_currentLocation!);
      _currentAqi = await _aqiService.getAirQuality(_currentLocation!);
      _activeAlerts = await _weatherService.getAlerts(_currentLocation!);
      
      _currentInsight = _personalizationService.generateInsight(_preferences, _currentWeather!, _currentAqi!);
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleMockMode(bool value) {
    _weatherService.useMockData = value;
    _aqiService.useMockData = value;
    fetchWeatherData();
  }

  Future<void> signIn(String email, String password) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name) async {
    await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    _avatarUrl = null;
    notifyListeners();
  }

  Future<void> uploadAvatar(File imageFile) async {
    if (currentUser == null) return;
    try {
      final userId = currentUser!.id;
      final fileExt = imageFile.path.split('.').last;
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await Supabase.instance.client.storage.from('avatars').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final newAvatarUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(fileName);

      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': newAvatarUrl})
          .eq('id', userId);

      _avatarUrl = newAvatarUrl;
      notifyListeners();
    } catch (e) {
      print('Error uploading avatar: $e');
      rethrow;
    }
  }
}
