class Notifications {
  final String userId;
  final String content;
  final DateTime date;

  Notifications({
    required this.userId,
    required this.content,
    required this.date,
  });

  // Factory constructor to create an instance from JSON
  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      userId: json['userId'],
      content: json['content'],
      date: json['date'].toDate(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
