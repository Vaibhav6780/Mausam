import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const WelcomeScreen({super.key, required this.onNext, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.cloud_outlined,
              size: 120,
              color: AppColors.primaryNavy,
            ),
            const SizedBox(height: 40),
            Text(
              'Weather that gets you.',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'MAUSAM puts the weather information that matters to YOU first.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNext,
                child: const Text('Let\'s personalize it'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onSkip,
              child: const Text('Skip'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
