class Place {
  String section;
  int number;
  double longitude;
  double latitude;
  String imageUrl;
  String mapsUrl;

  Place({
    required this.section,
    required this.number,
    required this.longitude,
    required this.latitude,
    required this.imageUrl,
    required this.mapsUrl,
  });
}

Place dummyPlace = Place(
  section: 'B',
  number: 022,
  longitude: 20.608530,
  latitude: -103.417209,
  imageUrl: "",
  mapsUrl: "",
);
