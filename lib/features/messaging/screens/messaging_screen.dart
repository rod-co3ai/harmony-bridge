import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_search_field.dart';
import '../providers/messaging_provider.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  int _currentNavIndex = 2;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load conversations when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessagingProvider>(
        context,
        listen: false,
      ).loadConversations();
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagingProvider = Provider.of<MessagingProvider>(context);
    final filteredConversations = _filterConversations(
      messagingProvider.conversations,
      _searchQuery,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppSearchField(
              controller: _searchController,
              hintText: 'Search messages...',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onClear: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
          ),

          // Conversations list
          Expanded(
            child: messagingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredConversations.isEmpty
                    ? _buildEmptyState()
                    : _buildConversationsList(filteredConversations),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewMessageDialog(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 64,
            color: AppColors.textSecondary.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No conversations yet'
                : 'No conversations matching "$_searchQuery"',
            style:
                const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton(
                onPressed: () {
                  _searchController.clear();
                },
                child: const Text('Clear Search'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(List<ConversationModel> conversations) {
    return RefreshIndicator(
      onRefresh: () => Provider.of<MessagingProvider>(
        context,
        listen: false,
      ).refreshConversations(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: conversations.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return _buildConversationTile(conversation);
        },
      ),
    );
  }

  Widget _buildConversationTile(ConversationModel conversation) {
    final formattedTime = _formatMessageTime(conversation.lastMessageTime);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      leading: Stack(
        children: [
          AppAvatar(
            imageUrl: conversation.participantImageUrl,
            name: conversation.participantName,
            size: 56,
          ),
          if (conversation.unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              conversation.participantName,
              style: TextStyle(
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 12,
              color: conversation.unreadCount > 0
                  ? AppColors.primary
                  : AppColors.textSecondary,
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              if (conversation.lastMessageSenderId != 'current-user')
                const SizedBox(width: 0)
              else
                const Row(
                  children: [
                    Text(
                      'You: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 2),
                  ],
                ),
              Expanded(
                child: Text(
                  conversation.lastMessageText,
                  style: TextStyle(
                    color: conversation.unreadCount > 0
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: conversation.unreadCount > 0
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (conversation.lastMessageHasAttachment)
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.attachment,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.conversation,
          arguments: conversation.participantId,
        );
      },
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
      case 2: // Messages - already here
        break;
      case 3: // Profile
        Navigator.pushReplacementNamed(context, AppRouter.profile);
        break;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Messages'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: Implement filters
              Text('Filter options will be implemented here'),
            ],
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
                Navigator.pop(context);
                // TODO: Apply filters
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _showNewMessageDialog(BuildContext context) {
    // TODO: Implement new message dialog with contact selection
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Message'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('Contact selection will be implemented here')],
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
                Navigator.pop(context);
                // TODO: Navigate to conversation screen with selected contact
              },
              child: const Text('Start Chat'),
            ),
          ],
        );
      },
    );
  }

  // Helper methods
  List<ConversationModel> _filterConversations(
    List<ConversationModel> conversations,
    String query,
  ) {
    if (query.isEmpty) {
      return conversations;
    }

    final lowerCaseQuery = query.toLowerCase();
    return conversations.where((conversation) {
      return conversation.participantName.toLowerCase().contains(
                lowerCaseQuery,
              ) ||
          conversation.lastMessageText.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      // Format as time (e.g., "3:30 PM")
      final hour =
          time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(time).inDays < 7) {
      // Format as day of week (e.g., "Mon")
      return _getDayOfWeek(time);
    } else {
      // Format as date (e.g., "Jan 15")
      return '${_getMonth(time)} ${time.day}';
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
}
