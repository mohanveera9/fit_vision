class LeaderboardEntry {
  final int rank;
  final String userId;
  final String userName;
  final String? profileImageUrl;
  final int totalScore;
  final String league;
  final int age;
  final String gender;
  final DateTime lastUpdated;
  final Map<String, int> testScores;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    this.profileImageUrl,
    required this.totalScore,
    required this.league,
    required this.age,
    required this.gender,
    required this.lastUpdated,
    this.testScores = const {},
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      totalScore: json['totalScore'] as int,
      league: json['league'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      testScores: (json['testScores'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'totalScore': totalScore,
      'league': league,
      'age': age,
      'gender': gender,
      'lastUpdated': lastUpdated.toIso8601String(),
      'testScores': testScores,
    };
  }

  LeaderboardEntry copyWith({
    int? rank,
    String? userId,
    String? userName,
    String? profileImageUrl,
    int? totalScore,
    String? league,
    int? age,
    String? gender,
    DateTime? lastUpdated,
    Map<String, int>? testScores,
  }) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      totalScore: totalScore ?? this.totalScore,
      league: league ?? this.league,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      testScores: testScores ?? this.testScores,
    );
  }

  String get rankDisplay {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }

  String get leagueDisplayName {
    switch (league.toLowerCase()) {
      case 'junior':
        return 'Junior (12-17)';
      case 'youth':
        return 'Youth (18-25)';
      case 'senior':
        return 'Senior (26-35)';
      default:
        return league;
    }
  }

  @override
  String toString() {
    return 'LeaderboardEntry(rank: $rank, userName: $userName, totalScore: $totalScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardEntry && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}

class LeaderboardCategory {
  final String id;
  final String name;
  final String league;
  final String gender;
  final List<LeaderboardEntry> entries;
  final DateTime lastUpdated;
  final int totalParticipants;

  const LeaderboardCategory({
    required this.id,
    required this.name,
    required this.league,
    required this.gender,
    required this.entries,
    required this.lastUpdated,
    required this.totalParticipants,
  });

  factory LeaderboardCategory.fromJson(Map<String, dynamic> json) {
    return LeaderboardCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      league: json['league'] as String,
      gender: json['gender'] as String,
      entries: (json['entries'] as List)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      totalParticipants: json['totalParticipants'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'league': league,
      'gender': gender,
      'entries': entries.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'totalParticipants': totalParticipants,
    };
  }

  String get displayName => '$league - $gender';
}
