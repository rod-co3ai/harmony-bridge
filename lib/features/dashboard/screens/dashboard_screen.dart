import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/child_model.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/dashboard_provider.dart';
import '../../auth/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load dashboard data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(
        context,
        listen: false,
      ).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body:
          dashboardProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () => dashboardProvider.refreshDashboardData(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      _buildWelcomeSection(user?.fullName ?? 'User'),

                      const SizedBox(height: 24),

                      // Children section
                      _buildChildrenSection(dashboardProvider.children),

                      const SizedBox(height: 24),

                      // Upcoming events section
                      _buildUpcomingEventsSection(
                        dashboardProvider.upcomingEvents,
                      ),

                      const SizedBox(height: 24),

                      // Recent messages section
                      _buildRecentMessagesSection(
                        dashboardProvider.recentMessages,
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement quick action menu
          _showQuickActionMenu(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeSection(String userName) {
    final greeting = _getGreeting();

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $userName',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Welcome to Harmony Bridge',
            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.calendar);
                  },
                  text: 'Calendar',
                  icon: Icons.calendar_today,
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.messaging);
                  },
                  text: 'Messages',
                  icon: Icons.message,
                  type: AppButtonType.outlined,
                  height: 44,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenSection(List<ChildModel> children) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Children',
          onSeeAllPressed: () {
            Navigator.pushNamed(context, AppRouter.profile);
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              return _buildChildCard(child);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChildCard(ChildModel child) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.childProfile, arguments: child);
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            AppAvatar(
              imageUrl: child.profileImageUrl,
              name: child.name,
              size: 64,
              borderColor: AppColors.primary,
              borderWidth: 2,
            ),
            const SizedBox(height: 8),
            Text(
              child.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${child.age} years',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsSection(List<EventModel> events) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Upcoming Events',
          onSeeAllPressed: () {
            Navigator.pushNamed(context, AppRouter.calendar);
          },
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length > 3 ? 3 : events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(event);
          },
        ),
      ],
    );
  }

  Widget _buildEventCard(EventModel event) {
    final formattedDate = _formatEventDate(event);
    final formattedTime =
        event.isAllDay
            ? 'All day'
            : '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(_getEventIcon(event), color: AppColors.primary),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(formattedDate),
            Text(formattedTime),
            if (event.location != null && event.location!.isNotEmpty)
              Text(
                event.location!,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to event details
        },
      ),
    );
  }

  Widget _buildRecentMessagesSection(List<MessageModel> messages) {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Recent Messages',
          onSeeAllPressed: () {
            Navigator.pushNamed(context, AppRouter.messaging);
          },
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: messages.length > 3 ? 3 : messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _buildMessageCard(message);
          },
        ),
      ],
    );
  }

  Widget _buildMessageCard(MessageModel message) {
    final isOutgoing =
        message.senderId ==
        Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
    final formattedTime = _formatMessageTime(message.timestamp);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: AppAvatar(
          imageUrl: null, // TODO: Get sender/receiver image
          name: isOutgoing ? 'You' : 'Co-Parent', // TODO: Get actual name
          size: 48,
        ),
        title: Row(
          children: [
            Text(
              isOutgoing ? 'You' : 'Co-Parent', // TODO: Get actual name
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message.content, maxLines: 2, overflow: TextOverflow.ellipsis),
            if (message.attachments != null && message.attachments!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.attachment,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${message.attachments!.length} attachment${message.attachments!.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.conversation,
            arguments: isOutgoing ? message.receiverId : message.senderId,
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (onSeeAllPressed != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: const Text(
              'See All',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  void _handleNavigation(int index) {
    if (index == _currentNavIndex) return;

    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0: // Dashboard - already here
        break;
      case 1: // Calendar
        Navigator.pushReplacementNamed(context, AppRouter.calendar);
        break;
      case 2: // Messages
        Navigator.pushReplacementNamed(context, AppRouter.messaging);
        break;
      case 3: // Profile
        Navigator.pushReplacementNamed(context, AppRouter.profile);
        break;
    }
  }

  void _showQuickActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withAlpha(30),
                  child: const Icon(Icons.event, color: AppColors.primary),
                ),
                title: const Text('Add Event'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to add event screen
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withAlpha(30),
                  child: const Icon(Icons.message, color: AppColors.primary),
                ),
                title: const Text('New Message'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.messaging);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withAlpha(30),
                  child: const Icon(Icons.person_add, color: AppColors.primary),
                ),
                title: const Text('Add Child'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to add child screen
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _formatEventDate(EventModel event) {
    final now = DateTime.now();
    final eventDate = event.startTime;

    if (eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day) {
      return 'Today';
    } else if (eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day + 1) {
      return 'Tomorrow';
    } else {
      // Format as "Mon, Jan 1"
      return '${_getDayOfWeek(eventDate)}, ${_getMonth(eventDate)} ${eventDate.day}';
    }
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return _getDayOfWeek(time);
      } else {
        return '${_getMonth(time)} ${time.day}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getEventIcon(EventModel event) {
    if (event.title.toLowerCase().contains('doctor') ||
        event.title.toLowerCase().contains('appointment') ||
        event.title.toLowerCase().contains('medical')) {
      return Icons.medical_services;
    } else if (event.title.toLowerCase().contains('school') ||
        event.title.toLowerCase().contains('class') ||
        event.title.toLowerCase().contains('teacher')) {
      return Icons.school;
    } else if (event.title.toLowerCase().contains('pickup') ||
        event.title.toLowerCase().contains('drop') ||
        event.title.toLowerCase().contains('transport')) {
      return Icons.directions_car;
    } else if (event.title.toLowerCase().contains('visit') ||
        event.title.toLowerCase().contains('stay') ||
        event.title.toLowerCase().contains('weekend')) {
      return Icons.home;
    } else {
      return Icons.event;
    }
  }
}
