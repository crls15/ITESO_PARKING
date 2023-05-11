class Problem{
  int id_problem;
  int id_sections;
  String placesIdsList;
  String description;
  String imageUrl;
  int id_users;
  int isSolved;

  Problem({
    required this.id_problem,
    required this.id_sections,
    required this.placesIdsList,
    required this.description,
    required this.imageUrl,
    required this.id_users,
    required this.isSolved,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    var id_problem;
    try {
      id_problem = json['id_problem'];
    } catch (e) {
      id_problem = 0;
    }
    
    var id_sections;
    try {
      id_sections = json['id_sections'];
    } catch (e) {
      id_sections = 0;
    }

    var placesIdsList;
    try {
      placesIdsList = json['placesIdsList'];
    } catch (e) {
      placesIdsList = '';
    }

    var description;
    try {
      description = json['description'];
    } catch (e) {
      description = '';
    }

    var imageUrl;
    try {
      imageUrl = json['imageUrl'];
    } catch (e) {
      imageUrl = '';
    }

    var id_users;
    try {
      id_users = json['id_users'];
    } catch (e) {
      id_users = 0;
    }

    var isSolved;
    try {
      isSolved = json['isSolved'];
    } catch (e) {
      isSolved = 0;
    }

    return Problem(
      id_problem: id_problem,
      id_sections: id_sections,
      placesIdsList: placesIdsList,
      description: description,
      imageUrl: imageUrl,
      id_users: id_users,
      isSolved: isSolved,
    );
  }
}

