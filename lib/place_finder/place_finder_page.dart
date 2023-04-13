import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iteso_parking/place_finder/place.dart';
import 'package:iteso_parking/problem/problem_page.dart';
import 'package:iteso_parking/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../problem/problem_button.dart';
import '../profile/profile_page.dart';
import 'bloc/place_bloc.dart';

class PlaceFinderPage extends StatelessWidget {
  const PlaceFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlaceBloc>(context).add(FindPlaceEvent());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Find My Spot ITESO'),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<PlaceBloc, PlaceState>(
          listener: (context, state) {
            if (state is FindPlaceErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content:
                        Text('Error al buscar lugar, intentelo mas tarde...'),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state is FindPlaceLoadingState) {
              return LoadingWidget();
            } else if (state is FindPlaceSuccessState) {
              var asignedPlace = context.watch<PlaceBloc>().asignedPlace;
              return getPlaceFinderData(context, asignedPlace!);
            } else {
              return Text('else');
            }
          },
        ),
      ),
    );
  }

  Widget getPlaceFinderData(BuildContext context, Place asignedPlace) {
    // final Place asignedPlace = dummyPlace;
    return Column(
      children: [
        PlaceInfo(context, asignedPlace),
        SizedBox(
          height: 40,
        ),
        PlaceMap(context, asignedPlace),
        Expanded(
          child: SizedBox(),
        ),
        ProblemButton(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget PlaceInfo(BuildContext context, Place asignedPlace) {
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
                  'Tu lugar es el: ${asignedPlace.number}',
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 24,
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
                  'y se encuentra en la sección: ${asignedPlace.section}',
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

  Widget PlaceMap(BuildContext context, Place asignedPlace) {
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
              'Como llegar hasta tu lugar?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _launchInBrowser(context, asignedPlace.mapsUrl);
            },
            child: Image.network(
              '${asignedPlace.imageUrl}',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(context, url) async {
    print(url);
    if (url == '') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('No se encontró el sitio')),
        );
    } else if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
