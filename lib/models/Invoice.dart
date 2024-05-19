class Invoice {
  final String uid;
  final String userId;
  final String trimester;

  final DateTime date;
  final String urlPdf;

  Invoice({
    required this.uid,
    required this.userId,
    required this.date,
    required this.trimester,
    required this.urlPdf,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      uid: json['uid'],
      userId: json['userId'],
      trimester: json['trimester'],
      date: json['date'].toDate(),
      urlPdf: json['urlPdf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'trimester': trimester,
      'urlPdf': urlPdf,
    };
  }
}
