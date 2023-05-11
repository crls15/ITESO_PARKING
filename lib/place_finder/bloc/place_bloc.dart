import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iteso_parking/place_finder/place.dart';
import 'package:iteso_parking/utils/Section.dart';
import 'package:mysql1/mysql1.dart';

import '../../utils/Place.dart' as utilsPlace;
import '../../utils/db_conn.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceBloc() : super(PlaceInitial()) {
    on<FindPlaceEvent>(_findPlace);
    on<LeavePlaceEvent>(_leavePlace);
    on<GetAvailabilityPlaceEvent>(_getAvailability);
  }

  Place? asignedPlace;
  double? availabilityPercentage = 100;

  Future<void> _findPlace(event, emit) async {
    emit(FindPlaceLoadingState());

    var placeFinded = await _searchPlace();
    print(asignedPlace?.section);

    if (placeFinded == true) {
      emit(FindPlaceSuccessState());
    } else {
      emit(FindPlaceNotParkedState());
    }
  }

  Future<dynamic> _searchPlace() async {
    String? firebase_id = FirebaseAuth.instance.currentUser?.uid;
    MySqlConnection? dbConnection = await DatabaseProvider().connection;

    String queryParkingLog = '''
                    SELECT 
                    parking_logs.id_parking_logs AS id_parking_logs,
                    parking_logs.id_places AS id_places
                    FROM users
                    INNER JOIN parking_logs
                    ON parking_logs.id_users = users.id_users
                    WHERE parking_logs.isActive = 1
                    AND users.firebase_id = "${firebase_id}"
                  ''';

    var serRes_queryParkingLog = await dbConnection?.query(queryParkingLog);

    if (serRes_queryParkingLog!.isNotEmpty) {
      var asignedPlaceId = serRes_queryParkingLog.first.fields['id_places'];

      String queryPlace = '''
                    SELECT *
                    FROM places
                    WHERE places.id_places = "${asignedPlaceId}"
                  ''';

      var serRes_queryPlace = await dbConnection?.query(queryPlace);

      utilsPlace.Place asignedPlaceUtils =
          new utilsPlace.Place.fromJson(serRes_queryPlace!.first.fields);

      String querySection = '''
                    SELECT *
                    FROM sections
                    WHERE sections.id_sections = "${asignedPlaceUtils.id_sections}"
                  ''';

      var serRes_querySection = await dbConnection?.query(querySection);

      Section asignedSectionUtils =
          new Section.fromJson(serRes_querySection!.first.fields);

      asignedPlace = Place(
        section: asignedSectionUtils.sectionName,
        number: asignedPlaceUtils.placeNumber,
        longitude: 0.0,
        latitude: 0.0,
        imageUrl: asignedSectionUtils.imageURL,
        mapsUrl: asignedSectionUtils.mapsURL,
      );

      return true;
    } else {
      return false;
    } 


    /*else {
      String queryFindPlace = '''
                                  SELECT
                                  sections.id_sections AS id_sections,
                                  places.id_places AS id_places
                                  FROM user_favorite_sections
                                  INNER JOIN users ON users.id_users = user_favorite_sections.id_users
                                  INNER JOIN sections ON sections.id_sections = user_favorite_sections.id_sections
                                  INNER JOIN places ON places.id_sections = sections.id_sections
                                  WHERE users.firebase_id = ${firebase_id}
                                      AND places.isOccupied = 0
                                  ORDER BY sections.sectionName ASC, places.placeNumber ASC
                                  LIMIT 1
                                ''';

      var serRes_queryFindPlace = await dbConnection?.query(queryFindPlace);

      if (serRes_queryFindPlace!.isEmpty) {
        String queryFindPlace = '''
                                    SELECT 
                                    sections.id_sections AS id_sections,
                                    places.id_places AS id_places
                                    FROM places
                                    INNER JOIN sections
                                    ON sections.id_sections = places.id_sections
                                    WHERE places.isOccupied = 0
                                    ORDER BY sections.sectionName ASC, places.placeNumber ASC
                                    LIMIT 1
                                  ''';

        var serRes_queryFindPlace = await dbConnection?.query(queryFindPlace);
      }

      var asignedPlaceId = serRes_queryFindPlace.first.fields['id_places'];
      var asignedSectionId = serRes_queryFindPlace.first.fields['id_sections'];

      String queryPlace = '''
                    SELECT *
                    FROM places
                    WHERE places.id_places = "${asignedPlaceId}"
                  ''';

      var serRes_queryPlace = await dbConnection?.query(queryPlace);

      utilsPlace.Place asignedPlaceUtils =
          new utilsPlace.Place.fromJson(serRes_queryPlace!.first.fields);

      String querySection = '''
                    SELECT *
                    FROM sections
                    WHERE sections.id_sections = "${asignedPlaceUtils.id_sections}"
                  ''';

      var serRes_querySection = await dbConnection?.query(querySection);

      Section asignedSectionUtils =
          new Section.fromJson(serRes_querySection!.first.fields);

      asignedPlace = Place(
        section: asignedSectionUtils.sectionName,
        number: asignedPlaceUtils.placeNumber,
        longitude: 0.0,
        latitude: 0.0,
        imageUrl: asignedSectionUtils.imageURL,
        mapsUrl: asignedSectionUtils.mapsURL,
      );

      String queryInsertParkingLogs = '''
                                      INSERT INTO parking_logs (id_users, id_user_cars, id_places, checkIn, isActive)
                                      VALUES (1, 1, 1, NOW(), 1);
                                    ''';

      return true;
    }*/
  }

  Future<void> _leavePlace(event, emit) async {
    emit(LeavePlaceLoadingState());

    var placeLeaved = await _checkoutPlace();
    print(asignedPlace?.section);

    if (placeLeaved == 'done') {
      emit(LeavePlaceSuccessState());
    } else if (placeLeaved == 'not_parked') {
      emit(LeavePlaceNotParkedState());
    } else {
      emit(LeavePlaceErrorState(error: 'Error'));
    }
  }

  Future<dynamic> _checkoutPlace() async {
    try {
      var user = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      var user_data_map = await user.data();

      if (user_data_map!['isParked'] == false) {
        return 'not_parked';
      }

      var sections_collection = await FirebaseFirestore.instance
          .collection("sections")
          .where('section', isEqualTo: user_data_map['parkedSection'])
          .get();

      var placesList_collection = await FirebaseFirestore.instance
          .collection("sections")
          .doc(sections_collection.docs[0].id)
          .collection('placesList')
          .where('occupiedBy',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      var user_section = sections_collection.docs[0];
      var user_place = placesList_collection.docs[0];

      var user_placeDoc = await FirebaseFirestore.instance
          .collection("sections")
          .doc(sections_collection.docs[0].id)
          .collection('placesList')
          .doc(placesList_collection.docs[0].id);

      Map<String, dynamic> place_map = await user_place.data();

      place_map['isOccupied'] = false;
      place_map['occupiedBy'] = '';
      place_map['plates'] = '';

      user_placeDoc.update(place_map);

      var user_sectionDoc = await FirebaseFirestore.instance
          .collection("sections")
          .doc(sections_collection.docs[0].id);

      Map<String, dynamic> section_map = await user_section.data();

      section_map['occupancy'] -= 1;

      user_sectionDoc.update(section_map);

      var user_map = await user.data();
      user_map!['isParked'] = false;
      user_map['parkedSection'] = "";
      user_map['parkedPlace'] = 0;
      user_map['parkedLongitude'] = 0;
      user_map['parkedLatitude'] = 0;
      user_map['parkedImageUrl'] = "";
      user_map['parkedMapsUrl'] = "";

      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(user_map);

      asignedPlace = null;

      return 'done';
    } catch (e) {
      return 'error';
    }
  }

  Future<void> _getAvailability(event, emit) async {
    emit(GetAvailabilityLoadingState());

    var placeFinded = await _availabilityGetter();
    print(asignedPlace?.section);

    if (placeFinded == true) {
      emit(GetAvailabilitySuccessState());
    } else {
      emit(GetAvailabilityErrorState());
    }
  }

  Future<dynamic> _availabilityGetter() async {
    var sectionsFire =
        await FirebaseFirestore.instance.collection("sections").get();

    int totalCapacity = 0;
    int totalOccupancy = 0;

    for (var doc in sectionsFire.docs) {
      int docCapacity = await doc.data()['capacity'];
      int docOccupancy = await doc.data()['occupancy'];

      totalCapacity += docCapacity;
      totalOccupancy += docOccupancy;
    }

    availabilityPercentage = totalOccupancy * 100 / totalCapacity;

    return true;
  }
}
