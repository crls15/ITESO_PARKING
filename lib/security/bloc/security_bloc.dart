import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:iteso_parking/problem/problem.dart';

part 'security_event.dart';
part 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc() : super(SecurityInitial()) {
    on<GetProblemsSecurityEvent>(_getProblems);
    on<CompleteProblemSecurityEvent>(_completeProblem);
  }

  List<Problem> problemsList = [];

  Future<void> _getProblems(event, emit) async {
    emit(GetProblemsSecurityLoadingState());

    var problemsFound = await _problemsGetter();
    if (problemsFound == true) {
      emit(GetProblemsSecuritySuccessState());
    } else {
      emit(GetProblemsSecurityErrorState(error: 'Error'));
    }
  }

  Future<dynamic> _problemsGetter() async {
    var problemDocs = await FirebaseFirestore.instance
        .collection("problem")
        .where('isSolved', isEqualTo: false)
        .get();

    problemsList = [];

    for (var doc in problemDocs.docs) {
      problemsList.add(Problem.fromJson(await doc.data()));
    }

    return true;
  }

  Future<void> _completeProblem(event, emit) async {
    emit(CompleteProblemSecurityLoadingState());

    var problemsFound = await _problemCompleter(event.problemToComplete);
    if (problemsFound == true) {
      emit(GetProblemsSecuritySuccessState());
    } else {
      emit(CompleteProblemSecurityErrorState(error: 'Error'));
    }
  }

  Future<dynamic> _problemCompleter(Problem problemToComplete) async {
    var problemDoc = await FirebaseFirestore.instance
        .collection("problem")
        .where('imageUrl', isEqualTo: problemToComplete.imageUrl)
        .get();

    var problemFire = problemDoc.docs[0];

    Map<String, dynamic> problem_map = {
      'description': problemToComplete.description,
      'imageUrl': problemToComplete.imageUrl,
      'places': problemToComplete.places,
      'section': problemToComplete.section,
      'userUid': problemToComplete.userUid,
      'isSolved': true,
    };

    await FirebaseFirestore.instance
        .collection("problem")
        .doc(problemFire.id)
        .update(problem_map);

    return _problemsGetter();
  }
}
