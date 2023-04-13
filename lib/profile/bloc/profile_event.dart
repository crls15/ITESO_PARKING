part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class RegisterNewCarEvent extends ProfileEvent {
  Car newCar;

  RegisterNewCarEvent({
    required this.newCar,
  });

  @override
  List<Object> get props => [];
}

class ChangeCarIsActiveProfileEvent extends ProfileEvent {
  Car car;

  ChangeCarIsActiveProfileEvent({
    required this.car,
  });
  @override
  List<Object> get props => [];
}
