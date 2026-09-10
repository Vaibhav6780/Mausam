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
            Text('Where should we start?', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text('We need your location to provide local weather and alerts.', style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            Icon(
              Icons.location_on_outlined,
              size: 100,
              color: AppColors.primaryNavy,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.my_location),
                label: const Text('Use my current location'),
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
              child: OutlinedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Search a location'),
                onPressed: () {
                  // In a full app, this would open a search modal
                  final appState = Provider.of<AppState>(context, listen: false);
                  final prefs = appState.preferences.copyWith(useCurrentLocation: false);
                  appState.updatePreferences(prefs);
                  onNext();
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your location is used to provide local weather and alerts.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
