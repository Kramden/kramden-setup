import 'dart:io' as io;
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const String provider = '';

  static String getProvider() {
    if (io.File('/etc/provider').existsSync()) {
      final config = io.File('/etc/provider').readAsLinesSync();
      final provider = config.first.toString();
      return provider;
    } else {
      return 'kramden';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = getProvider();
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        provider == 'compudopt'
            ? const Image(
                image: ExactAssetImage("assets/images/compudopt-logo-full.png",
                    scale: 1.0))
            : const Image(
                image: ExactAssetImage("assets/images/getlearngive.png",
                    scale: 1.0))
      ],
    );
  }
}
