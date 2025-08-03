import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        
        if (doc.exists && mounted) {
          setState(() {
            _userData = doc.data();
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        // Navigate back to login/auth screen
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/', // Adjust route name as needed
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSigningOut = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFF0F4F8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () {
              // TODO: Navigate to edit profile screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile feature coming soon!'),
                ),
              );
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Header
                  _ProfileHeader(
                    user: _user,
                    userData: _userData,
                  ),
                  const SizedBox(height: 24),

                  // Personal Information Section
                  _ProfileSection(
                    title: 'Personal Information',
                    icon: Icons.person_outline,
                    children: [
                      _ProfileItem(
                        label: 'Name',
                        value: _userData?['name'] ?? _user?.displayName ?? 'Not provided',
                        icon: Icons.person,
                      ),
                      _ProfileItem(
                        label: 'Email',
                        value: _user?.email ?? 'Not provided',
                        icon: Icons.email_outlined,
                      ),
                      _ProfileItem(
                        label: 'Gender',
                        value: _userData?['gender'] ?? 'Not specified',
                        icon: Icons.wc_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Diabetes Information Section
                  _ProfileSection(
                    title: 'Diabetes Information',
                    icon: Icons.medical_information_outlined,
                    children: [
                      _ProfileItem(
                        label: 'Diabetes Type',
                        value: _userData?['diabetesType'] ?? 'Not specified',
                        icon: Icons.local_hospital_outlined,
                      ),
                      _ProfileItem(
                        label: 'Duration',
                        value: _userData?['diabetesDuration'] ?? 'Not specified',
                        icon: Icons.schedule_outlined,
                      ),
                      _ProfileItem(
                        label: 'Uses Insulin Pump',
                        value: _getBooleanText(_userData?['usesInsulinPump']),
                        icon: Icons.device_hub_outlined,
                      ),
                      _ProfileItem(
                        label: 'Uses CGM',
                        value: _getBooleanText(_userData?['usesCGM']),
                        icon: Icons.timeline_outlined,
                      ),
                      _ProfileItem(
                        label: 'Check Frequency',
                        value: _userData?['checkFrequency'] ?? 'Not specified',
                        icon: Icons.access_time_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Preferences Section
                  _ProfileSection(
                    title: 'App Preferences',
                    icon: Icons.settings_outlined,
                    children: [
                      _ProfileItem(
                        label: 'Reminders',
                        value: _getBooleanText(_userData?['wantsReminders']),
                        icon: Icons.notifications_outlined,
                      ),
                      if (_userData?['gender'] == 'Female')
                        _ProfileItem(
                          label: 'Cycle Tracking',
                          value: _getBooleanText(_userData?['wantsCycleTracking']),
                          icon: Icons.calendar_today_outlined,
                        ),
                      _ProfileItem(
                        label: 'Mental Health Status',
                        value: _userData?['mentalHealthStatus'] ?? 'Not specified',
                        icon: Icons.psychology_outlined,
                      ),
                      _ProfileItem(
                        label: 'Mental Health Support',
                        value: _getBooleanText(_userData?['wantsMentalHealthSupport']),
                        icon: Icons.support_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Account Actions
                  _ProfileSection(
                    title: 'Account',
                    icon: Icons.account_circle_outlined,
                    children: [
                      _ActionItem(
                        label: 'Change Password',
                        icon: Icons.lock_outline,
                        onTap: () {
                          // TODO: Implement change password
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Change password feature coming soon!'),
                            ),
                          );
                        },
                      ),
                      _ActionItem(
                        label: 'Privacy Settings',
                        icon: Icons.privacy_tip_outlined,
                        onTap: () {
                          // TODO: Navigate to privacy settings
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Privacy settings coming soon!'),
                            ),
                          );
                        },
                      ),
                      _ActionItem(
                        label: 'Help & Support',
                        icon: Icons.help_outline,
                        onTap: () {
                          // TODO: Navigate to help screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Help & support coming soon!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isSigningOut ? null : _showSignOutDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.red.shade200),
                        ),
                        elevation: 0,
                      ),
                      icon: _isSigningOut
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.logout),
                      label: Text(
                        _isSigningOut ? 'Signing Out...' : 'Sign Out',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  String _getBooleanText(bool? value) {
    if (value == null) return 'Not specified';
    return value ? 'Yes' : 'No';
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}

// Custom Widgets
class _ProfileHeader extends StatelessWidget {
  final User? user;
  final Map<String, dynamic>? userData;

  const _ProfileHeader({
    required this.user,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? user?.displayName ?? 'User';
    final email = user?.email ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: user?.photoURL != null
                ? ClipOval(
                    child: Image.network(
                      user!.photoURL!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue.shade600, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
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

class _ActionItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade100),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}