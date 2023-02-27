import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        Image(
            image:
                ExactAssetImage("assets/images/getlearngive.png", scale: 1.0)),
      ],
    );
  }
}
