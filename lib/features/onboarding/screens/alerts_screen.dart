import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';

class AlertsScreen extends StatefulWidget {
  final VoidCallback onNext;

  const AlertsScreen({super.key, required this.onNext});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<String> _alerts = [
    'Heavy Rain',
    'Extreme Heat',
    'Poor Air Quality',
    'High UV',
    'Severe Weather',
    'Travel Weather'
  ];

  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    // Auto-select based on interests
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final interests = Provider.of<AppState>(context, listen: false).preferences.interests;
      List<String> autoSelected = [];
      if (interests.contains('Outdoor Fitness')) autoSelected.addAll(['High UV', 'Poor Air Quality', 'Extreme Heat']);
      if (interests.contains('Travel')) autoSelected.addAll(['Severe Weather', 'Heavy Rain', 'Travel Weather']);
      if (interests.contains('Farming & Gardening')) autoSelected.addAll(['Heavy Rain', 'Extreme Heat']);
      if (interests.contains('Health & Wellness')) autoSelected.addAll(['Poor Air Quality', 'Extreme Heat', 'High UV']);
      
      setState(() {
        _selected = autoSelected.toSet().toList();
      });
    });
  }

  void _toggleSelection(String alert) {
    setState(() {
      if (_selected.contains(alert)) {
        _selected.remove(alert);
      } else {
        _selected.add(alert);
      }
    });
  }

  void _saveAndNext() {
    final appState = Provider.of<AppState>(context, listen: false);
    final prefs = appState.preferences.copyWith(activeAlerts: _selected);
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
            Text('When should MAUSAM alert you?', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('We\'ve prioritized these based on your interests.', style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  final isSelected = _selected.contains(alert);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: SwitchListTile(
                      title: Text(alert, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      value: isSelected,
                      onChanged: (bool value) {
                        _toggleSelection(alert);
                      },
                      activeColor: AppColors.primaryNavy,
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      inactiveThumbColor: Colors.white70,
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
