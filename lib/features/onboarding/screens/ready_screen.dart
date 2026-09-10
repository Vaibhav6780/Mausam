import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import '../../../core/theme/app_colors.dart';

class ReadyScreen extends StatefulWidget {
  final VoidCallback onNext;

  const ReadyScreen({super.key, required this.onNext});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.isLoading || state.currentInsight == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final insight = state.currentInsight!;
          final interests = state.preferences.interests;
          String primaryInterest = interests.isNotEmpty ? interests.first : "Your Day";

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text('Your MAUSAM', style: Theme.of(context).textTheme.bodyLarge),
                Text('is ready.', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: AppColors.border.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(primaryInterest, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.skyBlue)),
                          Icon(Icons.stars, color: AppColors.warmSunrise, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(insight.title, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(insight.insightText, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    child: const Text('See my weather'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
