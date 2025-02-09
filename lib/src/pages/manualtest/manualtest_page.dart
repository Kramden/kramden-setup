import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:provider_setup/app.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ManualTestPage extends StatefulWidget {
  //static var buildDetail;

  const ManualTestPage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.checkmark);
  }

  static Widget buildTitle(BuildContext context) {
    return const Text("Manual Tests");
  }

  static Widget buildDetail(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: const ManualTestPage(),
    );
  }

  @override
  State<ManualTestPage> createState() => _ManualTestPageState();
}

class _ManualTestPageState extends State<ManualTestPage> {
  final List<bool?> _checkboxValues = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void _launchURL() async {
    final ProcessCmd cmd =
        ProcessCmd('xdg-open', ['https://vimeo.com/116979416']);
    await runCmd(cmd, verbose: false, commandVerbose: false);
  }

  void _launchCheese() async {
    final ProcessCmd cmd = ProcessCmd('/usr/bin/cheese', []);
    await runCmd(cmd, verbose: true, commandVerbose: true);
  }

  void _launchScreenTest() async {
    final ProcessCmd cmd = ProcessCmd('/snap/bin/screen-test', []);
    await runCmd(cmd, verbose: true, commandVerbose: true);
  }

  void _launchText() async {
    final ProcessCmd touchCmd = ProcessCmd('touch', ['/tmp/test.txt']);
    await runCmd(touchCmd, verbose: true, commandVerbose: true);
    final ProcessCmd cmd = ProcessCmd('xdg-open', ['file:///tmp/test.txt']);
    await runCmd(cmd, verbose: false, commandVerbose: false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          children: [
            const Text("Perform the following manual tests:"),
            const Padding(padding: EdgeInsets.all(kYaruPagePadding)),
            YaruSection(
              child: Column(children: [
                YaruTile(
                  title: const Text("Required Tests"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[0],
                                onChanged: (v) => {
                                      completedSteps.addCompletedStep('USB'),
                                      setState(() => _checkboxValues[0] = v)
                                    },
                                title: const SizedBox(height: 10, width: 10)),
                            const Text(
                                "USB Ports (Plug the mouse into each USB port and verify that it works)"),
                          ])),
                      YaruTile(
                        enabled: true,
                        leading: Row(children: [
                          YaruCheckButton(
                              value: _checkboxValues[1],
                              onChanged: (v) => {
                                    completedSteps.addCompletedStep(
                                        'Graphics, Video, and Audio'),
                                    setState(() => _checkboxValues[1] = v)
                                  },
                              title: const SizedBox(height: 10, width: 10)),
                          InkWell(
                            onTap: _launchURL,
                            child: const Text(
                                "Browser with video and audio playback - Click here"),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ]),
            ),
            YaruSection(
              child: Column(children: [
                YaruTile(
                  title:
                      const Text("Optional Tests - Laptops and/or All-In-Ones"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[2],
                                onChanged: (v) => {
                                      completedSteps.addCompletedStep('Wifi'),
                                      setState(() => _checkboxValues[2] = v)
                                    },
                                title: const SizedBox(height: 10, width: 10)),
                            const Text(
                                "WiFi connectivity (Can it connect to the internet wirelessly?)"),
                          ])),
                      YaruTile(
                        enabled: true,
                        leading: Row(children: [
                          YaruCheckButton(
                              value: _checkboxValues[3],
                              onChanged: (v) => {
                                    completedSteps.addCompletedStep('Webcam'),
                                    setState(() => _checkboxValues[3] = v)
                                  },
                              title: const SizedBox(height: 10, width: 10)),
                          InkWell(
                            onTap: _launchCheese,
                            child: const Text("Webcam - Click here"),
                          )
                        ]),
                      ),
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[4],
                                onChanged: (v) => {
                                      completedSteps
                                          .addCompletedStep('Keyboard'),
                                      setState(() => _checkboxValues[4] = v)
                                    },
                                title: const SizedBox(height: 10, width: 10)),
                            InkWell(
                                onTap: _launchText,
                                child: const Text(
                                    "Keyboard (Do all the keys work and report correctly?) - Click here")),
                          ])),
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[5],
                                onChanged: (v) => {
                                      completedSteps
                                          .addCompletedStep('Touchpad'),
                                      setState(() => _checkboxValues[5] = v)
                                    },
                                title: const SizedBox(height: 10, width: 10)),
                            const Text(
                                "Touchpad (Does the touchpad feel responsive)"),
                          ])),
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[6],
                                onChanged: (v) => {
                                      completedSteps
                                          .addCompletedStep('ScreenTest'),
                                      setState(() => _checkboxValues[6] = v)
                                    },
                                title: const SizedBox(height: 10, width: 10)),
                            InkWell(
                                onTap: _launchScreenTest,
                                child: const Text("Screen Test - Click here")),
                          ])),
                    ],
                  ),
                  style: YaruTileStyle.normal,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
