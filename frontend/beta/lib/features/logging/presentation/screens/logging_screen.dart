import 'package:flutter/material.dart';
import 'package:beta/features/logging/data/datasource/logging_remote_datasource.dart';
import 'package:beta/core/utils/constants.dart';

import 'package:flutter/material.dart';
// import 'package:beta/data/datasources/log_datasource.dart'; // Assuming you have this file
// import 'package:beta/data/models/log_response.dart'; // And this one

//import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:beta/data/datasources/log_datasource.dart'; // Assuming you have this file
// import 'package:beta/data/models/log_response.dart'; // And this one

// --- Mock classes for demonstration (NOW SMARTER) ---

// Note: speech_to_text import has been removed.
// import 'package:beta/data/datasources/log_datasource.dart'; // Assuming you have this file
// import 'package:beta/data/models/log_response.dart'; // And this one

// --- Mock classes for demonstration (NOW SMARTER) ---
class LogDataSource {
  Future<LogResponse> processLog({required String text, required String timestamp, required String userId}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (text.contains("error")) throw Exception("Simulated network error");

    final entities = <Entity>[];
    final lowerCaseText = text.toLowerCase();

    final insulinRegex = RegExp(r'(\d+\.?\d*)\s*(u|units)');
    if (insulinRegex.hasMatch(lowerCaseText)) {
      final match = insulinRegex.firstMatch(lowerCaseText);
      entities.add(Entity(type: 'insulin_dose', text: '${match?.group(1)} units'));
    }
    
    if (lowerCaseText.contains('ate')) {
      entities.add(Entity(type: 'food', text: text.split('ate').last.split(',').first.trim()));
    }

    return LogResponse(entities: entities);
  }
}
class LogResponse { final List<Entity> entities; LogResponse({required this.entities}); }
class Entity { final String? type; final String? text; Entity({this.type, this.text}); }
// --- End of Mock classes ---

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({super.key});
  @override
  State<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4F8),
        elevation: 0,
        title: Text('Log Entry', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SmartLogCard(),
            SizedBox(height: 24),
            InsulinCalculatorCard(),
          ],
        ),
      ),
    );
  }
}

// --- NEW UNIFIED SMART LOG CARD ---

class SmartLogCard extends StatefulWidget {
  const SmartLogCard({super.key});
  @override
  State<SmartLogCard> createState() => _SmartLogCardState();
}

class _SmartLogCardState extends State<SmartLogCard> {
  final TextEditingController _textController = TextEditingController();
  Map<String, String> _detectedFactors = {};
  bool _isProcessing = false;
  bool _isProcessed = false;
  
  // All speech_to_text state has been removed.

