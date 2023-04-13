class Problem {
  String section;
  String places;
  String description;
  String imageUrl;
  String userUid;
  bool isSolved;

  Problem({
    required this.section,
    required this.places,
    required this.description,
    required this.imageUrl,
    required this.userUid,
    required this.isSolved,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    var section;
    try {
      section = json['section'];
    } catch (e) {
      section = '';
    }

    var places;
    try {
      places = json['places'];
    } catch (e) {
      places = '';
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

    var userUid;
    try {
      userUid = json['userUid'];
    } catch (e) {
      userUid = '';
    }

    var isSolved;
    try {
      isSolved = json['isSolved'];
    } catch (e) {
      isSolved = false;
    }

    return Problem(
      section: section,
      places: places,
      description: description,
      imageUrl: imageUrl,
      userUid: userUid,
      isSolved: isSolved,
    );
  }
}

Problem dummyProblem = Problem(
    section: 'B',
    places: '23,24,25',
    description:
        'alguien esta estacionado en mi lugar alguien esta estacionado en mi lugar alguien esta estacionado en mi lugar alguien esta estacionado en mi lugar alguien esta estacionado en mi lugar',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/iteso-parking-3c4e8.appspot.com/o/iteso_parking%2Fphoto_2022-11-21%2014%3A11%3A58.729087.png?alt=media&token=f8ef6324-467f-4b64-84e7-125079b2b1d9',
    userUid: 'PS9nePMHXbcecHjXv0O13vMLHSx2',
    isSolved: false);
