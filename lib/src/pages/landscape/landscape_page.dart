import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:ini/ini.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:provider_setup/app.dart';
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
  bool _accepted = false;

  Future<bool> isRegistered() async {
    final ProcessCmd cmd = ProcessCmd('sudo', [
      'landscape-config',
      '--is-registered',
    ]);
    final result = await runCmd(cmd, verbose: true, commandVerbose: true);
    _registered = result.exitCode == 0;

    completedSteps.addCompletedStep('Landscape');

    setState(() {});
    return _registered;
  }

  Future<bool> isAccepted() async {
    if (io.File('/var/log/landscape/package-reporter.log').existsSync()) {
      final fileBytes = await io.File('/var/log/landscape/package-reporter.log')
          .readAsBytes();
      _accepted = fileBytes.lengthInBytes > 0;
    } else {
      _accepted = false;
    }

    if (_accepted) _processing = false;
    setState(() {});
    return _accepted;
  }

  void monitorLandscape() {
    // runs every 1 second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_accepted) {
        isAccepted();
      } else {
        timer.cancel();
        return;
      }
    });
  }

  Future<bool> register(String identifier) async {
    // If already registered, make this a NOOP
    if (_registered) {
      return true;
    }
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
      identifier,
      '--script-users=ALL',
      '--access-group=global',
    ]);
    final result = await runCmd(cmd, verbose: true, commandVerbose: true);

    setState(() {
      _registered = result.exitCode == 0;
    });

    if (_registered) {
      completedSteps.addCompletedStep('Landscape');
      monitorLandscape();
    }

    return result.exitCode == 0;
  }

  @override
  void initState() {
    super.initState();
    isRegistered();
    isAccepted();
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
                                _registered && _accepted
                                    ? Text(
                                        '$identifier is registered with Landscape')
                                    : Text(
                                        'Register $identifier with Landscape'),
                                const Padding(
                                    padding: EdgeInsets.all(kYaruPagePadding)),
                                ElevatedButton(
                                  onPressed: _registered
                                      ? null
                                      : () async {
                                          await register(identifier)
                                              .then((value) {
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
                                  child: const Text('Register'),
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
                ? 'assets/images/landscape_dark.png'
                : 'assets/images/landscape_light.png')),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
