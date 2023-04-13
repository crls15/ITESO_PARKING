part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class GetProfileSuccessState extends ProfileState {
  @override
  List<Object> get props => [];
}

class GetProfileErrorState extends ProfileState {
  final String error;

  GetProfileErrorState({required this.error});
}

class GetProfileLoadingState extends ProfileState {}

class RegisterNewCarSuccessState extends ProfileState {
  @override
  List<Object> get props => [];
}

class RegisterNewCarErrorState extends ProfileState {
  final String error;

  RegisterNewCarErrorState({required this.error});
}

class RegisterNewCarLoadingState extends ProfileState {}
