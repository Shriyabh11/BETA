import 'package:beta/main.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
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
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Welcome to BETA', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF0F4F8),
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.waving_hand, color: Colors.white, size: 32),
                    const SizedBox(height: 12),
                    const Text(
                      'Let\'s get to know you better!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us personalize your BETA experience',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Personal Information Section
              _SectionHeader(title: 'Personal Information'),
              const SizedBox(height: 16),
              
              _CustomTextField(
                controller: _nameController,
                label: 'What should we call you?',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _CustomDropdown(
                value: _selectedGender,
                label: 'Gender',
                icon: Icons.person_outline,
                items: const ['Male', 'Female', 'Other', 'Prefer not to say'],
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: 24),

              // Diabetes Information Section
              _SectionHeader(title: 'Diabetes Information'),
              const SizedBox(height: 16),

              _CustomDropdown(
                value: _diabetesType,
                label: 'Type of Diabetes',
                icon: Icons.medical_information_outlined,
                items: const ['Type 1', 'Type 2', 'MODY', 'Gestational', 'Other'],
                onChanged: (value) => setState(() => _diabetesType = value),
              ),
              const SizedBox(height: 16),

              _CustomDropdown(
                value: _diabetesDuration,
                label: 'How long have you had diabetes?',
                icon: Icons.schedule_outlined,
                items: const [
                  'Less than 1 year',
                  '1-5 years',
                  '5-10 years',
                  '10-20 years',
                  'More than 20 years'
                ],
                onChanged: (value) => setState(() => _diabetesDuration = value),
              ),
              const SizedBox(height: 16),

              _CustomYesNoTile(
                title: 'Do you use an insulin pump?',
                value: _usesInsulinPump,
                onChanged: (value) => setState(() => _usesInsulinPump = value),
              ),
              const SizedBox(height: 12),

              _CustomYesNoTile(
                title: 'Do you use a CGM (Continuous Glucose Monitor)?',
                value: _usesCGM,
                onChanged: (value) => setState(() => _usesCGM = value),
              ),
              const SizedBox(height: 16),

              _CustomDropdown(
                value: _checkFrequency,
                label: 'How often do you check your blood sugar?',
                icon: Icons.timeline_outlined,
                items: const [
                  'Multiple times daily',
                  'Once daily',
                  'Few times a week',
                  'Rarely',
                  'Only when feeling unwell'
                ],
                onChanged: (value) => setState(() => _checkFrequency = value),
              ),
              const SizedBox(height: 24),

              // Preferences Section
              _SectionHeader(title: 'Your Preferences'),
              const SizedBox(height: 16),

              _CustomYesNoTile(
                title: 'Would you like medication/check reminders?',
                value: _wantsReminders,
                onChanged: (value) => setState(() => _wantsReminders = value),
              ),
              const SizedBox(height: 12),

              if (_selectedGender == 'Female') ...[
                _CustomYesNoTile(
                  title: 'Would you like menstrual cycle tracking?',
                  value: _wantsCycleTracking,
                  onChanged: (value) => setState(() => _wantsCycleTracking = value),
                ),
                const SizedBox(height: 12),
              ],

              _CustomDropdown(
                value: _mentalHealthStatus,
                label: 'How would you describe your mental health?',
                icon: Icons.psychology_outlined,
                items: const [
                  'Excellent',
                  'Good',
                  'Fair',
                  'Struggling',
                  'Prefer not to say'
                ],
                onChanged: (value) => setState(() => _mentalHealthStatus = value),
              ),
              const SizedBox(height: 16),

              _CustomYesNoTile(
                title: 'Would you like mental health support features?',
                value: _wantsMentalHealthSupport,
                onChanged: (value) => setState(() => _wantsMentalHealthSupport = value),
              ),
              const SizedBox(height: 32),

              // Complete Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Complete Setup',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Here you would save the user data to Firebase/database
      // For now, we'll just simulate a delay
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Save user preferences to Firebase/database
      // Example:
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(FirebaseAuth.instance.currentUser?.uid)
      //     .update({
      //       'name': _nameController.text,
      //       'gender': _selectedGender,
      //       'diabetesType': _diabetesType,
      //       'onboardingCompleted': true,
      //       // ... other fields
      //     });

      if (mounted) {
        // Navigate to MainScreen (which contains your bottom nav and home screen)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

// Custom Widgets
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final IconData icon;
  final List<String> items;
  final void Function(String?) onChanged;

  const _CustomDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _CustomYesNoTile extends StatelessWidget {
  final String title;
  final bool? value;
  final void Function(bool?) onChanged;

  const _CustomYesNoTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: value == true ? Colors.blue.shade50 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: value == true ? Colors.blue.shade300 : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: value == true ? Colors.blue.shade700 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: value == false ? Colors.blue.shade50 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: value == false ? Colors.blue.shade300 : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      'No',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: value == false ? Colors.blue.shade700 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}