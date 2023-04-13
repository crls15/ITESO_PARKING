import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iteso_parking/place_finder/place.dart';

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
      emit(FindPlaceErrorState(error: 'Error'));
    }
  }

  Future<dynamic> _searchPlace() async {
    var user = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    var user_data_map = await user.data();

    if (user_data_map!['isParked'] == true) {
      asignedPlace = Place(
        section: user_data_map['parkedSection'],
        number: user_data_map['parkedPlace'],
        longitude: user_data_map['parkedLongitude'],
        latitude: user_data_map['parkedLatitude'],
        imageUrl: user_data_map['parkedImageUrl'],
        mapsUrl: user_data_map['parkedMapsUrl'],
      );

      return true;
    }

    var sectionsFire = await FirebaseFirestore.instance
        .collection("sections")
        .where('occupancy', isLessThan: 200)
        .get();

    var randSectionIndex = Random().nextInt(sectionsFire.docs.length - 1);

    var asignedSection = sectionsFire.docs[randSectionIndex];

    var sections_collection =
        await FirebaseFirestore.instance.collection("sections");

    var placeList_collection = await FirebaseFirestore.instance
        .collection("sections")
        .doc(asignedSection.id)
        .collection("placesList");

    var placesFire =
        await placeList_collection.where("isOccupied", isEqualTo: false).get();

    var asignedPlace_fire = placesFire.docs[0];

    var carsList_collection = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("carsList")
        .where("isActive", isEqualTo: true)
        .get();

    Map<String, dynamic> place_map = {
      'isOccupied': true,
      'occupiedBy': FirebaseAuth.instance.currentUser?.uid,
      'place': await asignedPlace_fire.data()["place"],
      'plates': await carsList_collection.docs[0].data()["plates"]
    };

    await placeList_collection.doc(asignedPlace_fire.id).update(place_map);

    var section_map = await asignedSection.data();
    section_map['occupancy']++;
    // var occupancy = section_map['occupancy'];
    // occupancy = occupancy + 1;
    // section_map['occupancy'] = occupancy;

    await sections_collection.doc(asignedSection.id).update(section_map);

    // print(asignedSection.data());
    // print(asignedPlace_fire.data());

    var user_map = await user.data();
    user_map!['isParked'] = true;
    user_map['parkedSection'] = await asignedSection.data()['section'];
    user_map['parkedPlace'] = await asignedPlace_fire.data()['place'];
    user_map['parkedLongitude'] = await asignedSection.data()['longitude'];
    user_map['parkedLatitude'] = await asignedSection.data()['latitude'];
    user_map['parkedImageUrl'] = await asignedSection.data()['imageUrl'];
    user_map['parkedMapsUrl'] = await asignedSection.data()['mapsUrl'];

    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(user_map);

    user = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    user_data_map = await user.data();

    if (user_data_map!['isParked'] == true) {
      asignedPlace = Place(
        section: user_data_map['parkedSection'],
        number: user_data_map['parkedPlace'],
        longitude: user_data_map['parkedLongitude'],
        latitude: user_data_map['parkedLatitude'],
        imageUrl: user_data_map['parkedImageUrl'],
        mapsUrl: user_data_map['parkedMapsUrl'],
      );
    }

    return true;
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
