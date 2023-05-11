class User {
  int id_users;
  String firebase_id;
  int id_user_type;
  String userName;
  String email;
  String userNumber;
  int isActive;

  User(
      {required this.id_users,
      required this.firebase_id,
      required this.id_user_type,
      required this.userName,
      required this.email,
      required this.userNumber,
      required this.isActive});

  factory User.fromJson(Map<String, dynamic> json) {
    var id_users;
    try {
      id_users = json['id_users'];
    } catch (e) {
      id_users = 0;
    }

    var firebase_id;
    try {
      firebase_id = json['firebase_id'];
    } catch (e) {
      firebase_id = '';
    }

    var id_user_type;
    try {
      id_user_type = json['id_user_type'];
    } catch (e) {
      id_user_type = 0;
    }

    var userName;
    try {
      userName = json['userName'];
    } catch (e) {
      userName = '';
    }

    var email;
    try {
      email = json['email'];
    } catch (e) {
      email = '';
    }

    var userNumber;
    try {
      userNumber = json['userNumber'];
    } catch (e) {
      userNumber = '';
    }

    var isActive;
    try {
      isActive = json['isActive'];
    } catch (e) {
      isActive = 0;
    }

    return User(
      id_users: id_users,
      firebase_id: firebase_id,
      id_user_type: id_user_type,
      userName: userName,
      email: email,
      userNumber: userNumber,
      isActive: isActive,
    );
  }
}
