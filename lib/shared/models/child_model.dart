/// Child model representing a child in the co-parenting app
class ChildModel {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String? profileImageUrl;
  final List<String> parentIds;
  final String? schoolName;
  final Map<String, dynamic>? healthInfo;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? activities;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final Map<String, List<String>>? schedule;
  final String? medicalInfo;
  final String? schoolInfo;

  ChildModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    this.profileImageUrl,
    required this.parentIds,
    this.schoolName,
    this.healthInfo,
    this.preferences,
    this.activities,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.schedule,
    this.medicalInfo,
    this.schoolInfo,
  });

  /// Calculate the age of the child in years
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Get the child's school name
  String? get school => schoolName;

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'],
      name: json['name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      profileImageUrl: json['profile_image_url'],
      parentIds: List<String>.from(json['parent_ids'] ?? []),
      schoolName: json['school_name'],
      healthInfo: json['health_info'],
      preferences: json['preferences'],
      activities: json['activities'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      notes: json['notes'],
      schedule: json['schedule'] != null
          ? Map<String, List<String>>.from(
              json['schedule'].map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
            )
          : null,
      medicalInfo: json['medical_info'],
      schoolInfo: json['school_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'profile_image_url': profileImageUrl,
      'parent_ids': parentIds,
      'school_name': schoolName,
      'health_info': healthInfo,
      'preferences': preferences,
      'activities': activities,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'notes': notes,
      'schedule': schedule,
      'medical_info': medicalInfo,
      'school_info': schoolInfo,
    };
  }

  ChildModel copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    List<String>? parentIds,
    String? schoolName,
    Map<String, dynamic>? healthInfo,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? activities,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    Map<String, List<String>>? schedule,
    String? medicalInfo,
    String? schoolInfo,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      parentIds: parentIds ?? this.parentIds,
      schoolName: schoolName ?? this.schoolName,
      healthInfo: healthInfo ?? this.healthInfo,
      preferences: preferences ?? this.preferences,
      activities: activities ?? this.activities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      schedule: schedule ?? this.schedule,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      schoolInfo: schoolInfo ?? this.schoolInfo,
    );
  }
}
