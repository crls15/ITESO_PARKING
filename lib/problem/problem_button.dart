import 'package:flutter/material.dart';
import 'package:iteso_parking/problem/problem_page.dart';
import 'package:lottie/lottie.dart';

class ProblemButton extends StatelessWidget {
  const ProblemButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProblemPage(),
          ),
        );
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
            'Denunciar problema!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Lottie.network(
            'https://assets9.lottiefiles.com/private_files/lf30_6y4i96n3.json',
            width: 50,
          ),
        ],
      ),
    );
  }
}
