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
            Text('What are your interests', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('choose what mausam should prioritize for you', style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _interestsList.length,
                itemBuilder: (context, index) {
                  final item = _interestsList[index];
                  final isSelected = _selected.contains(item['title']);
                  return Card(
                    color: isSelected ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.15),
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => _toggleSelection(item['title']!),
                      leading: Icon(
                        _getIcon(item['icon']!),
                        color: Colors.white,
                      ),
                      title: Text(
                        item['title']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item['desc']!, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                      trailing: isSelected 
                        ? const Icon(Icons.check_circle, color: Colors.white)
                        : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selected.isNotEmpty ? _saveAndNext : null,
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
