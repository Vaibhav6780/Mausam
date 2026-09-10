import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';

class InterestsScreen extends StatefulWidget {
  final VoidCallback onNext;

  const InterestsScreen({super.key, required this.onNext});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<Map<String, String>> _interestsList = [
    {'title': 'Health & Wellness', 'desc': 'Air quality, UV, and heat sensitivity', 'icon': 'favorite_border'},
    {'title': 'Outdoor Fitness', 'desc': 'Running, walking, cycling and outdoor workouts', 'icon': 'directions_run'},
    {'title': 'Travel', 'desc': 'Daily commute, road trips, flights', 'icon': 'flight_takeoff'},
    {'title': 'Family', 'desc': 'School runs, weekend activities', 'icon': 'family_restroom'},
    {'title': 'Farming & Gardening', 'desc': 'Gardening, farming, irrigation', 'icon': 'agriculture'},
    {'title': 'Beach & Water', 'desc': 'Swimming, beach, water sports', 'icon': 'pool'},
  ];

  List<String> _selected = [];

  void _toggleSelection(String title) {
    setState(() {
      if (_selected.contains(title)) {
        _selected.remove(title);
      } else {
        _selected.add(title);
      }
    });
  }

  void _saveAndNext() {
    if (_selected.isEmpty) return;
    final appState = Provider.of<AppState>(context, listen: false);
    final prefs = appState.preferences.copyWith(interests: _selected);
    appState.updatePreferences(prefs);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What matters to you?', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text('Choose what you want MAUSAM to prioritize.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _interestsList.length,
                itemBuilder: (context, index) {
                  final item = _interestsList[index];
                  final isSelected = _selected.contains(item['title']);
                  return Card(
                    color: isSelected ? AppColors.softSky : AppColors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.skyBlue : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => _toggleSelection(item['title']!),
                      leading: Icon(
                        _getIcon(item['icon']!),
                        color: isSelected ? AppColors.primaryNavy : AppColors.secondaryText,
                      ),
                      title: Text(
                        item['title']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppColors.primaryNavy : AppColors.deepNavy,
                        ),
                      ),
                      subtitle: Text(item['desc']!),
                      trailing: isSelected 
                        ? const Icon(Icons.check_circle, color: AppColors.skyBlue)
                        : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected.isNotEmpty ? _saveAndNext : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch(name) {
      case 'favorite_border': return Icons.favorite_border;
      case 'directions_run': return Icons.directions_run;
      case 'flight_takeoff': return Icons.flight_takeoff;
      case 'family_restroom': return Icons.family_restroom;
      case 'agriculture': return Icons.agriculture;
      case 'pool': return Icons.pool;
      default: return Icons.circle_outlined;
    }
  }
}
