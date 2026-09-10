import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';

class ActivitiesScreen extends StatefulWidget {
  final VoidCallback onNext;

  const ActivitiesScreen({super.key, required this.onNext});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<String> _selected = [];

  List<String> _getAvailableActivities(List<String> interests) {
    Set<String> activities = {};
    if (interests.contains('Outdoor Fitness')) {
      activities.addAll(['Running', 'Walking', 'Cycling', 'Yoga', 'Outdoor workout']);
    }
    if (interests.contains('Travel')) {
      activities.addAll(['Daily commute', 'Road trips', 'Flights', 'Outdoor sightseeing']);
    }
    if (interests.contains('Health & Wellness')) {
      activities.addAll(['Air quality check', 'Heat exposure limits', 'UV protection']);
    }
    if (interests.contains('Farming & Gardening')) {
      activities.addAll(['Gardening', 'Farming', 'Irrigation', 'Crop care']);
    }
    if (interests.contains('Beach & Water')) {
      activities.addAll(['Swimming', 'Beach', 'Water sports', 'Boating']);
    }
    if (interests.contains('Family')) {
      activities.addAll(['Playground', 'School run', 'Picnic']);
    }
    return activities.toList();
  }

  void _toggleSelection(String activity) {
    setState(() {
      if (_selected.contains(activity)) {
        _selected.remove(activity);
      } else {
        _selected.add(activity);
      }
    });
  }

  void _saveAndNext() {
    final appState = Provider.of<AppState>(context, listen: false);
    final prefs = appState.preferences.copyWith(activities: _selected);
    appState.updatePreferences(prefs);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final interests = Provider.of<AppState>(context).preferences.interests;
    final availableActivities = _getAvailableActivities(interests);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Activities', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Select the specific activities you do.', style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: availableActivities.map((activity) {
                    final isSelected = _selected.contains(activity);
                    return InkWell(
                      onTap: () => _toggleSelection(activity),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          activity,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveAndNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
