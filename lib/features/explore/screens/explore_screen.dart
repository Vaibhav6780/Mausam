import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/location_service.dart';
import '../../../models/user_preferences.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> _searchResults = [];
  bool _isSearching = false;

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isSearching = true;
    });
    
    final results = await LocationService().searchLocation(query);
    
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Locations'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search locations (e.g. Delhi, Goa)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: _search,
            ),
            const SizedBox(height: 24),
            if (_isSearching)
              const CircularProgressIndicator()
            else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
              const Text('No locations found.')
            else if (_searchResults.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Search for a city to see weather conditions.'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final loc = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.location_city, color: AppColors.skyBlue),
                        title: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Tap to view weather'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Normally this would navigate to a details page
                          // For demo, we just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected ${loc.name}')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
