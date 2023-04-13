part of 'security_bloc.dart';

abstract class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object> get props => [];
}

class SecurityInitial extends SecurityState {}

class GetProblemsSecuritySuccessState extends SecurityState {}

class GetProblemsSecurityErrorState extends SecurityState {
  final String error;

  GetProblemsSecurityErrorState({required this.error});
}

class GetProblemsSecurityLoadingState extends SecurityState {}

class CompleteProblemSecuritySuccessState extends SecurityState {}

class CompleteProblemSecurityErrorState extends SecurityState {
  final String error;

  CompleteProblemSecurityErrorState({required this.error});
}

class CompleteProblemSecurityLoadingState extends SecurityState {}
