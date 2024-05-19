class Umbrella {
  String idUmbrella;
  num price;
  int index;

  Umbrella({required this.idUmbrella, required this.index, required this.price});

  Map<String, dynamic> toJson() {
    return {
      'idUmbrella': idUmbrella,
      'price': price,
      'index': index,
    };
  }

  factory Umbrella.fromJson(Map<String, dynamic> json) {
    return Umbrella(price: json['price'], idUmbrella: json['idUmbrella'], index: json['index']);
  }
}
