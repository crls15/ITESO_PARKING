part of 'problem_bloc.dart';

abstract class ProblemEvent extends Equatable {
  const ProblemEvent();

  @override
  List<Object> get props => [];
}

class RegisterNewProblemEvent extends ProblemEvent {
  Problem newProblem;

  RegisterNewProblemEvent({
    required this.newProblem,
  });

  @override
  List<Object> get props => [];
}

class InitProblemEvent extends ProblemEvent {}

class GetProblemEvent extends ProblemEvent {}
