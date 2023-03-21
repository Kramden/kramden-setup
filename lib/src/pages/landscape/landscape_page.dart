import 'dart:io' as io;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ini/ini.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../../../widgets.dart';

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
  String _identifier() {
    final config = io.File('/etc/hostname').readAsLinesSync();
    final hostname = config.first.toString();
    return hostname;
  }

  String get identifier => _identifier();

  bool _processing = false;
  bool _registered = false;

  bool isRegistered() {
    if (io.File('/etc/provider.registered').existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String identifier) async {
    String url = '';
    String pingUrl = '';

    setState(() {
      _processing = true;
    });

    final envVars = io.Platform.environment;
    if (envVars.containsKey('LANDSCAPE_PING_URL')) {
      pingUrl = envVars['LANDSCAPE_PING_URL'].toString();
    }
    if (envVars.containsKey('LANDSCAPE_URL')) {
      url = envVars['LANDSCAPE_URL'].toString();
    }

    if (io.File('/etc/provider.conf').existsSync()) {
      final config = io.File('/etc/provider.conf').readAsLinesSync();
      final ini = Config.fromStrings(config.toList());
      if (url.isEmpty && ini.hasOption("provider", "landscape_url")) {
        url = ini.get("provider", "landscape_url").toString();
      }
      if (pingUrl.isEmpty && ini.hasOption("provider", "landscape_ping_url")) {
        pingUrl = ini.get("provider", "landscape_ping_url").toString();
      }
    }

    final ProcessCmd cmd = ProcessCmd('sudo', [
      'landscape-config',
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

    if (result.exitCode == 0) {
      final ProcessCmd touchCmd =
          ProcessCmd('sudo', ['touch', '/etc/provider.registered']);
      await runCmd(touchCmd, verbose: true, commandVerbose: true);
    }
    setState(() {
      _registered = isRegistered();
      _processing = false;
    });

    return result.exitCode == 0;
  }

  @override
  void initState() {
    super.initState();
    _registered = isRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(kYaruPagePadding),
          child: Column(
            children: [
              Center(
                child: _processing == true
                    ? const YaruCircularProgressIndicator()
                    : YaruSection(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                _registered
                                    ? Text(
                                        '$identifier is registered with Landscape')
                                    : Text(
                                        'Register $identifier with Landscape'),
                                const Padding(
                                    padding: EdgeInsets.all(kYaruPagePadding)),
                                ElevatedButton(
                                  onPressed: () async {
                                    await register(identifier).then((value) {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                '${value ? "Success" : "Failed"}!'),
                                            content: Text(
                                                'Registration for $identifier was ${value ? "successful" : "unsuccessful"}'),
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
                                  child: _registered
                                      ? const Text('Re-register')
                                      : const Text('Register'),
                                ),
                              ],
                            ),
                          ], //children
                        ),
                      ),
              ),
            ],
          )),
      appBar: AppBar(
        title: Image(
            image: AssetImage(YaruTheme.of(context).themeMode == ThemeMode.dark
                ? 'assets/images/landscape_light.png'
                : 'assets/images/landscape_dark.png')),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
