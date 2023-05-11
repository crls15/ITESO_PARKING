class Car {
  int id_user_cars;
  int id_users;
  int isPrefered;
  String imageURL;
  int capacity;
  String manufacturer;
  String model;
  String plates;
  int isActive;

  Car({
    required this.id_user_cars,
    required this.id_users,
    required this.isPrefered,
    required this.imageURL,
    required this.capacity,
    required this.manufacturer,
    required this.model,
    required this.plates,
    required this.isActive,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id_user_cars: json['id_user_cars'] ?? 0,
      id_users: json['id_users'] ?? 0,
      isPrefered: json['isPrefered'] ?? 0,
      imageURL: json['imageURL'] ?? '',
      capacity: json['capacity'] ?? 0,
      manufacturer: json['manufacturer'] ?? '',
      model: json['model'] ?? '',
      plates: json['plates'] ?? '',
      isActive: json['isActive'] ?? 0,
    );
  }
}
