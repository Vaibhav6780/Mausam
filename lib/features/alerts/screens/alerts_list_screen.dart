import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/weather_data.dart';

class AlertsListScreen extends StatelessWidget {
  const AlertsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.sensors, color: AppColors.danger),
            SizedBox(width: 8),
            Text('Active Civic Alerts', style: TextStyle(color: AppColors.deepNavy, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.softSky,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    const Text('LIVE RADAR SYNC', style: TextStyle(color: AppColors.primaryNavy, fontSize: 8, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final alerts = state.activeAlerts;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Official real-time advisories from India Meteorological Department (IMD) & CPCB',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', alerts.length, true),
                      const SizedBox(width: 8),
                      _buildFilterChip('Severe', alerts.where((a) => a.severity == 'High').length, false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Warnings', alerts.where((a) => a.severity == 'Medium').length, false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Advisories', alerts.where((a) => a.severity == 'Low').length, false),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (alerts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Text('No active alerts', style: TextStyle(color: AppColors.mutedText)),
                    ),
                  )
                else
                  ...alerts.map((alert) => _buildAlertCard(context, alert)).toList(),
                const SizedBox(height: 100), // Padding for bottom nav
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.deepNavy : AppColors.softSky,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.primaryNavy, fontSize: 12, fontWeight: FontWeight.bold)),
          Text('($count)', style: TextStyle(color: isSelected ? Colors.white : AppColors.primaryNavy, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, WeatherAlert alert) {
    final bool isHighPriority = alert.severity.toLowerCase() == 'high';
    final Color bgColor = isHighPriority ? const Color(0xFFFFEBEB) : const Color(0xFFFFF4E5);
    final Color textColor = isHighPriority ? AppColors.danger : AppColors.warning;
    final String priorityText = isHighPriority ? 'ORANGE WARNING • HIGH PRIORITY' : 'YELLOW ADVISORY';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(priorityText, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: textColor, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('h:mm a').format(alert.timestamp)} - ${DateFormat('h:mm a').format(alert.endTime)} IST',
                    style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.title,
            style: const TextStyle(color: AppColors.deepNavy, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: textColor, size: 16),
              const SizedBox(width: 4),
              Text(
                alert.locationName,
                style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.thunderstorm, color: textColor, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alert.description,
                    style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          if (alert.protocols.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.checklist, color: AppColors.deepNavy.withOpacity(0.6), size: 16),
                const SizedBox(width: 4),
                const Text('RECOMMENDED PROTOCOL', style: TextStyle(color: AppColors.deepNavy, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ...alert.protocols.map((protocol) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.close, color: textColor, size: 14), // Mock icon
                  const SizedBox(width: 8),
                  Expanded(child: Text(protocol, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12))),
                ],
              ),
            )),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D253F), // Dark navy from mockup
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.local_police, color: Colors.white, size: 18),
                  label: const Text('Police / SOS (112)', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: textColor.withOpacity(0.5)),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: Icon(Icons.phone_in_talk, color: textColor, size: 18),
                  label: Text('Disaster Cell\n(1077)', textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
