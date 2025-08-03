import 'package:beta/features/auth/presentation/auth_gate.dart';
import 'package:beta/features/home/presentation/screens/home_screen.dart';
import 'package:beta/features/logging/presentation/screens/logs_screen.dart';
import 'package:beta/features/profile/presentation/screens/profile_screen.dart';

import 'package:beta/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The BlocProvider is no longer needed here
    return MaterialApp(
      title: 'BETA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
    );
  }
}

// MainScreen is now a StatefulWidget
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. State variable to hold the current index
  int _selectedIndex = 0;

  // 2. Callback function to update the state
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of screens to navigate between
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LogsScreen(),
   ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      backgroundColor: Color.fromARGB(255, 237, 243, 249),
      // 3. Pass the current index and the callback to the nav bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}


class CustomBottomNavBar extends StatelessWidget {
  // It now accepts the selected index and a callback function
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // No BlocBuilder needed. The UI is built directly from the passed-in selectedIndex.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home_filled,
            label: 'Home',
            isSelected: selectedIndex == 0,
            onTap: () => onItemTapped(0), // Calls the function from the parent
          ),
          _NavBarItem(
            icon: Icons.bar_chart_rounded,
            label: 'Logs',
            isSelected: selectedIndex == 1,
            onTap: () => onItemTapped(1), // Calls the function from the parent
          ),
          _NavBarItem(
            icon: Icons.person_rounded,
            label: 'Profile',
            isSelected: selectedIndex == 2,
            onTap: () => onItemTapped(2), // Calls the function from the parent
          ),
        ],
      ),
    );
  }
}

// The _NavBarItem widget remains the same as it was UI-only.
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.blue[700] : Colors.grey[500];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