  Future<void> _processText() async {
    if (_textController.text.isEmpty) return;
    setState(() => _isProcessing = true);

    final logDataSource = LogDataSource();
    try {
      final response = await logDataSource.processLog(
        text: _textController.text,
        timestamp: DateTime.now().toIso8601String(),
        userId: 'user_id', // TODO: Get real user ID
      );
      final newFactors = <String, String>{};
      for (final entity in response.entities) {
        if (entity.type != null && entity.text != null) {
          newFactors[entity.type!] = entity.text!;
        }
      }
      setState(() {
        _detectedFactors = newFactors;
        _isProcessed = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to process text: $e'), backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _saveLog() async {
    print("Saving log: $_detectedFactors"); // TODO: Implement actual save logic
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log saved successfully!'), backgroundColor: Colors.green));
    _resetCard();
  }
  
  void _resetCard() {
      setState(() {
      _detectedFactors = {};
      _textController.clear();
      _isProcessed = false;
    });
  }

  void _editFactor(String key, String currentValue) {
    final editingController = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${key.replaceAll('_', ' ')}'),
        content: TextField(controller: editingController, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _detectedFactors[key] = editingController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _addFactor() {
    // TODO: Implement a dialog to manually add a factor
    print("Add factor tapped");
  }

  // --- New function to handle Quick Log Chip taps ---
  void _onChipTapped(String text) {
    final currentText = _textController.text;
    // Add a comma and space if there's already text
    final separator = currentText.isEmpty ? '' : ', ';
    _textController.text += separator + text;
    // Move cursor to the end
    _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isProcessed ? 'Review Your Log' : 'Enter your log',
            style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textController,
            style: const TextStyle(color: Colors.black87),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'e.g., "Ate bread and took 3 units..."',
              hintStyle: const TextStyle(color: Colors.black45),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              // Microphone icon is removed
            ),
          ),
          const SizedBox(height: 12),

          // --- New Quick Log Chips Section ---
          _QuickLogChips(onChipTapped: _onChipTapped),
          const SizedBox(height: 16),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isProcessed ? _buildConfirmationView() : _buildProcessingView(),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingView() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processText,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600], foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isProcessing
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
            : const Text('Process Text', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildConfirmationView() {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _detectedFactors.length,
          itemBuilder: (context, index) {
            final key = _detectedFactors.keys.elementAt(index);
            final value = _detectedFactors[key]!;
            return ListTile(
              leading: Icon(_getIconForFactor(key), color: Colors.blue[600]),
              title: Text(key.replaceAll('_', ' ').split(' ').map((l) => l[0].toUpperCase() + l.substring(1)).join(' ')),
              subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey[500], size: 20),
                onPressed: () => _editFactor(key, value),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 56),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _saveLog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600], foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Log', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Add Factor Manually',
              onPressed: _addFactor,
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Start Over',
              onPressed: _resetCard,
            )
          ],
        )
      ],
    );
  }
  
  IconData _getIconForFactor(String factorType) {
    switch (factorType.toLowerCase()) {
      case 'sleep': return Icons.nightlight_round;
      case 'insulin_dose': return Icons.opacity;
      case 'blood_sugar': return Icons.bloodtype_rounded;
      case 'food': return Icons.restaurant;
      case 'exercise': return Icons.fitness_center_rounded;
      default: return Icons.help_outline;
    }
  }
}

// --- New Widget for Quick Log Chips ---
class _QuickLogChips extends StatelessWidget {
  final Function(String) onChipTapped;
  const _QuickLogChips({required this.onChipTapped});

  @override
  Widget build(BuildContext context) {
    // A list of common log entries
    final List<String> quickLogs = ['Ate a snack', 'Took 5 units', 'BG is 120', 'Went for a walk'];

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: quickLogs.map((log) => ActionChip(
        label: Text(log),
        onPressed: () => onChipTapped(log),
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
      )).toList(),
    );
  }
}


// --- INSULIN CALCULATOR (Re-implemented) ---
class InsulinCalculatorCard extends StatefulWidget {
  const InsulinCalculatorCard({super.key});
  @override
  State<InsulinCalculatorCard> createState() => _InsulinCalculatorCardState();
}

class _InsulinCalculatorCardState extends State<InsulinCalculatorCard> {
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _bgController = TextEditingController();
  double? _insulinResult;

  // User-specific ratios (these should be fetched from user profile)
  final double insulinToCarbRatio = 10; 
  final double targetBG = 100;
  final double insulinSensitivity = 50;

  void _calculateInsulin() {
    final carbs = double.tryParse(_carbsController.text) ?? 0;
    final bg = double.tryParse(_bgController.text) ?? 0;

    if (carbs == 0 && bg == 0) {
      setState(() => _insulinResult = null);
      return;
    }

    final correctionDose = bg > targetBG ? (bg - targetBG) / insulinSensitivity : 0;
    final foodDose = carbs / insulinToCarbRatio;
    final totalDose = foodDose + correctionDose;
    
    setState(() {
      _insulinResult = totalDose > 0 ? totalDose : 0;
    });
  }

  @override
  void dispose() {
    _carbsController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.shade100)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate_rounded, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Text('Insulin Dose Calculator', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: TextField(controller: _carbsController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.black87), decoration: _buildInputDecoration(label: 'Carbs (g)'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _bgController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.black87), decoration: _buildInputDecoration(label: 'BG (mg/dL)'))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: _calculateInsulin,
              child: const Text('Calculate Dose', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          if (_insulinResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recommended Dose: ${_insulinResult!.toStringAsFixed(2)} units',
                      style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }
}
