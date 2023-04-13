class Car {
  String manufacturer;
  String model;
  int capacity;
  String plates;
  String imageUrl;
  bool isActive;

  Car({
    required this.manufacturer,
    required this.model,
    required this.capacity,
    required this.plates,
    required this.imageUrl,
    required this.isActive,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    var manufacturer;
    try {
      manufacturer = json['manufacturer'];
    } catch (e) {
      manufacturer = '';
    }

    var model;
    try {
      model = json['model'];
    } catch (e) {
      model = '';
    }

    var capacity;
    try {
      capacity = json['capacity'];
    } catch (e) {
      capacity = 0;
    }

    var plates;
    try {
      plates = json['plates'];
    } catch (e) {
      plates = '';
    }

    var imageUrl;
    try {
      imageUrl = json['imageUrl'];
    } catch (e) {
      imageUrl = '';
    }

    var isActive;
    try {
      isActive = json['isActive'];
    } catch (e) {
      isActive = '';
    }

    return Car(
      manufacturer: manufacturer,
      model: model,
      capacity: capacity,
      plates: plates,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }
}

// Car myCar = Car(
//   manufacturer: 'Kia',
//   model: 'Forte',
//   capacity: 5,
//   plates: 'abc12345',
// );

// Car myCar2 = Car(
//   manufacturer: 'Honda',
//   model: 'Accord',
//   capacity: 5,
//   plates: 'jak12345',
// );
