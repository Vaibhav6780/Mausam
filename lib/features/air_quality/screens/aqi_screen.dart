import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';

class AqiScreen extends StatelessWidget {
  const AqiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Quality'),
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.isLoading || state.currentAqi == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final aqi = state.currentAqi!;
          Color aqiColor = _getAqiColor(aqi.aqi);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: aqiColor, width: 8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${aqi.aqi}',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: aqiColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 72,
                          ),
                        ),
                        Text(
                          aqi.aqiCategory,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: aqiColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: aqiColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: aqiColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: aqiColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getAqiRecommendation(aqi.aqi, state.preferences.activities),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.deepNavy),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('POLLUTANTS', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.secondaryText)),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildPollutantCard(context, 'PM2.5', aqi.pm25),
                    _buildPollutantCard(context, 'PM10', aqi.pm10),
                    _buildPollutantCard(context, 'CO', aqi.co),
                    _buildPollutantCard(context, 'NO2', aqi.no2),
                    _buildPollutantCard(context, 'SO2', aqi.so2),
                    _buildPollutantCard(context, 'O3', aqi.o3),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPollutantCard(BuildContext context, String name, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: Theme.of(context).textTheme.bodySmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value.toStringAsFixed(1), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: 4),
              Text('µg/m³', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return AppColors.success;
    if (aqi <= 100) return AppColors.warning;
    if (aqi <= 150) return AppColors.alertCoral;
    return AppColors.danger;
  }

  String _getAqiRecommendation(int aqi, List<String> activities) {
    bool isRunner = activities.contains('Running');
    if (aqi <= 50) return "Air quality is excellent. Great conditions for outdoor activities.";
    if (aqi <= 100) return "Air quality is acceptable. Unusually sensitive people should consider limiting prolonged outdoor exertion.";
    if (aqi <= 150) {
      if (isRunner) return "AQI is moderate today. Consider shifting your run to the early morning when pollution levels are typically lower.";
      return "Air quality is poor for sensitive groups. Reduce prolonged or heavy outdoor exertion.";
    }
    return "Health alert: The risk of health effects is increased for everyone. Avoid prolonged outdoor activities.";
  }
}
