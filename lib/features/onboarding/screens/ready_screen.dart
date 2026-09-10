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
                const Text('Your MAUSAM', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Text('is ready.', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(primaryInterest, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const Icon(Icons.stars, color: Colors.white, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(insight.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(insight.insightText, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: const Text('See my weather', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
