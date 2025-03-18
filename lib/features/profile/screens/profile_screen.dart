import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/child_model.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/profile_provider.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 3;

  @override
  void initState() {
    super.initState();
    // Load profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.currentUser?.id ??
          UserModel.currentUserId ??
          'default_user_id';
      Provider.of<ProfileProvider>(
        context,
        listen: false,
      ).loadUserProfile(userId);
      // The children are loaded as part of the loadUserProfile method
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = profileProvider.userProfile ?? authProvider.currentUser;
    final children = profileProvider.children;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.settings);
            },
          ),
        ],
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final userId = authProvider.currentUser?.id ??
                    UserModel.currentUserId ??
                    'default_user_id';
                await Provider.of<ProfileProvider>(
                  context,
                  listen: false,
                ).loadUserProfile(userId);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile section
                    _buildUserProfileSection(user),

                    const SizedBox(height: 24),

                    // Children section
                    _buildChildrenSection(children),

                    const SizedBox(height: 24),

                    // Account section
                    _buildAccountSection(),

                    const SizedBox(height: 24),

                    // Sign out button
                    AppButton(
                      onPressed: () => _handleSignOut(authProvider),
                      text: 'Sign Out',
                      type: AppButtonType.outlined,
                      icon: Icons.logout,
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildUserProfileSection(UserModel? user) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    return AppCard(
      child: Column(
        children: [
          const SizedBox(height: 16),

          // User avatar
          AppAvatar(
            imageUrl: user.profileImageUrl,
            name: user.fullName,
            size: 100,
            borderColor: AppColors.primary,
            borderWidth: 3,
          ),

          const SizedBox(height: 16),

          // User name
          Text(
            user.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          // User email
          Text(
            user.email,
            style:
                const TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 16),

          // Edit profile button
          AppButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.editProfile);
            },
            text: 'Edit Profile',
            type: AppButtonType.outlined,
            icon: Icons.edit,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChildrenSection(List<ChildModel> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Children',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.addChild);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Child'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (children.isEmpty)
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.child_care,
                      size: 48,
                      color: AppColors.textSecondary.withAlpha(100),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No children added yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.addChild);
                      },
                      text: 'Add Child',
                      icon: Icons.add,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              return _buildChildCard(child);
            },
          ),
      ],
    );
  }

  Widget _buildChildCard(ChildModel child) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: AppAvatar(
          imageUrl: child.profileImageUrl,
          name: child.name,
          size: 56,
          borderColor: AppColors.primary,
          borderWidth: 2,
        ),
        title: Text(
          child.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Age: ${child.age} years'),
            if (child.school != null && child.school!.isNotEmpty)
              Text('School: ${child.school}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.editChild, arguments: child);
          },
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.childProfile,
            arguments: child,
          );
        },
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.lock_outline,
                title: 'Privacy',
                onTap: () {
                  // TODO: Navigate to privacy settings
                },
              ),
              const Divider(),
              _buildSettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              const Divider(),
              _buildSettingsItem(
                icon: Icons.security,
                title: 'Security',
                onTap: () {
                  // TODO: Navigate to security settings
                },
              ),
              const Divider(),
              _buildSettingsItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  // TODO: Navigate to help & support
                },
              ),
              const Divider(),
              _buildSettingsItem(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  // TODO: Navigate to about screen
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _handleNavigation(int index) {
    if (index == _currentNavIndex) return;

    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        break;
      case 1: // Calendar
        Navigator.pushReplacementNamed(context, AppRouter.calendar);
        break;
      case 2: // Messages
        Navigator.pushReplacementNamed(context, AppRouter.messaging);
        break;
      case 3: // Profile - already here
        break;
    }
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
}
