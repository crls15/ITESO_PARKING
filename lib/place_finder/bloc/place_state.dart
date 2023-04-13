part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object> get props => [];
}

class PlaceInitial extends PlaceState {}

class FindPlaceSuccessState extends PlaceState {
  @override
  List<Object> get props => [];
}

class FindPlaceErrorState extends PlaceState {
  final String error;

  FindPlaceErrorState({required this.error});
}

class FindPlaceLoadingState extends PlaceState {}

class LeavePlaceSuccessState extends PlaceState {}

class LeavePlaceErrorState extends PlaceState {
  final String error;

  LeavePlaceErrorState({required this.error});
}

class LeavePlaceLoadingState extends PlaceState {}

class LeavePlaceNotParkedState extends PlaceState {}

class GetAvailabilityLoadingState extends PlaceState {}

class GetAvailabilitySuccessState extends PlaceState {}

class GetAvailabilityErrorState extends PlaceState {}
