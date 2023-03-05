import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../../../widgets.dart';

class ResetPage extends StatefulWidget {
  //static var buildDetail;

  const ResetPage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.reboot);
  }

  static Widget buildTitle(BuildContext context) {
    return const Text("Reset");
  }

  static Widget buildDetail(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: const ResetPage(),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  @override
  void initState() {
    super.initState();
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
                  width: 400,
                  child: Column(
                    children: [
                      const Text(
                        "Reset the system and prepare for a new user",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      YaruIconButton(
                        onPressed: () async {
                          await runReset().then((value) {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Text('${value ? "Success" : "Failed"}!'),
                                  content: Text(
                                      'Reset was ${value ? "successful, reboot now" : "unsuccessful"}'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        if (value) {
                                          runReboot();
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text(value ? "Reboot" : "OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        },
                        icon: const Icon(YaruIcons.reboot),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: const Footer(),
    );
  }

  Future<bool> runReset() async {
    final ProcessCmd cmd = ProcessCmd(
      'sudo',
      [
        '/usr/share/provider/provider-reset',
      ],
    );
    final result = await runCmd(cmd, verbose: true);
    return result.exitCode == 0;
  }

  Future<bool> runReboot() async {
    final ProcessCmd cmd = ProcessCmd(
      'sudo',
      ['reboot'],
    );
    final result = await runCmd(cmd, verbose: true);
    return result.exitCode == 0;
  }
}
