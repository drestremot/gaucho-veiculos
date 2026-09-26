class VehicleModel {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String year;
  final String condition;
  final String category;
  final double price;
  final double? oldPrice;
  final int mileage;
  final String fuel;
  final String transmission;
  final String engine;
  final String color;
  final String plateEnd;
  final bool featured;
  final List<String> badges;
  final List<String> images;
  final List<String> features;
  final String description;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.mileage,
    required this.fuel,
    required this.transmission,
    required this.engine,
    required this.color,
    required this.plateEnd,
    required this.featured,
    required this.badges,
    required this.images,
    required this.features,
    required this.description,
  });

  bool get isNew => condition == 'novo';
}
