import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iteso_parking/home_page.dart';
import 'package:iteso_parking/login_page.dart';
import 'package:iteso_parking/photo/bloc/photo_bloc.dart';
import 'package:iteso_parking/place_finder/bloc/place_bloc.dart';
import 'package:iteso_parking/problem/bloc/problem_bloc.dart';
import 'package:iteso_parking/profile/bloc/profile_bloc.dart';
import 'package:iteso_parking/auth/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iteso_parking/security/bloc/security_bloc.dart';

import 'security/security_home_page.dart';

// void main() => runApp(const MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthEvent()),
        ),
        BlocProvider(
          create: (context) => PlaceBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider(
          create: (context) => ProblemBloc(),
        ),
        BlocProvider(
          create: (context) => SecurityBloc(),
        ),
        BlocProvider(
          create: (context) => PhotoBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(VerifyAuthEvent());
    return MaterialApp(
      theme: ThemeData.from(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(6, 39, 84, 255))),
      title: 'ITESO Parking',
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return LoginPage();
          } else if (state is AuthSuccessSecurityState) {
            return SecurityHomePage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
