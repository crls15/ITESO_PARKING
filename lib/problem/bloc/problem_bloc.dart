import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:iteso_parking/problem/problem.dart';

part 'problem_event.dart';
part 'problem_state.dart';

class ProblemBloc extends Bloc<ProblemEvent, ProblemState> {
  ProblemBloc() : super(ProblemInitial()) {
    on<RegisterNewProblemEvent>(_registerProblem);
    on<InitProblemEvent>(_initProble);
  }

  Future<void> _initProble(event, emit) async {
    emit(InitProblemState());
  }

  Future<void> _registerProblem(event, emit) async {
    emit(RegisterProblemLoadingState());

    var problemRegistered = await _newProblem(event.newProblem);

    if (problemRegistered == true) {
      emit(RegisterProblemSuccessState());
    } else {
      emit(RegisterProblemErrorState(error: 'Error'));
    }
  }

  Future<dynamic> _newProblem(Problem newProblem) async {
    Map<String, dynamic> problem_map = {
      'section': newProblem.section,
      'places': newProblem.places,
      'description': newProblem.description,
      'imageUrl': newProblem.imageUrl,
      'userUid': newProblem.userUid,
      'isSolved': false,
    };

    await FirebaseFirestore.instance.collection("problem").add(problem_map);

    return true;
  }
}
