class Counter {
  final String code;
  final DateTime createdAt;

  Counter({
    required this.createdAt,
    required this.code,
  });

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(
      createdAt: json['createdAt'].toDate(),
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'code': code,
    };
  }
}
