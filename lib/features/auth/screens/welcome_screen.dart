import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6DA2E1), Color(0xFF90C2F9)], // Matching the blue gradient in mockup
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Top Section: 3D Weather Icon
              const Expanded(
                child: Center(
                  child: Icon(Icons.cloud, size: 160, color: Colors.white), // Placeholder for 3D Icon
                ),
              ),
              
              // Bottom Section: White Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pagination dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Title
                    const Text(
                      'Weather App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF), // Deep Blue
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Subtitle
                    Text(
                      'Stay ahead of the weather in your city and plan your day with confidence.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Arrow Button
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
