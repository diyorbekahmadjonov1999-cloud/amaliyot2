class CarBrand {
  final int id;
  final String name;

  CarBrand({required this.id, required this.name});

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
