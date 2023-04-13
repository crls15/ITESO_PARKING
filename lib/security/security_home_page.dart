import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iteso_parking/auth/bloc/auth_bloc.dart';
import 'package:iteso_parking/login_page.dart';
import 'package:iteso_parking/problem/problem.dart';
import 'package:iteso_parking/security/bloc/security_bloc.dart';
import 'package:iteso_parking/security/security_problem_page.dart';
import 'package:iteso_parking/utils/utils.dart';

class SecurityHomePage extends StatelessWidget {
  const SecurityHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SecurityBloc>(context).add(GetProblemsSecurityEvent());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 300,
              child: Wrap(
                children: [
                  Text(
                    'Gestión de Problemas del Estacionamiento ITESO',
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<SecurityBloc, SecurityState>(
            listener: (context, state) {
              if (state is GetProblemsSecurityErrorState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                          'Error al cargar los elementos, intentelo mas tarde...'),
                    ),
                  );
              }
            },
            builder: (context, state) {
              if (state is GetProblemsSecuritySuccessState) {
                List<Problem> problemsList =
                    context.watch<SecurityBloc>().problemsList;
                return ListView.builder(
                  itemCount: problemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProblemListItem(
                      problem: problemsList[index],
                    );
                  },
                );
              } else if (state is GetProblemsSecurityLoadingState) {
                return LoadingWidget();
              } else {
                BlocProvider.of<SecurityBloc>(context)
                    .add(GetProblemsSecurityEvent());
                return LoadingWidget();
              }
            },
          )),
    );
  }
}

class ProblemListItem extends StatelessWidget {
  final Problem problem;

  const ProblemListItem({
    Key? key,
    required this.problem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SecurityProblemPage(
                  problem: problem,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Positioned(
                child: Image.network(
                  problem.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                    maxHeight: 100,
                  ),
                  color: Color.fromARGB(220, 37, 78, 190),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          problem.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sección: ${problem.section}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 180,
                              child: Text(
                                'Lugar(es): ${problem.places}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: (() {
                    _showMyDialog(context);
                  }),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                        maxWidth: 250,
                      ),
                      color: Color.fromARGB(220, 37, 78, 190),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Completar!',
                              maxLines: 3,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finalizar/Completar este problema?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Ya no se mostrará en la sección de problemas por solucionar.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                // context.read<SongProvider>().deleteFromFavorites(widget.song!);
                BlocProvider.of<SecurityBloc>(context).add(
                    CompleteProblemSecurityEvent(problemToComplete: problem));

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Se completó con éxito...'),
                    ),
                  );
              },
            ),
          ],
        );
      },
    );
  }
}
