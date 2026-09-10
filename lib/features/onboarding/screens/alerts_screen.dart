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
            Text('When should MAUSAM alert you?', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text('We\'ve prioritized these based on your interests.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  final isSelected = _selected.contains(alert);
                  return SwitchListTile(
                    title: Text(alert, style: Theme.of(context).textTheme.titleMedium),
                    value: isSelected,
                    onChanged: (bool value) {
                      _toggleSelection(alert);
                    },
                    activeColor: AppColors.primaryNavy,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndNext,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
