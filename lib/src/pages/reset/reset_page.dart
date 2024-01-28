import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:provider_setup/app.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import '../../../widgets.dart';

class ResetPage extends StatefulWidget {
  //static var buildDetail;

  const ResetPage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.save_as_filled);
  }

  static Widget buildTitle(BuildContext context) {
    return const Text("Finish");
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
  List<String> missingSteps = completedSteps.checkRequired();

  @override
  void initState() {
    super.initState();
    completedSteps.addListener(() {
      missingSteps = completedSteps.checkRequired();
    });
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
                      Text(
                        missingSteps.isEmpty
                            ? "Complete final setup and power off"
                            : "Please complete all required steps",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        missingSteps.isEmpty ? "" : missingSteps.toString(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: missingSteps.isNotEmpty
                            ? null
                            : () async {
                                await runReset().then((value) {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            '${value ? "Success" : "Failed"}!'),
                                        content: Text(
                                            'Reset was ${value ? "successful, Power off" : "unsuccessful"}'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              if (value) {
                                                runPowerOff();
                                              }
                                              Navigator.pop(context);
                                            },
                                            child:
                                                Text(value ? "Power Off" : "OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                        child: const Text("Complete"),
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
      '/usr/share/provider/provider-reset',
      [],
    );
    final result = await runCmd(cmd, verbose: true);
    return result.exitCode == 0;
  }

  Future<bool> runPowerOff() async {
    final ProcessCmd cmd = ProcessCmd(
      'sudo',
      ['poweroff'],
    );
    final result = await runCmd(cmd, verbose: true);
    return result.exitCode == 0;
  }
}
