/// User model representing a parent in the co-parenting app
class UserModel {
  /// Static property to store the current user's ID
  static String? currentUserId;

  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? phoneNumber;
  final UserRole role;
  final List<String> childrenIds;
  final String? familyId;
  final Map<String, dynamic>? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// A getter for fullName that returns the name
  String get fullName => name;

  /// A getter for profile image URL
  String? get imageUrl => profileImageUrl;

  /// A getter to check if the user is online (mock implementation)
  bool get isOnline => true; // TODO: Implement actual online status tracking

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phoneNumber,
    this.role = UserRole.parent,
    this.childrenIds = const [],
    this.familyId,
    this.preferences,
    required this.createdAt,
    DateTime? updatedAt,
  }) : this.updatedAt = updatedAt ?? createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
      phoneNumber: json['phone_number'],
      role: UserRole.values.firstWhere(
        (role) => role.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.parent,
      ),
      childrenIds: List<String>.from(json['children_ids'] ?? []),
      familyId: json['family_id'],
      preferences: json['preferences'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
      'phone_number': phoneNumber,
      'role': role.toString().split('.').last,
      'children_ids': childrenIds,
      'family_id': familyId,
      'preferences': preferences,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? phoneNumber,
    UserRole? role,
    List<String>? childrenIds,
    String? familyId,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      childrenIds: childrenIds ?? this.childrenIds,
      familyId: familyId ?? this.familyId,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum representing the role of a user in the co-parenting app
enum UserRole {
  parent,
  guardian,
  familyMember,
  professional,
  admin,
}
