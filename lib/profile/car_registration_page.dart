import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iteso_parking/profile/car.dart';
import 'package:iteso_parking/profile/profile_page.dart';
import 'package:iteso_parking/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:iteso_parking/profile/bloc/profile_bloc.dart';
import 'package:iteso_parking/photo/bloc/photo_bloc.dart';

void main() => runApp(const CarRegistrationPage());

class CarRegistrationPage extends StatelessWidget {
  const CarRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PhotoBloc>(context).add(OnNewFormWithPhotoEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registre un auto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is RegisterNewCarErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        'Error al guardar el vehiculo, intentelo mas tarde...'),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state is RegisterNewCarLoadingState) {
              return LoadingWidget();
            } else if (state is RegisterNewCarSuccessState) {
              return DoneWidget();
            } else {
              return carRegisterForm(context);
            }
          },
        ),
      ),
    );
  }

  Widget carRegisterForm(context) {
    var manufacturerController = TextEditingController();
    var modelController = TextEditingController();
    var capacityController = TextEditingController();
    var platesController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingrese el manufacturador:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          controller: manufacturerController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Ej: Ford, Toyota, Kia...',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Ingrese el modelo:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          controller: modelController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Ej: Mustang, Jetta, Forte...',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Ingrese la capacidad:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          controller: capacityController,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Ej: 2 asientos'),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Ingrese las placas:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          controller: platesController,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Ej: JSH123432'),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Suba una foto del auto donde se vean las placas:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<PhotoBloc>(context).add(OnTakePhotoEvent());
            // BlocProvider.of<PhotoBloc>(context).add(OnPhotoUploadEvent());
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Color.fromARGB(255, 117, 115, 115)),
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
                  return showPhotoButtonContent(
                      context, BlocProvider.of<PhotoBloc>(context).imageUrl);
                } else if (state is TakePhotoErrorState) {
                  return Text('Error');
                } else {
                  return takePhotoButtonContent(context);
                }
              },
            ),
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var imgUrl = BlocProvider.of<PhotoBloc>(context).imageUrl;

                  BlocProvider.of<ProfileBloc>(context).add(RegisterNewCarEvent(
                      newCar: Car(
                    manufacturer: manufacturerController.text,
                    model: modelController.text,
                    capacity: int.parse(capacityController.text != ''
                        ? capacityController.text
                        : '0'),
                    plates: platesController.text,
                    imageUrl: imgUrl,
                    isActive: false,
                  )));
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.of(context).pop();
                  BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Guardar',
                    style: TextStyle(fontSize: 24),
                  ),
                )),
          ],
        ),
      ],
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
