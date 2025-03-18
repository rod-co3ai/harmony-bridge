import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/child_model.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/profile_provider.dart';

class ChildProfileScreen extends StatefulWidget {
  final String childId;

  const ChildProfileScreen({
    super.key,
    required this.childId,
  });

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  late ChildModel? child;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  Future<void> _loadChildData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch child data using the provider
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.loadChildDetails(widget.childId);
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    child = profileProvider.getChildById(widget.childId);
    
    if (isLoading || child == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Child Profile'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(child!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRouter.editChild,
                arguments: {'childId': child!.id},
              );
            },
          ),
        ],
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Child profile header
                  _buildChildHeader(child!),
                  
                  const SizedBox(height: 24),
                  
                  // Child details
                  _buildChildDetails(child!),
                  
                  const SizedBox(height: 24),
                  
                  // Child schedule
                  _buildChildSchedule(child!),
                  
                  const SizedBox(height: 24),
                  
                  // Child notes
                  _buildChildNotes(child!),
                ],
              ),
            ),
    );
  }
  
  Widget _buildChildHeader(ChildModel child) {
    return AppCard(
      child: Column(
        children: [
          const SizedBox(height: 16),
          
          // Child avatar
          AppAvatar(
            imageUrl: child.profileImageUrl,
            name: child.name,
            size: 100,
            borderColor: AppColors.primary,
            borderWidth: 3,
          ),
          
          const SizedBox(height: 16),
          
          // Child name
          Text(
            child.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Child age
          Text(
            '${child.age} years old',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildChildDetails(ChildModel child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        AppCard(
          child: Column(
            children: [
              _buildDetailItem(
                icon: Icons.cake_outlined,
                title: 'Date of Birth',
                value: '${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}',
              ),
              const Divider(),
              if (child.schoolName != null && child.schoolName!.isNotEmpty) ...[
                _buildDetailItem(
                  icon: Icons.school_outlined,
                  title: 'School',
                  value: child.schoolName!,
                ),
                const Divider(),
              ],
              if (child.schoolInfo != null && child.schoolInfo!.isNotEmpty) ...[
                _buildDetailItem(
                  icon: Icons.school_outlined,
                  title: 'School Information',
                  value: child.schoolInfo!,
                ),
                const Divider(),
              ],
              if (child.healthInfo != null && 
                  child.healthInfo!.containsKey('allergies') && 
                  child.healthInfo!['allergies'] != null) ...[
                _buildDetailItem(
                  icon: Icons.health_and_safety_outlined,
                  title: 'Allergies',
                  value: child.healthInfo!['allergies'].toString(),
                ),
                const Divider(),
              ],
              if (child.medicalInfo != null && child.medicalInfo!.isNotEmpty) ...[
                _buildDetailItem(
                  icon: Icons.medical_information_outlined,
                  title: 'Medical Information',
                  value: child.medicalInfo!,
                ),
                const Divider(),
              ],
              _buildDetailItem(
                icon: Icons.calendar_today_outlined,
                title: 'Added on',
                value: '${child.createdAt.day}/${child.createdAt.month}/${child.createdAt.year}',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildChildSchedule(ChildModel child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Schedule',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        if (child.schedule != null && child.schedule!.isNotEmpty)
          AppCard(
            child: Column(
              children: [
                for (final entry in child.schedule!.entries)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final activity in entry.value)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(activity),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (entry.key != child.schedule!.keys.last)
                        const Divider(),
                    ],
                  ),
              ],
            ),
          )
        else
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No schedule available',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildChildNotes(ChildModel child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        AppCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child.notes != null && child.notes!.isNotEmpty
                ? Text(child.notes!)
                : Text(
                    'No notes available',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
