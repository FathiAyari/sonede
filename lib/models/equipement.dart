class Equipement {
  String label;
  double pricePerDay;

  Equipement({
    required this.label,
    required this.pricePerDay,
  });

  factory Equipement.fromJson(Map<String, dynamic> json) {
    return Equipement(
      label: json['label'],
      pricePerDay: json['pricePerDay'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'pricePerDay': pricePerDay,
    };
  }
}
