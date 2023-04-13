import 'package:iteso_parking/profile/car.dart';

class Profile {
  String name;
  String userNumber;
  String userType;
  List<Car> carsList;

  Profile({
    required this.name,
    required this.userNumber,
    required this.userType,
    required this.carsList,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    var name;
    try {
      name = json['name'];
    } catch (e) {
      name = '';
    }

    var userNumber;
    try {
      userNumber = json['userNumber'];
    } catch (e) {
      userNumber = '';
    }

    var userType;
    try {
      userType = json['userType'];
    } catch (e) {
      userType = '';
    }

    List<Car> carsList = [];

    return Profile(
      name: name,
      userNumber: userNumber,
      userType: userType,
      carsList: carsList,
    );
  }
}

// Profile studentTestProfile = Profile(
//   name: "Carlos Flores",
//   userNumber: "is727635",
//   userType: "Student",
//   carsList: [myCar, myCar2],
// );
