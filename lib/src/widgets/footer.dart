import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:ini/ini.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const String provider = '';

  static String getProvider() {
    String provider = 'kramden';

    if (io.File('/etc/provider.conf').existsSync()) {
      final config = io.File('/etc/provider.conf').readAsLinesSync();
      final ini = Config.fromStrings(config.toList());
      if (ini.hasOption("provider", "name")) {
        provider = ini.get("provider", "name").toString();
      }
    }
    return provider;
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
