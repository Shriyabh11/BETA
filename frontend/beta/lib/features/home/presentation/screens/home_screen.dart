import 'package:flutter/material.dart';
import 'package:beta/features/ask/presentation/screens/ask_screen.dart';
import 'package:beta/features/logging/presentation/screens/logging_screen.dart';
import 'package:beta/features/mental_health/presentation/screens/mental_health_screen.dart';
import 'package:beta/features/news/presentation/screens/news_screen.dart';
// TODO: Import your data sources for glucose, steps, etc.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Replace with real data from data sources
    final glucose = 112;
    final glucoseTrend = 'up';
    final progress = 0.7;
    final steps = 5400;
    final lastLog = '2h ago';
    final streak = 5;
    final logsToday = 3;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFE8ECF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to ',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Beta',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          letterSpacing: 1.2,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hey there 👋',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Dedicated Quote/Joke Card
                  _QuoteCard(
                    quote:
                        'Why did the diabetic bring a ladder to the bar? To reach the high spirits!',
                  ),
                  const SizedBox(height: 22),
                  // Log Something Card
                  _AnimatedFeatureCard(
                    icon: Icons.note_alt_rounded,
                    title: 'Log Something 🕒',
                    subtitle: 'Sleep, Food, Stress, Exercise, Period, etc.',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    preview: '3 logs today',
                    badge: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoggingScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Ask Me Anything Card
                  _AnimatedFeatureCard(
                    icon: Icons.smart_toy_rounded,
                    title: 'Ask Me Anything 🛠️',
                    subtitle:
                        'Nutrition, diabetes care, general health questions',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF818CF8), Color(0xFF06B6D4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    preview: 'New: 1 badge',
                    badge: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AskScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Wanna Talk Card
                  _AnimatedFeatureCard(
                    icon: Icons.psychology_alt_rounded,
                    title: 'Wanna Talk? ❤️',
                    subtitle: 'Mental Health Check-in',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9333EA), Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    preview: 'Last: 2h ago',
                    badge: 'Streak: 5 days',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MentalHealthScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // News Card
                  _NewsCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final String preview;
  final String badge;
  final VoidCallback onTap;
  const _AnimatedFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.preview,
    required this.badge,
    required this.onTap,
  });
  @override
  State<_AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<_AnimatedFeatureCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: _FeatureCard(
          icon: widget.icon,
          title: widget.title,
          subtitle: widget.subtitle,
          gradient: widget.gradient,
          preview: widget.preview,
          badge: widget.badge,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final String preview;
  final String badge;
  final VoidCallback onTap;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.preview,
    required this.badge,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 22),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: Colors.white, size: 36),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (preview.isNotEmpty)
                        Text(
                          preview,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      if (badge.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final String quote;
  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.13)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.format_quote_rounded,
                color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quote of the Day',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  quote,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontSize: 13.5,
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

class _NewsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F0FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.13)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.newspaper_rounded,
                  color: Colors.blueAccent, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Type 1 Diabetes News',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stay updated with the latest research and news.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blueGrey[800],
                          fontSize: 13.5,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '2 new articles',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
