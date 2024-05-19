class Reclamation {
  final String uid;
  final String userId;
  final String content;
  final DateTime date;
  final String counterId;
  final int status;

  Reclamation({
    required this.uid,
    required this.userId,
    required this.content,
    required this.date,
    required this.counterId,
    required this.status,
  });

  // Factory constructor to create an instance from a JSON map
  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      uid: json['uid'],
      userId: json['userId'],
      content: json['content'],
      date: json['date'].toDate(),
      counterId: json['counterId'],
      status: json['status'],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'content': content,
      'date': date.toIso8601String(),
      'counterId': counterId,
      'status': status,
    };
  }
}
