class Place {
  int id_places;
  int id_sections;
  int placeNumber;
  int isOccupied;
  int id_users_occupiedBy;
  int isAutoAssigned;
  int isActive;

  Place({
    required this.id_places,
    required this.id_sections,
    required this.placeNumber,
    required this.isOccupied,
    required this.id_users_occupiedBy,
    required this.isAutoAssigned,
    required this.isActive,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id_places: json['id_places'] ?? 0,
      id_sections: json['id_sections'] ?? 0,
      placeNumber: json['placeNumber'] ?? 0,
      isOccupied: json['isOccupied'] ?? 0,
      id_users_occupiedBy: json['id_users_occupiedBy'] ?? 0,
      isAutoAssigned: json['isAutoAssigned'] ?? 0,
      isActive: json['isActive'] ?? 0,
    );
  }
}
