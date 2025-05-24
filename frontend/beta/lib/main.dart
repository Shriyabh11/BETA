import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/navigation/presentation/widgets/bottom_navigation.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/ask/presentation/screens/chat_screen.dart';
import 'features/ask/presentation/screens/ask_screen.dart';
import 'features/news/presentation/screens/news_screen.dart';
import 'features/logging/presentation/screens/logs_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: MaterialApp(
        title: 'BETA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.selectedIndex,
            children: [
              const HomeScreen(),
              LogsScreen(),
              const Scaffold(
                  body: Center(child: Text('Profile Screen - Coming Soon'))),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
