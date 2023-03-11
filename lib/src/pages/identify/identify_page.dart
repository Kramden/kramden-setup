import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../../../widgets.dart';

class IdentifyPage extends StatefulWidget {
  //static var buildDetail;

  const IdentifyPage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.ubuntu_logo_simple);
  }

  static Widget buildTitle(BuildContext context) {
    return const Text("Identify");
  }

  static Widget buildDetail(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: const IdentifyPage(),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<IdentifyPage> createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage> {
  late TextEditingController _controller;
  String identifier = "";

  String _identifier() {
    final config = io.File('/etc/hostname').readAsLinesSync();
    final hostname = config.first.toString();
    return hostname;
  }

  bool isIdentified() {
    if (io.File('/etc/hostname').existsSync()) {
      final config = io.File('/etc/hostname').readAsLinesSync();
      final hostname = config.first.toString();
      return hostname.startsWith('K') ||
          hostname.startsWith('L') ||
          hostname.startsWith('D');
    } else {
      return false;
    }
  }

  Future<bool> identify(String identifier) async {
    print("Setting identifier to $identifier");

    final ProcessCmd cmd = ProcessCmd(
        'sudo', ['hostnamectl', 'set-hostname', identifier.toUpperCase()]);
    final result = await runCmd(cmd, verbose: true, commandVerbose: true);
    setState(() {
      identifier = _identifier();
    });

    print("Identifier is now $identifier");
    return result.exitCode == 0;
  }

  @override
  void initState() {
    super.initState();
    identifier = _identifier();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(kYaruPagePadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      YaruTile(title: Text("Identifier: $identifier")),
                      const YaruTile(
                          title: Text('Please enter system identifier:')),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onSubmitted: (String value) async {
                                await identify(value).then((value) {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            '${value ? "Success" : "Failed"}!'),
                                        content: Text(
                                            'Identification for ${_controller.text} was ${value ? "successful" : "unsuccessful"}'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          ElevatedButton(
                            onPressed: () async {
                              await identify(_controller.text).then((value) {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          '${value ? "Success" : "Failed"}!'),
                                      content: Text(
                                          'Registration for ${_controller.text} was ${value ? "successful" : "unsuccessful"}'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            },
                            child: const Text('Set'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ], //children
            ),
          )),
      bottomNavigationBar: const Footer(),
    );
  }
}
