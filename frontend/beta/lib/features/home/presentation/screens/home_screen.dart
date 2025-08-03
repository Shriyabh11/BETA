import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Make sure to import your other screen files here if needed
import 'package:beta/features/ask/presentation/screens/ask_screen.dart'; //AskScreen()
 import 'package:beta/features/news/presentation/screens/news_screen.dart';//NewsScreen()
 import 'package:beta/features/logging/presentation/screens/logging_screen.dart';//LoggingScreen()
import 'package:beta/features/mental_health/presentation/screens/mental_health_screen.dart'; //MentalHealthScreen()

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Personalized Header
                _Header(user: _user, onSignOut: _signOut),
                const SizedBox(height: 24),

                // 2. "Tip of the Day" Card (Replaces the stats dashboard)
                const _TipOfTheDayCard(
                  tip: 'Staying hydrated can help with blood sugar regulation. Have you had a glass of water recently?',
                ),
                const SizedBox(height: 24),

                // 3. Features Section
                Text('What would you like to do?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                const SizedBox(height: 16),
                _AnimatedFeatureCard(
                  icon: Icons.note_alt_rounded,
                  title: 'Log Something',
                  subtitle: 'Food, exercise, BG, and more',
                  gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)]),
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => LoggingScreen())); },
                ),
                const SizedBox(height: 16),
                _AnimatedFeatureCard(
                  icon: Icons.smart_toy_rounded,
                  title: 'Ask BETA Anything',
                  subtitle: 'Nutrition, health queries, and more',
                  gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]),
                  onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => AskScreen())); },
                ),
                const SizedBox(height: 16),
                _AnimatedFeatureCard(
                  icon: Icons.psychology_alt_rounded,
                  title: 'Wanna Talk?',
                  subtitle: 'Your mental health companion',
                  gradient: const LinearGradient(colors: [Color(0xFF9333EA), Color(0xFFD946EF)]),
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MentalHealthScreen()));},
                ),
                const SizedBox(height: 24),

                // 4. News Card
                Text('Stay Informed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                const SizedBox(height: 16),
                _NewsCard(
                  onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen()));},
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class _Header extends StatelessWidget {
  final User? user;
  final VoidCallback onSignOut;
  const _Header({this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final String greetingName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s make it a great Sunday, $greetingName!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text('Ready to take on the day?', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
        IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: onSignOut, tooltip: 'Sign Out'),
      ],
    );
  }
}

// New "Tip of the Day" Widget
class _TipOfTheDayCard extends StatelessWidget {
  final String tip;
  const _TipOfTheDayCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.shade100)
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.blue.shade600, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip for Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// These widgets remain the same
class _AnimatedFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _AnimatedFeatureCard({
    required this.icon, required this.title, required this.subtitle,
    required this.gradient, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: gradient.colors.last.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
              ],
            )),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.newspaper_rounded, color: Colors.blue.shade600, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latest T1D News', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('New research on artificial pancreas systems', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            )),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}

