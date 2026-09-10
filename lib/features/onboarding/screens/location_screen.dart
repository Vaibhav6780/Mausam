import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';

class LocationScreen extends StatelessWidget {
  final VoidCallback onNext;

  const LocationScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Where should we start?', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('We need your location to provide local weather and alerts.', style: const TextStyle(fontSize: 16, color: Colors.white)),
            const Spacer(),
            const Center(
              child: Icon(
                Icons.location_on_outlined,
                size: 100,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.my_location),
                label: const Text('Use my current location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                onPressed: () {
                  final appState = Provider.of<AppState>(context, listen: false);
                  final prefs = appState.preferences.copyWith(useCurrentLocation: true);
                  appState.updatePreferences(prefs);
                  onNext();
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text('Search a location', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                onPressed: () {
                  final appState = Provider.of<AppState>(context, listen: false);
                  final prefs = appState.preferences.copyWith(useCurrentLocation: false);
                  appState.updatePreferences(prefs);
                  onNext();
                },
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Your location is used to provide local weather and alerts.',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
