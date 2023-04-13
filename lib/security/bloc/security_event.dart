part of 'security_bloc.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object> get props => [];
}

class GetProblemsSecurityEvent extends SecurityEvent {
  @override
  List<Object> get props => [];
}

class CompleteProblemSecurityEvent extends SecurityEvent {
  Problem problemToComplete;

  CompleteProblemSecurityEvent({
    required this.problemToComplete,
  });
  @override
  List<Object> get props => [];
}
