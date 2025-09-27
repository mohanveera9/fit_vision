enum TestStatus { notStarted, inProgress, completed, failed }

enum TestType {
  height,
  weight,
  pushUps,
  sitUps,
  running,
  flexibility,
}

class TestResultModel {
  final String testId;
  final String testName;
  final TestType testType;
  final int score;
  final double percentile;
  final DateTime completedAt;
  final TestStatus status;
  final Map<String, dynamic> details;
  final Duration? duration;
  final String? videoUrl;
  final String? notes;

  const TestResultModel({
    required this.testId,
    required this.testName,
    required this.testType,
    required this.score,
    required this.percentile,
    required this.completedAt,
    required this.status,
    this.details = const {},
    this.duration,
    this.videoUrl,
    this.notes,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      testId: json['testId'] as String,
      testName: json['testName'] as String,
      testType: TestType.values.firstWhere(
        (e) => e.name == json['testType'],
        orElse: () => TestType.height,
      ),
      score: json['score'] as int,
      percentile: (json['percentile'] as num).toDouble(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      status: TestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TestStatus.notStarted,
      ),
      details: json['details'] as Map<String, dynamic>? ?? {},
      duration: json['duration'] != null 
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      videoUrl: json['videoUrl'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testId': testId,
      'testName': testName,
      'testType': testType.name,
      'score': score,
      'percentile': percentile,
      'completedAt': completedAt.toIso8601String(),
      'status': status.name,
      'details': details,
      'duration': duration?.inMilliseconds,
      'videoUrl': videoUrl,
      'notes': notes,
    };
  }

  TestResultModel copyWith({
    String? testId,
    String? testName,
    TestType? testType,
    int? score,
    double? percentile,
    DateTime? completedAt,
    TestStatus? status,
    Map<String, dynamic>? details,
    Duration? duration,
    String? videoUrl,
    String? notes,
  }) {
    return TestResultModel(
      testId: testId ?? this.testId,
      testName: testName ?? this.testName,
      testType: testType ?? this.testType,
      score: score ?? this.score,
      percentile: percentile ?? this.percentile,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      details: details ?? this.details,
      duration: duration ?? this.duration,
      videoUrl: videoUrl ?? this.videoUrl,
      notes: notes ?? this.notes,
    );
  }

  bool get isCompleted => status == TestStatus.completed;
  bool get isInProgress => status == TestStatus.inProgress;
  bool get isNotStarted => status == TestStatus.notStarted;

  @override
  String toString() {
    return 'TestResultModel(testId: $testId, testName: $testName, score: $score, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestResultModel && other.testId == testId;
  }

  @override
  int get hashCode => testId.hashCode;
}
