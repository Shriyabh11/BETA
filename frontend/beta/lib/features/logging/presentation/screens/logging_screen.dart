import 'package:flutter/material.dart';
import 'package:beta/features/logging/data/datasource/logging_remote_datasource.dart';
import 'package:beta/core/utils/constants.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({super.key});

  @override
  State<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  final TextEditingController _controller = TextEditingController();
  String? sleep;
  String? insulinDose;
  String? bloodSugar;
  String? food;
  String? exercise;
  String? errorMsg;
  String? _extractedSummary;

  // Insulin calculator controllers
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _bgController = TextEditingController();
  double? _insulinResult;

  // Placeholder values for calculation (to be replaced by user input later)
  final double insulinToCarbRatio = 10; // grams/unit
  final double targetBG = 100; // mg/dL
  final double insulinSensitivity = 50; // mg/dL per unit
  Future<void> _submitLog() async {
    final logDataSource = LogDataSource(baseUrlLogger: baseUrlLogger);
    final now = DateTime.now().toIso8601String();
    final userId = 'user_id'; // Replace with actual user id
    try {
      final response = await logDataSource.processLog(
        text: _controller.text,
        timestamp: now,
        userId: userId,
      );
      String? sleepVal, insulinDoseVal, bloodSugarVal, foodVal, exerciseVal;
      for (final entity in response.entities) {
        final type = entity.type ?? '';
        final value = entity.text ?? 'Not mentioned';
        switch (type.toLowerCase()) {
          case 'sleep':
            sleepVal = value;
            break;
          case 'insulin_dose':
            insulinDoseVal = value;
            break;
          case 'blood_sugar':
            bloodSugarVal = value;
            break;
          case 'food':
            foodVal = value;
            break;
          case 'exercise':
            exerciseVal = value;
            break;
        }
      }
      setState(() {
        sleep = sleepVal ?? 'Not mentioned';
        insulinDose = insulinDoseVal ?? 'Not mentioned';
        bloodSugar = bloodSugarVal ?? 'Not mentioned';
        food = foodVal ?? 'Not mentioned';
        exercise = exerciseVal ?? 'Not mentioned';
        errorMsg = null;
        // Build summary string
        final factors = <String>[];
        if (sleepVal != null) factors.add('Sleep: $sleepVal');
        if (insulinDoseVal != null)
          factors.add('Insulin Dose: $insulinDoseVal');
        if (bloodSugarVal != null) factors.add('Blood Sugar: $bloodSugarVal');
        if (foodVal != null) factors.add('Food: $foodVal');
        if (exerciseVal != null) factors.add('Exercise: $exerciseVal');
        _extractedSummary =
            factors.isNotEmpty ? 'Detected: ' + factors.join(', ') : null;
      });
      _controller.clear();
      // Hide summary after 3 seconds
      if (_extractedSummary != null) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _extractedSummary = null);
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to log: $e';
      });
    }
  }

  void _calculateInsulin() {
    final carbs = double.tryParse(_carbsController.text) ?? 0;
    final bg = double.tryParse(_bgController.text) ?? targetBG;
    final insulin =
        (carbs / insulinToCarbRatio) + ((bg - targetBG) / insulinSensitivity);
    setState(() {
      _insulinResult = insulin > 0 ? insulin : 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _carbsController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Health Log', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What would you like to log today?',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText:
                            'I slept for 7 hours, took 5 units insulin, ate eggs...',
                        hintStyle: const TextStyle(color: Colors.black45),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: Colors.blueAccent),
                          onPressed: _submitLog,
                        ),
                      ),
                      onSubmitted: (_) => _submitLog(),
                    ),
                  ],
                ),
              ),
            ),
            if (errorMsg != null) ...[
              const SizedBox(height: 12),
              Text(errorMsg!, style: const TextStyle(color: Colors.redAccent)),
            ],
            if (_extractedSummary != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _extractedSummary!,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Detected Health Factors:',
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 12),
            _HealthFactorRow(
                icon: Icons.nightlight_round,
                label: 'Sleep',
                value: sleep ?? 'Not mentioned'),
            _HealthFactorRow(
                icon: Icons.medical_services_rounded,
                label: 'Insulin Dose',
                value: insulinDose ?? 'Not mentioned'),
            _HealthFactorRow(
                icon: Icons.bloodtype_rounded,
                label: 'Blood Sugar',
                value: bloodSugar ?? 'Not mentioned'),
            _HealthFactorRow(
                icon: Icons.restaurant,
                label: 'Food',
                value: food ?? 'Not mentioned'),
            _HealthFactorRow(
                icon: Icons.fitness_center_rounded,
                label: 'Exercise',
                value: exercise ?? 'Not mentioned'),
            const SizedBox(height: 32),
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.calculate_rounded, color: Colors.blueAccent),
                        SizedBox(width: 10),
                        Text('Insulin Calculator',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _carbsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Carbs (g)',
                              labelStyle:
                                  const TextStyle(color: Colors.black54),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _bgController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Blood Sugar (mg/dL)',
                              labelStyle:
                                  const TextStyle(color: Colors.black54),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _calculateInsulin,
                        child: const Text('Calculate'),
                      ),
                    ),
                    if (_insulinResult != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          'Recommended Insulin: ${_insulinResult!.toStringAsFixed(2)} units',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthFactorRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _HealthFactorRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(label + ':',
              style: const TextStyle(color: Colors.black54, fontSize: 15)),
          const SizedBox(width: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
        ],
      ),
    );
  }
}
