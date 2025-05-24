import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/navigation_bloc.dart';

class _NavItem {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem(this.icon, this.label, this.index);
}

const _navItems = [
  _NavItem(Icons.home_rounded, 'Home', 0),
  _NavItem(Icons.note_alt_rounded, 'Logs', 1),
  _NavItem(Icons.person_rounded, 'Me', 2),
];

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.98),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_navItems.length, (index) {
                    final item = _navItems[index];
                    final bool selected = state.selectedIndex == item.index;
                    return GestureDetector(
                      onTap: () => context.read<NavigationBloc>().add(
                            NavigationEvent.itemSelected(item.index),
                          ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.blue.withOpacity(0.10)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.10),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(item.icon,
                                color: selected
                                    ? Colors.blueAccent
                                    : Colors.black54,
                                size: 26),
                            const SizedBox(height: 2),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: selected
                                    ? Colors.blueAccent
                                    : Colors.black54,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                            if (selected)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.only(top: 3),
                                height: 3,
                                width: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.blueAccent,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
