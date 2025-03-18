import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricAuthEnabled = false;
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account settings
            _buildSectionHeader('Account'),
            AppCard(
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: Icons.person_outline,
                    title: 'Profile Information',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRouter.profile);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      // TODO: Implement change password functionality
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    icon: Icons.email_outlined,
                    title: 'Email Preferences',
                    onTap: () {
                      // TODO: Implement email preferences
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications
            _buildSectionHeader('Notifications'),
            AppCard(
              child: Column(
                children: [
                  _buildSwitchItem(
                    icon: Icons.notifications_outlined,
                    title: 'Enable Notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  if (_notificationsEnabled) ...[
                    const Divider(),
                    _buildSettingsItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Calendar Reminders',
                      subtitle: 'Configure event notifications',
                      onTap: () {
                        // TODO: Implement calendar notification settings
                      },
                    ),
                    const Divider(),
                    _buildSettingsItem(
                      icon: Icons.message_outlined,
                      title: 'Message Notifications',
                      subtitle: 'Configure message alerts',
                      onTap: () {
                        // TODO: Implement message notification settings
                      },
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Appearance
            _buildSectionHeader('Appearance'),
            AppCard(
              child: Column(
                children: [
                  _buildSwitchItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                      // TODO: Implement theme switching
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    icon: Icons.text_fields,
                    title: 'Text Size',
                    subtitle: 'Adjust text size throughout the app',
                    onTap: () {
                      // TODO: Implement text size adjustment
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Security
            _buildSectionHeader('Security'),
            AppCard(
              child: Column(
                children: [
                  _buildSwitchItem(
                    icon: Icons.fingerprint,
                    title: 'Biometric Authentication',
                    value: _biometricAuthEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricAuthEnabled = value;
                      });
                      // TODO: Implement biometric authentication
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    icon: Icons.history,
                    title: 'Login History',
                    subtitle: 'View recent account activity',
                    onTap: () {
                      // TODO: Implement login history screen
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About
            _buildSectionHeader('About'),
            AppCard(
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: Icons.info_outline,
                    title: 'About Harmony Bridge',
                    onTap: () {
                      // TODO: Implement about screen
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // TODO: Implement privacy policy screen
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {
                      // TODO: Implement terms of service screen
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // TODO: Implement help & support screen
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sign out button
            AppButton(
              onPressed: () => _handleSignOut(authProvider),
              text: 'Sign Out',
              type: AppButtonType.outlined,
              icon: Icons.logout,
            ),
            
            const SizedBox(height: 16),
            
            // Delete account button
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Implement account deletion
                  _showDeleteAccountDialog();
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red[700],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  
  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }
  
  void _handleSignOut(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await authProvider.signOut();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, AppRouter.login);
                }
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
  
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement account deletion
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[700],
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
