import 'package:flutter/material.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/models/child_model.dart';

/// Provider for profile-related state and operations
class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  UserModel? _userProfile;
  List<ChildModel> _children = [];
  final Map<String, ChildModel> _childDetails = {};

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get userProfile => _userProfile;
  List<ChildModel> get children => _children;

  /// Get a child by ID
  ChildModel? getChildById(String childId) {
    // First check if we have detailed data for this child
    if (_childDetails.containsKey(childId)) {
      return _childDetails[childId];
    }

    // Otherwise check the children list
    try {
      final child = _children.firstWhere((child) => child.id == childId);
      return child;
    } catch (e) {
      // Return a placeholder child if not found
      return null;
    }
  }

  /// Load detailed information for a specific child
  Future<void> loadChildDetails(String childId) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual data fetching from Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Check if the child exists in our list
      final existingChild = _children.firstWhere(
        (child) => child.id == childId,
        orElse:
            () => ChildModel(
              id: childId,
              name: 'Unknown Child',
              dateOfBirth: DateTime.now(),
              parentIds: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      );

      // For now, we'll just add more detailed mock data
      final detailedChild = existingChild.copyWith(
        schedule: _getMockScheduleForChild(childId),
        medicalInfo: 'No known medical conditions',
        schoolInfo: 'Attends Springfield Elementary School',
        notes: existingChild.notes ?? 'No notes available',
      );

      // Store in the detailed map
      _childDetails[childId] = detailedChild;

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load child details: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Load user profile
  Future<void> loadUserProfile(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual data fetching from Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Mock data - will be replaced with actual implementation
      _userProfile = UserModel(
        id: userId,
        name: 'Jamie Smith',
        email: 'user@example.com',
        profileImageUrl: null,
        phoneNumber: '(555) 987-6543',
        role: UserRole.parent,
        childrenIds: [],
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now(),
      );

      _children = _getMockChildren();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load profile: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile(UserModel updatedProfile) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual profile update with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Update local profile
      _userProfile = updatedProfile;

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Add a child
  Future<bool> addChild(ChildModel child) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual child addition with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Add to local list
      _children.add(child);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add child: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Update a child
  Future<bool> updateChild(ChildModel updatedChild) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual child update with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Update in local list
      final index = _children.indexWhere((c) => c.id == updatedChild.id);
      if (index != -1) {
        _children[index] = updatedChild;
      } else {
        throw Exception('Child not found');
      }

      // Also update in details map if it exists
      if (_childDetails.containsKey(updatedChild.id)) {
        _childDetails[updatedChild.id] = updatedChild;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update child: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Delete a child
  Future<bool> deleteChild(String childId) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual child deletion with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Remove from local list
      _children.removeWhere((c) => c.id == childId);

      // Remove from details map
      _childDetails.remove(childId);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete child: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Update user settings
  Future<bool> updateUserSettings(Map<String, dynamic> settings) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual settings update with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Update local profile with settings
      if (_userProfile != null) {
        // In a real implementation, we would update specific settings fields
        // For now, we'll just simulate success
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update settings: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Mock data generators
  List<ChildModel> _getMockChildren() {
    final now = DateTime.now();
    return [
      ChildModel(
        id: 'child-1',
        name: 'Emma Wilson',
        dateOfBirth: DateTime(2015, 5, 12),
        profileImageUrl: null,
        parentIds: ['parent-1', 'parent-2'],
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now,
        notes: 'Loves drawing and swimming',
        schedule: _getMockScheduleForChild('child-1'),
        medicalInfo: 'No known allergies',
        schoolInfo: 'Springfield Elementary, Grade 2',
      ),
      ChildModel(
        id: 'child-2',
        name: 'Noah Wilson',
        dateOfBirth: DateTime(2018, 9, 3),
        profileImageUrl: null,
        parentIds: ['parent-1', 'parent-2'],
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now,
        notes: 'Allergic to peanuts, enjoys dinosaurs',
        schedule: _getMockScheduleForChild('child-2'),
        medicalInfo: 'Peanut allergy - carries EpiPen',
        schoolInfo: 'Little Learners Preschool',
      ),
    ];
  }

  // Mock schedule data for a child
  Map<String, List<String>> _getMockScheduleForChild(String childId) {
    if (childId == 'child-1') {
      return {
        'Monday': ['School 8am-3pm', 'Swimming 4pm-5pm'],
        'Tuesday': ['School 8am-3pm', 'Art class 4pm-5:30pm'],
        'Wednesday': ['School 8am-3pm', 'Playdate with Sarah 4pm-6pm'],
        'Thursday': ['School 8am-3pm', 'Doctor appointment 4pm'],
        'Friday': ['School 8am-3pm', 'Free time'],
        'Saturday': ['Soccer practice 10am-12pm', 'Family time'],
        'Sunday': ['Family time', 'Prepare for school week'],
      };
    } else if (childId == 'child-2') {
      return {
        'Monday': ['Preschool 9am-1pm', 'Nap time 2pm-3:30pm'],
        'Tuesday': ['Preschool 9am-1pm', 'Playdate with Max 3pm-4:30pm'],
        'Wednesday': ['Preschool 9am-1pm', 'Library storytime 3pm-4pm'],
        'Thursday': ['Preschool 9am-1pm', 'Park 3pm-4:30pm'],
        'Friday': ['Preschool 9am-1pm', 'Free time'],
        'Saturday': ['Swimming lessons 10am-11am', 'Family time'],
        'Sunday': ['Family time', 'Early bedtime 7:30pm'],
      };
    } else {
      return {
        'Monday': ['No schedule yet'],
        'Tuesday': ['No schedule yet'],
        'Wednesday': ['No schedule yet'],
        'Thursday': ['No schedule yet'],
        'Friday': ['No schedule yet'],
        'Saturday': ['No schedule yet'],
        'Sunday': ['No schedule yet'],
      };
    }
  }
}
