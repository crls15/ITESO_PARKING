import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iteso_parking/auth/bloc/auth_bloc.dart';
import 'package:iteso_parking/login_page.dart';
import 'package:iteso_parking/profile/bloc/profile_bloc.dart';
import 'package:iteso_parking/profile/car.dart';
import 'package:iteso_parking/profile/car_button.dart';
import 'package:iteso_parking/profile/car_registration_page.dart';
import 'package:iteso_parking/profile/profile.dart';
import 'package:iteso_parking/utils/utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mi perfil'),
            IconButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (builder) => LoginPage()),
                  (route) => false,
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
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is GetProfileErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        'Error al cargar el perfil, intentelo mas tarde...'),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state is GetProfileLoadingState) {
              return LoadingWidget();
            } else if (state is GetProfileSuccessState) {
              var userProfile = context.watch<ProfileBloc>().userProfile;
              return getUserProfileData(context, userProfile!);
            } else {
              return Text('else');
            }
          },
        ),
      ),
    );
  }
}

Widget getUserProfileData(BuildContext context, Profile userProfile) {
  return Column(
    children: [
      ProfileInfo(userProfile: userProfile),
      SizedBox(
        height: 20,
      ),
      Text(
        'Seleccione el auto con el que ingresaras o registre alguno!',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      UserCarsList(carsList: userProfile.carsList),
    ],
  );
}

class UserCarsList extends StatelessWidget {
  const UserCarsList({
    Key? key,
    required this.carsList,
  }) : super(key: key);

  final List<Car> carsList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 400,
        height: 300,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: carsList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: index != carsList.length
                  ? CarButton(car: carsList[index])
                  : NewCarButton(),
            );
          },
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final Profile userProfile;
  const ProfileInfo({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nombre: ${userProfile.name}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Expediente: ${userProfile.userNumber}',
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewCarButton extends StatelessWidget {
  const NewCarButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CarRegistrationPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
