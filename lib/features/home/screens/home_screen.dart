import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/weather_data.dart';
import '../../../models/personalization_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.currentWeather == null || state.currentInsight == null) {
            return const Center(child: Text('Failed to load weather data.'));
          }

          final weather = state.currentWeather!;
          final location = state.currentLocation?.name ?? 'Unknown Location';
          final insight = state.currentInsight!;
          final userName = state.currentUser?.userMetadata?['full_name']?.split(' ').first ?? 'Anya';

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: state.fetchWeatherData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, location, userName),
                    const SizedBox(height: 16),
                    _buildStatusBar(context),
                    const SizedBox(height: 16),
                    _buildWeatherCard(context, weather),
                    const SizedBox(height: 24),
                    _buildImportantCard(context, insight),
                    const SizedBox(height: 24),
                    _buildHourlyForecast(context, weather),
                    const SizedBox(height: 100), // Padding for floating nav bar
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String location, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, $userName !',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.my_location, color: AppColors.skyBlue, size: 16),
                const SizedBox(width: 6),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        Consumer<AppState>(
          builder: (context, state, child) {
            final avatarUrl = state.avatarUrl;
            return CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.softSky,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null 
                  ? const Icon(Icons.person, size: 24, color: AppColors.primaryNavy)
                  : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.mutedText, size: 16),
            const SizedBox(width: 4),
            Text(
              'Updated 4m ago • IMD Official Station',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.softSky,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.skyBlue, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(
                'LIVE',
                style: TextStyle(color: AppColors.primaryNavy, fontSize: 10, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard(BuildContext context, WeatherData weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5BA4F8), Color(0xFF3B82F6)], // Custom sky blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.skyBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.currentTemp.round()}°',
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          'C',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getWeatherDescription(weather.weatherCode),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Feels like ${weather.feelsLike.round()}° • H: ${weather.daily.first.maxTemp.round()}° L: ${weather.daily.first.minTemp.round()}°',
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'UV ${weather.uvIndex} Mod',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              // Simulated 3D Weather Icon
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.cloud, size: 100, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeatherMetric('HUMIDITY', '${weather.humidity.round()}%', Icons.water_drop_outlined),
                _buildWeatherMetric('WIND', '${weather.windSpeed.round()} ENE', Icons.air),
                _buildWeatherMetric('UV INDEX', '${weather.uvIndex}.0', Icons.wb_sunny_outlined),
                _buildWeatherMetric('VISIBILITY', '${weather.visibility.round()} km', Icons.visibility_outlined),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeatherMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildImportantCard(BuildContext context, PersonalizedInsight insight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warmSunrise.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'IMPORTANT FOR YOU',
                      style: TextStyle(color: Colors.orange[800], fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.softSky,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Outdoor Fitness',
                      style: TextStyle(color: AppColors.primaryNavy, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.directions_run, color: AppColors.skyBlue, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            insight.insightText, // E.g., 'Morning looks like your best window for outdoor activity.'
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          if (insight.bestTime != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RECOMMENDED SLOT', style: TextStyle(color: AppColors.mutedText, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat('h:mm a').format(insight.bestTime!.startTime)} - ${DateFormat('h:mm a').format(insight.bestTime!.endTime)}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.deepNavy),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Moderate humidity • Cleanest air of the day',
                          style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text('${insight.activityScore.score} /', style: const TextStyle(color: AppColors.skyBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                        const Text('100', style: TextStyle(color: AppColors.skyBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                        Row(
                          children: [
                            Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.skyBlue, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text(insight.activityScore.category.toUpperCase(), style: const TextStyle(color: AppColors.skyBlue, fontWeight: FontWeight.w800, fontSize: 10)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.softSky,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('View workout breakdown', style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: AppColors.primaryNavy, size: 16),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(BuildContext context, WeatherData weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('HOURLY CONDITIONS', style: TextStyle(color: AppColors.mutedText, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            Row(
              children: [
                const Text('Full 24h', style: TextStyle(color: AppColors.skyBlue, fontSize: 11, fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_forward, color: AppColors.skyBlue, size: 12),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24,
            itemBuilder: (context, index) {
              final hourly = weather.hourly[index];
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: index == 2 ? AppColors.skyBlue : AppColors.white, // Mocking a selected state for styling demo
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      index == 0 ? 'Now' : DateFormat('h a').format(hourly.time),
                      style: TextStyle(
                        color: index == 2 ? AppColors.white : AppColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      _getWeatherIcon(hourly.weatherCode),
                      size: 24,
                      color: index == 2 ? AppColors.white : AppColors.deepNavy,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${hourly.temp.round()}°',
                      style: TextStyle(
                        color: index == 2 ? AppColors.white : AppColors.deepNavy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getWeatherDescription(int code) {
    if (code == 0) return 'Clear Sky';
    if (code == 1 || code == 2) return 'Partly Cloudy';
    if (code == 3) return 'Overcast';
    if (code >= 50 && code <= 69) return 'Rain';
    if (code >= 70 && code <= 79) return 'Snow';
    if (code >= 80 && code <= 99) return 'Thunderstorm';
    return 'Cloudy';
  }

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code == 1 || code == 2) return Icons.cloud_queue;
    if (code == 3) return Icons.cloud;
    if (code >= 50 && code <= 69) return Icons.water_drop;
    if (code >= 70 && code <= 79) return Icons.ac_unit;
    if (code >= 80 && code <= 99) return Icons.thunderstorm;
    return Icons.wb_cloudy;
  }
}
