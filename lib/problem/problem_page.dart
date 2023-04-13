import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iteso_parking/home_page.dart';
import 'package:iteso_parking/photo/bloc/photo_bloc.dart';
import 'package:iteso_parking/problem/bloc/problem_bloc.dart';
import 'package:iteso_parking/problem/problem.dart';
import 'package:iteso_parking/utils/utils.dart';
import 'package:lottie/lottie.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

String dropdownvalue = 'A';
var items = ['A', 'B', 'C', 'D', 'E', 'F'];

class _ProblemPageState extends State<ProblemPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PhotoBloc>(context).add(OnNewFormWithPhotoEvent());
    BlocProvider.of<ProblemBloc>(context).add(InitProblemEvent());
    dropdownvalue = 'A';
    var descriptionController = TextEditingController();
    var placesController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Denunciar Problemas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<ProblemBloc, ProblemState>(
          listener: (context, state) {
            if (state is RegisterProblemErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        'Error al registrar el problema, intentelo mas tarde...'),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state is RegisterProblemLoadingState) {
              return LoadingWidget();
            } else if (state is RegisterProblemSuccessState) {
              return DoneWidget();
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PhotoBloc>(context)
                          .add(OnTakePhotoEvent());
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 117, 115, 115)),
                      minimumSize: MaterialStateProperty.all(
                        Size(80.0, 50.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: BlocConsumer<PhotoBloc, PhotoState>(
                        listener: (context, state) {
                          if (state is TakePhotoErrorState) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error al tomar la foto, intentelo mas tarde...'),
                                ),
                              );
                          }
                        },
                        builder: (context, state) {
                          if (state is TakePhotoLoadingState) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (state is TakePhotoSuccessState) {
                            return showPhotoButtonContent(context,
                                BlocProvider.of<PhotoBloc>(context).imageUrl);
                          } else if (state is TakePhotoErrorState) {
                            return Text('Error');
                          } else {
                            return takePhotoButtonContent(context);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Describa el problema:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ingresa una descripcion breve',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SelectSectionDropDownMenu(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Indique en cual(es) lugar(es) se encuentra el problema:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextField(
                          controller: placesController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                'Ingresa el/los número(s) del/los lugar(es)',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var imgUrl = BlocProvider.of<PhotoBloc>(context).imageUrl;

                      BlocProvider.of<ProblemBloc>(context).add(
                        RegisterNewProblemEvent(
                          newProblem: Problem(
                              section: dropdownvalue,
                              places: placesController.text,
                              description: descriptionController.text,
                              imageUrl: imgUrl,
                              userUid: FirebaseAuth.instance.currentUser!.uid,
                              isSolved: false),
                        ),
                      );
                      await Future.delayed(Duration(seconds: 3));
                      Navigator.of(context).pop();
                      // BlocProvider.of<ProblemBloc>(context).add(GetProblemEvent());
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(100.0, 80.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Enviar denuncia',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Lottie.network(
                          'https://assets7.lottiefiles.com/private_files/lf30_veav8nkj.json',
                          width: 80,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget takePhotoButtonContent(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Tomar foto',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Lottie.network(
          'https://assets5.lottiefiles.com/temp/lf20_YmEKRX.json',
          width: 60,
        ),
      ],
    );
  }

  Widget showPhotoButtonContent(context, String url) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Tomar otra foto',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Expanded(
            child: Container(
          height: 100,
          width: 100,
          child: Image.network(url),
        )),
      ],
    );
  }
}

class SelectSectionDropDownMenu extends StatefulWidget {
  const SelectSectionDropDownMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectSectionDropDownMenu> createState() =>
      _SelectSectionDropDownMenuState();
}

class _SelectSectionDropDownMenuState extends State<SelectSectionDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Text(
              'Selecciona la sección del problema:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: DropdownButton(
              isExpanded: true,
              value: dropdownvalue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class ProblemPageForm extends StatefulWidget {
//   const ProblemPageForm(
//     BuildContext context, {
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ProblemPageForm> createState() => _ProblemPageFormState();
// }

// class _ProblemPageFormState extends State<ProblemPageForm> {
//   @override
//   Widget build(BuildContext context) {
//     }
// }
