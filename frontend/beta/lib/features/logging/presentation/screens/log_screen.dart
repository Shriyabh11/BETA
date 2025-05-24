import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../bloc/logging_bloc.dart' hide LoggingState;
import '../bloc/logging_state.dart';
/*
class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoggingBloc>(),
      child: const _LogScreenContent(),
    );
  }
}

class _LogScreenContent extends StatelessWidget {
  const _LogScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What would you like to log today?'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocBuilder<LoggingBloc, LoggingState>(
        builder: (context, state) {
          return Column(
            children: [
              // Quick action buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickActionButton(context, 'Sleep', Icons.bedtime_outlined),
                    _buildQuickActionButton(context, 'Food', Icons.restaurant_outlined),
                    _buildQuickActionButton(context, 'Stress', Icons.mood_outlined),
                    _buildQuickActionButton(context, 'Period', Icons.calendar_today_outlined),
                    _buildQuickActionButton(context, 'Exercise', Icons.directions_run_outlined),
                    _buildQuickActionButton(context, 'Mood', Icons.emoji_emotions_outlined),
                  ],
                ),
              ),
              // Main input area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (text) => context.read<LoggingBloc>().add(LoggingEvent.textChanged(text)),
                        decoration: InputDecoration(
                          hintText: 'I slept for 7 hours and skipped breakfast...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      // Extracted tags
                      if (state.extractedData != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.extractedData!.entries.map((entry) {
                            return _buildTag('${entry.key}: ${entry.value}');
                          }).toList(),
                        ),
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            state.error!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Submit button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (state.isExtracting)
                      const LinearProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: state.text.isEmpty
                            ? null
                            : () {
                                context.read<LoggingBloc>().add(LoggingEvent.extractData());
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Extract Data'),
                      ),
                    const SizedBox(height: 8),
                    if (state.isSubmitting)
                      const LinearProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: state.text.isEmpty || state.isSubmitting
                            ? null
                            : () {
                                final userId = FirebaseAuth.instance.currentUser?.uid;
                                if (userId != null) {
                                  context.read<LoggingBloc>().add(LoggingEvent.submitPressed(userId));
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Log Entry'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add quick action text to input
        context.read<LoggingBloc>().add(LoggingEvent.textChanged('$label: '));
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.teal.shade700,
          fontSize: 12,
        ),
      ),
    );
  }
} */
