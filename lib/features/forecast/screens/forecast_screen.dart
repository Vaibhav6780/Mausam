import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/weather_data.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 4),
              Consumer<AppState>(
                builder: (context, state, child) => Text(
                  state.currentLocation?.name ?? 'Loading...',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 200,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF38B2FF), Color(0xFFD4EFFF), Colors.white],
            stops: [0.0, 0.4, 0.7],
          ),
        ),
        child: Consumer<AppState>(
          builder: (context, state, child) {
            if (state.isLoading || state.currentWeather == null) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final weather = state.currentWeather!;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.cloud, size: 120, color: Colors.white), // Mock 3D Cloud
                    Text(
                      '${weather.currentTemp.round()}°',
                      style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w300, color: Colors.white, height: 1.0),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // Metrics Row 1
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetric(Icons.water_drop, 'Humidity', '${weather.humidity.round()}%'),
                          _buildDivider(),
                          _buildMetric(Icons.air, 'Wind', '${weather.windSpeed.round()}m/s'),
                          _buildDivider(),
                          _buildMetric(Icons.wb_twilight, 'Sunrise', '5:30'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Metrics Row 2
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('UV Index', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    Text('${weather.uvIndex.round()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(4, (index) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Icon(Icons.wb_sunny, size: 16, color: index == 0 ? AppColors.skyBlue : Colors.grey[300]),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('AQI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    Text('${state.currentAqi?.aqi ?? 0}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(state.currentAqi?.aqiCategory ?? 'Good', style: const TextStyle(color: AppColors.skyBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 7-Day Forecast Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          if (index >= weather.daily.length) return const SizedBox();
                          final day = weather.daily[index];
                          final isToday = index == 0;
                          
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isToday ? AppColors.skyBlue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.cloud, color: isToday ? Colors.white : Colors.grey[400], size: 24),
                                    const SizedBox(height: 8),
                                    Text('${day.maxTemp.round()}/${day.minTemp.round()}', 
                                      style: TextStyle(color: isToday ? Colors.white : Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(isToday ? 'Today' : DateFormat('E').format(day.date), 
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Hourly Forecast Card
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) {
                            final hourly = weather.hourly[index];
                            final isNow = index == 3; // Mocking current time selection
                            return Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${index + 10}h', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: 8,
                                    height: 40 + (hourly.temp % 30),
                                    decoration: BoxDecoration(
                                      color: isNow ? AppColors.skyBlue : AppColors.softSky,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Nav bar padding
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.skyBlue, size: 24),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[200],
    );
  }
}
