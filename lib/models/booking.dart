class Booking {
  DateTime startDate;
  DateTime DepositDate;
  DateTime endDate;
  int sofa;
  int bed;
  String umbrellaId;
  num totalPrice;
  String clientId;
  String id;
  int status;

  Booking({
    required this.startDate,
    required this.status,
    required this.id,
    required this.clientId,
    required this.DepositDate,
    required this.endDate,
    required this.sofa,
    required this.bed,
    required this.umbrellaId,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      startDate: json['startDate'].toDate(),
      endDate: json['endDate'].toDate(),
      DepositDate: json['DepositDate'].toDate(),
      umbrellaId: json['umbrellaId'],
      id: json['id'],
      sofa: json['sofa'],
      bed: json['bed'],
      status: json['status'],
      clientId: json['clientId'],
      totalPrice: json['totalPrice'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'status': status,
      'endDate': endDate,
      'clientId': clientId,
      'sofa': sofa,
      'bed': bed,
      'id': id,
      'DepositDate': DepositDate,
      'umbrellaId': umbrellaId,
      'totalPrice': totalPrice,
    };
  }
}
