import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:ini/ini.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../../../widgets.dart';

bool isRegistered() {
  if (io.File('/etc/landscape/client2.conf').existsSync()) {
    final config = io.File('/etc/landscape/client2.conf').readAsLinesSync();

    final ini = Config.fromStrings(config.toList());
    return ini.hasOption("client", "computer_title");
  } else {
    return false;
  }
}

Future<bool> register(String identifier) async {
  const pingUrl = 'http://landscape.linuxgroove.com/ping';
  const url = 'https://landscape.linuxgroove.com/message-system';
  final ProcessCmd cmd = ProcessCmd('landscape-config', [
    '--silent',
    '--url',
    url,
    '--ping-url',
    pingUrl,
    '--account-name',
    'standalone',
    '--computer-title',
    identifier
  ]);
  final result = await runCmd(cmd, verbose: true, commandVerbose: true);
  return result.exitCode == 0;
}

class LandscapePage extends StatefulWidget {
  //static var buildDetail;

  const LandscapePage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.network_wired);
  }

  static Widget buildTitle(BuildContext context) {
    return const Text("Landscape");
  }

  static Widget buildDetail(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: const LandscapePage(),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<LandscapePage> createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //final model = context.watch<LandscapeModel>();
    return Scaffold(
      // ignore: prefer_const_constructors
      body: Padding(
          padding: const EdgeInsets.all(kYaruPagePadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please enter K# system identifier:'),
                SizedBox(
                  width: 200,
                  child: Stack(children: [
                    TextField(
                      controller: _controller,
                      onSubmitted: (String value) async {
                        await register(value).then((value) {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${value ? "Success" : "Failed"}!'),
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
                  ]),
                ),
              ], //children
            ),
          )),
      appBar: AppBar(
        title: Image(
            image: AssetImage(YaruTheme.of(context).themeMode == ThemeMode.dark
                ? 'assets/images/landscape_light.png'
                : 'assets/images/landscape_dark.png')),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        //onPressed: () => context.read<LandscapeModel>().load(randomInt()),
        onPressed: () {},
        child: const Icon(YaruIcons.ok_filled),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
