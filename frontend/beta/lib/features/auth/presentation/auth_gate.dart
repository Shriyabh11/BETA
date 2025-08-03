
import 'package:beta/features/auth/presentation/screens/login_screen.dart';
import 'package:beta/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:beta/main.dart'; // Assuming MainScreen is in main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF0F4F8),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, check if onboarding is completed
          return FutureBuilder<bool>(
            future: _checkOnboardingStatus(snapshot.data!.uid),
            builder: (context, onboardingSnapshot) {
              if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Color(0xFFF0F4F8),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (onboardingSnapshot.hasData && onboardingSnapshot.data == true) {
                // Onboarding completed, go to main screen
                return const MainScreen();
              } else {
                // Onboarding not completed, show onboarding screen
                return const OnboardingScreen();
              }
            },
          );
        } else {
          // User is not logged in, show login screen
          return const LoginScreen(); // Replace with your actual login screen
        }
      },
    );
  }

  Future<bool> _checkOnboardingStatus(String uid) async {
    try {
      // Check if user has completed onboarding in Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['onboardingCompleted'] == true;
      }
     // return false;
     // // Document doesn't exist, onboarding not completed
     return true;
    } catch (e) {
      print('Error checking onboarding status: $e');
     // return false;
     // // Error occurred, assume onboarding not completed
     return true;
    }
  }
}