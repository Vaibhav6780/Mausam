import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        _isUploading = true;
      });

      await Provider.of<AppState>(context, listen: false).uploadAvatar(File(image.path));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile picture: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.danger),
            onPressed: () async {
              await Provider.of<AppState>(context, listen: false).signOut();
              if (mounted) context.go('/login');
            },
          )
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final prefs = state.preferences;
          final userName = state.currentUser?.userMetadata?['full_name'] ?? 'User';
          final avatarUrl = state.avatarUrl;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _isUploading ? null : _pickAndUploadImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.softSky,
                        backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
                        child: avatarUrl == null 
                            ? const Icon(Icons.person, size: 50, color: AppColors.primaryNavy)
                            : null,
                      ),
                      if (_isUploading)
                        const Positioned.fill(
                          child: CircularProgressIndicator(),
                        ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryNavy,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              
              _buildSectionHeader(context, 'Personalization'),
              _buildListTile(
                context, 
                Icons.favorite_border, 
                'Your Interests', 
                prefs.interests.join(', '),
                onTap: () {},
              ),
              _buildListTile(
                context, 
                Icons.directions_run, 
                'Your Activities', 
                '${prefs.activities.length} selected',
                onTap: () {},
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Preferences'),
              _buildListTile(
                context, 
                Icons.location_on_outlined, 
                'Location', 
                prefs.useCurrentLocation ? 'Current Location' : 'Custom',
                onTap: () {},
              ),
              _buildListTile(
                context, 
                Icons.notifications_outlined, 
                'Alert Preferences', 
                '${prefs.activeAlerts.length} active',
                onTap: () {},
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Developer Settings'),
              SwitchListTile(
                title: const Text('Use Mock Data'),
                subtitle: const Text('Toggle between API and Mock data'),
                value: state.useMockData,
                onChanged: (bool value) {
                  Provider.of<AppState>(context, listen: false).toggleMockMode(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(value ? 'Mock Mode Enabled' : 'Live Mode Enabled')),
                  );
                },
                activeColor: AppColors.primaryNavy,
              ),

              const SizedBox(height: 32),
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    // Reset onboarding
                    final sharedPrefs = await SharedPreferences.getInstance();
                    await sharedPrefs.clear();
                    if (mounted) context.go('/');
                  },
                  icon: const Icon(Icons.restart_alt, color: AppColors.danger),
                  label: const Text('Reset Onboarding', style: TextStyle(color: AppColors.danger)),
                ),
              ),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.secondaryText,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryNavy),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right, color: AppColors.mutedText),
        onTap: onTap,
      ),
    );
  }
}
