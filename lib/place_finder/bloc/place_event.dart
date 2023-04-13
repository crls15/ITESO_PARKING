part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class FindPlaceEvent extends PlaceEvent {
  @override
  List<Object> get props => [];
}

class LeavePlaceEvent extends PlaceEvent {}

class GetAvailabilityPlaceEvent extends PlaceEvent {}
