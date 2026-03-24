class ScanEntity {
  final int? id;
  final String code;
  final DateTime timestamp;

  ScanEntity({
    this.id,
    required this.code,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'code': code,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScanEntity.fromMap(Map<String, dynamic> map) {
    return ScanEntity(
      id: map['id'] as int?,
      code: map['code'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}

