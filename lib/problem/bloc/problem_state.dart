part of 'problem_bloc.dart';

abstract class ProblemState extends Equatable {
  const ProblemState();

  @override
  List<Object> get props => [];
}

class ProblemInitial extends ProblemState {}

class RegisterProblemSuccessState extends ProblemState {
  @override
  List<Object> get props => [];
}

class RegisterProblemErrorState extends ProblemState {
  final String error;

  RegisterProblemErrorState({required this.error});
}

class RegisterProblemLoadingState extends ProblemState {}

class InitProblemState extends ProblemState {}
