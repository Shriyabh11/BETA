import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  String? _selectedGender;
  bool? _usesInsulinPump;
  bool? _usesCGM;
  String? _diabetesDuration;
  String? _diabetesType;
  String? _checkFrequency;
  bool? _wantsReminders;
  bool? _wantsCycleTracking;
  String? _mentalHealthStatus;
  bool? _wantsMentalHealthSupport;
  String? _userRole;
  String? _childAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to BETA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            // Add other form fields here
            ElevatedButton(
              onPressed: _completeOnboarding,
              child: const Text('Complete Setup'),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOnboarding() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Home Screen')),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
