class Section {
  int id_sections;
  String sectionName;
  String mapsURL;
  String imageURL;
  int isActive;

  Section({
    required this.id_sections,
    required this.sectionName,
    required this.mapsURL,
    required this.imageURL,
    required this.isActive,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id_sections: json['id_sections'] ?? 0,
      sectionName: json['sectionName'] ?? '',
      mapsURL: json['mapsURL'] ?? '',
      imageURL: json['imageURL'] ?? '',
      isActive: json['isActive'] ?? 0,
    );
  }
}
