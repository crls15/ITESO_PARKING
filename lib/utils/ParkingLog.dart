class ParkingLog {
  int id_parking_logs;
  int id_users;
  int id_user_cars;
  int id_places;
  int isParked;
  DateTime checkIn;
  DateTime checkOut;
  int isActive;

  ParkingLog({
    required this.id_parking_logs,
    required this.id_users,
    required this.id_user_cars,
    required this.id_places,
    required this.isParked,
    required this.checkIn,
    required this.checkOut,
    required this.isActive,
  });

  factory ParkingLog.fromJson(Map<String, dynamic> json) {
    return ParkingLog(
      id_parking_logs: json['id_parking_logs'] ?? 0,
      id_users: json['id_users'] ?? 0,
      id_user_cars: json['id_user_cars'] ?? 0,
      id_places: json['id_places'] ?? 0,
      isParked: json['isParked'] ?? 0,
      checkIn: DateTime.tryParse(json['checkIn'] ?? '') ?? DateTime(0),
      checkOut: DateTime.tryParse(json['checkOut'] ?? '') ?? DateTime(0),
      isActive: json['isActive'] ?? 0,
    );
  }
}
