import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../../../widgets.dart';

bool isRegistered() {
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

Future<bool> register(String identifier) async {
  final ProcessCmd cmd = ProcessCmd(
      'pkexec', ['hostnamectl', 'set-hostname', identifier.toUpperCase()]);
  final result = await runCmd(cmd, verbose: true, commandVerbose: true);
  return result.exitCode == 0;
}

class IdentifyPage extends StatefulWidget {
  //static var buildDetail;

  const IdentifyPage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.ubuntu_logo_simple);
    /*
    return const ImageIcon(
        ExactAssetImage('assets/images/compudopt-icon-white.png', scale: 1.0));
    */
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

  String _identifier() {
    final config = io.File('/etc/hostname').readAsLinesSync();
    final hostname = config.first.toString();
    return hostname;
  }

  String get identifier => _identifier();

  @override
  void initState() {
    super.initState();
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
                                await register(value).then((value) {
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
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          ElevatedButton(
                            onPressed: () async {
                              await register(_controller.text).then((value) {
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
                            child: const Text('Register'),
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