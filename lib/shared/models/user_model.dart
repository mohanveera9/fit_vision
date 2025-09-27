class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final int age;
  final String gender;
  final String league;
  final DateTime memberSince;
  final String? profileImageUrl;
  final String? aadhaarNumber;
  final bool isVerified;
  final Map<String, dynamic> preferences;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.league,
    required this.memberSince,
    this.profileImageUrl,
    this.aadhaarNumber,
    this.isVerified = false,
    this.preferences = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      league: json['league'] as String,
      memberSince: DateTime.parse(json['memberSince'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender,
      'league': league,
      'memberSince': memberSince.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'aadhaarNumber': aadhaarNumber,
      'isVerified': isVerified,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    int? age,
    String? gender,
    String? league,
    DateTime? memberSince,
    String? profileImageUrl,
    String? aadhaarNumber,
    bool? isVerified,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      league: league ?? this.league,
      memberSince: memberSince ?? this.memberSince,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      isVerified: isVerified ?? this.isVerified,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, age: $age, gender: $gender, league: $league)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
