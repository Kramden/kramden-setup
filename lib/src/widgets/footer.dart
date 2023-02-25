import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        Html(
          data: "Kramden",
          shrinkWrap: true,
          //onAnchorTap: (url, _, __, ___) => launchUrlString(url!),
        ),
      ],
    );
  }
}
