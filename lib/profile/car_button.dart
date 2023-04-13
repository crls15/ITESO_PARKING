import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iteso_parking/profile/bloc/profile_bloc.dart';
import 'package:iteso_parking/profile/car.dart';

class CarButton extends StatelessWidget {
  final Car car;
  const CarButton({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        onPressed: () {
          BlocProvider.of<ProfileBloc>(context)
              .add(ChangeCarIsActiveProfileEvent(car: car));
        },
        color:
            car.isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${car.manufacturer} ${car.model}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              '${car.plates}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      // ElevatedButton(
      //   onPressed: () {},
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       Text(
      //         '${car.manufacturer} ${car.model}',
      //         maxLines: 2,
      //         overflow: TextOverflow.ellipsis,
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //           fontSize: 24,
      //         ),
      //       ),
      //       Text(
      //         '${car.plates}',
      //         overflow: TextOverflow.ellipsis,
      //         style: TextStyle(fontSize: 18),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
