import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ],
    );
  }
}

class SmallLoadingWidget extends StatelessWidget {
  const SmallLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}

class DoneWidget extends StatelessWidget {
  const DoneWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              child: Lottie.network(
                'https://assets1.lottiefiles.com/private_files/lf30_jgkflosi.json',
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
