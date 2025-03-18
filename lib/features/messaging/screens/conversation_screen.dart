import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_button.dart';
import '../providers/messaging_provider.dart';
import '../../auth/providers/auth_provider.dart';

class ConversationScreen extends StatefulWidget {
  final String participantId;

  const ConversationScreen({super.key, required this.participantId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showAttachmentOptions = false;
  List<String> _selectedAttachments = [];

  @override
  void initState() {
    super.initState();
    // Load messages when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessagingProvider>(
        context,
        listen: false,
      ).loadMessages(widget.participantId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagingProvider = Provider.of<MessagingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.currentUser?.id ?? 'current-user';
    final messages = messagingProvider.getMessagesForConversation(
      currentUserId,
      widget.participantId,
    );
    final participant = messagingProvider.getParticipant(widget.participantId);

    // Scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            AppAvatar(
              imageUrl: participant?.imageUrl,
              name: participant?.name ?? 'Co-Parent',
              size: 40,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant?.name ?? 'Co-Parent',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  participant?.isOnline ?? false ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: participant?.isOnline ?? false
                        ? AppColors.secondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              // TODO: Implement audio call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showConversationOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessagesList(messages, currentUserId),
          ),

          // Attachment preview
          if (_selectedAttachments.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.background,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _selectedAttachments.map((attachment) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.insert_drive_file,
                              color: AppColors.textSecondary,
                              size: 32,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAttachments.remove(attachment);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(13),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Attachment options
          if (_showAttachmentOptions)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.photo,
                    label: 'Photos',
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Implement photo attachment
                      setState(() {
                        _showAttachmentOptions = false;
                        // Simulate adding an attachment
                        _selectedAttachments.add('photo.jpg');
                      });
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    color: Colors.green,
                    onTap: () {
                      // TODO: Implement camera attachment
                      setState(() {
                        _showAttachmentOptions = false;
                      });
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    color: Colors.orange,
                    onTap: () {
                      // TODO: Implement document attachment
                      setState(() {
                        _showAttachmentOptions = false;
                        // Simulate adding an attachment
                        _selectedAttachments.add('document.pdf');
                      });
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.location_on,
                    label: 'Location',
                    color: Colors.red,
                    onTap: () {
                      // TODO: Implement location attachment
                      setState(() {
                        _showAttachmentOptions = false;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _showAttachmentOptions ? Icons.close : Icons.attach_file,
                      color: _showAttachmentOptions
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _showAttachmentOptions = !_showAttachmentOptions;
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle:
                            const TextStyle(color: AppColors.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: 5,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _messageController.text.trim().isEmpty &&
                          _selectedAttachments.isEmpty
                      ? IconButton(
                          icon: const Icon(Icons.mic, color: AppColors.primary),
                          onPressed: () {
                            // TODO: Implement voice message
                          },
                        )
                      : IconButton(
                          icon:
                              const Icon(Icons.send, color: AppColors.primary),
                          onPressed: () {
                            _sendMessage(messagingProvider, currentUserId);
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'Start the conversation by sending a message',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<MessageModel> messages, String currentUserId) {
    // Group messages by date
    final groupedMessages = <String, List<MessageModel>>{};
    for (final message in messages) {
      final date = _formatMessageDate(message.timestamp);
      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(message);
    }

    final sortedDates = groupedMessages.keys.toList()
      ..sort((a, b) => _parseDate(a).compareTo(_parseDate(b)));

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final messagesForDate = groupedMessages[date]!;

        return Column(
          children: [
            // Date header
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'date',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Messages for this date
            ...messagesForDate.map((message) {
              final isCurrentUser = message.senderId == currentUserId;
              return _buildMessageBubble(message, isCurrentUser);
            }),
          ],
        );
      },
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isCurrentUser) {
    final time = DateFormat('h:mm a').format(message.timestamp);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Message content
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isCurrentUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isCurrentUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    message.content,
                    style: TextStyle(
                      color:
                          isCurrentUser ? Colors.white : AppColors.textPrimary,
                    ),
                  ),

                  // Message attachments
                  if (message.attachments != null &&
                      message.attachments!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: message.attachments!.map((attachment) {
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.insert_drive_file,
                                color: AppColors.textSecondary,
                                size: 32,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),

            // Message time
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (isCurrentUser)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        message.isRead ? Icons.done_all : Icons.done,
                        size: 14,
                        color: message.isRead
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _sendMessage(MessagingProvider messagingProvider, String currentUserId) {
    final messageText = _messageController.text.trim();

    if (messageText.isNotEmpty || _selectedAttachments.isNotEmpty) {
      final newMessage = MessageModel(
        senderId: currentUserId,
        receiverId: widget.participantId,
        content: messageText,
        attachments:
            _selectedAttachments.isNotEmpty ? _selectedAttachments : null,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
        type: MessageType.text,
      );

      messagingProvider.sendMessage(newMessage);

      _messageController.clear();
      setState(() {
        _selectedAttachments = [];
        _showAttachmentOptions = false;
      });
    }
  }

  void _showConversationOptions(BuildContext context) {
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
                'Conversation Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withAlpha(30),
                  child: const Icon(Icons.search, color: AppColors.primary),
                ),
                title: const Text('Search in Conversation'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement search in conversation
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withAlpha(30),
                  child:
                      const Icon(Icons.notifications, color: AppColors.primary),
                ),
                title: const Text('Mute Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement mute notifications
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.error.withAlpha(30),
                  child: const Icon(Icons.delete, color: AppColors.error),
                ),
                title: const Text(
                  'Delete Conversation',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: const Text(
            'Are you sure you want to delete this conversation? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            AppButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement delete conversation
                Navigator.pop(context); // Return to messages list
              },
              text: 'Delete',
              type: AppButtonType.error,
              width: 100,
              height: 40,
            ),
          ],
        );
      },
    );
  }

  // Helper methods
  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(messageDate).inDays < 7) {
      // Format as day of week (e.g., "Monday")
      return DateFormat('EEEE').format(date);
    } else {
      // Format as date (e.g., "January 15, 2023")
      return DateFormat('MMMM d, y').format(date);
    }
  }

  DateTime _parseDate(String formattedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (formattedDate == 'Today') {
      return today;
    } else if (formattedDate == 'Yesterday') {
      return yesterday;
    } else if (formattedDate.contains(',')) {
      // Parse "January 15, 2023" format
      return DateFormat('MMMM d, y').parse(formattedDate);
    } else {
      // Parse day of week (e.g., "Monday")
      // Find the most recent occurrence of this day
      final dayOfWeek = DateFormat('EEEE').parse(formattedDate).weekday;
      var date = today;
      while (date.weekday != dayOfWeek) {
        date = date.subtract(const Duration(days: 1));
      }
      return date;
    }
  }
}
