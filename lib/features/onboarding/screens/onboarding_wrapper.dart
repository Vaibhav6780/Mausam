import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_state.dart';
import 'welcome_screen.dart';
import 'interests_screen.dart';
import 'activities_screen.dart';
import 'location_screen.dart';
import 'alerts_screen.dart';
import 'ready_screen.dart';

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      if (!appState.isFirstLaunch) {
        context.go('/home');
      }
    });
  }

  void _nextPage() {
    if (_currentIndex < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Finish onboarding
      Provider.of<AppState>(context, listen: false).completeOnboarding();
      context.go('/home');
    }
  }

  void _skip() {
    Provider.of<AppState>(context, listen: false).completeOnboarding();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable manual swipe to enforce validation
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          WelcomeScreen(onNext: _nextPage, onSkip: _skip),
          InterestsScreen(onNext: _nextPage),
          ActivitiesScreen(onNext: _nextPage),
          LocationScreen(onNext: _nextPage),
          AlertsScreen(onNext: _nextPage),
          ReadyScreen(onNext: _nextPage),
        ],
      ),
    );
  }
}
