import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ManualTestPage extends StatefulWidget {
  //static var buildDetail;

  const ManualTestPage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.computer);
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
  final List<bool?> _checkboxValues = [false, false, false, false];
  void _launchURL() async {
    final Uri url = Uri.parse('https://vimeo.com/116979416');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchText() async {
    final ProcessCmd touchCmd = ProcessCmd('touch', ['touch /tmp/test.txt']);
    await runCmd(touchCmd, verbose: false, commandVerbose: false);
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
                  title: const Text("Tests"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[0],
                                onChanged: (v) =>
                                    setState(() => _checkboxValues[0] = v),
                                title: const SizedBox(height: 10, width: 10)),
                            const Text(
                                "WiFi connectivity (Can it connect to the internet wirelessly?)"),
                          ])),
                      YaruTile(
                        enabled: true,
                        leading: Row(children: [
                          YaruCheckButton(
                              value: _checkboxValues[1],
                              onChanged: (v) =>
                                  setState(() => _checkboxValues[1] = v),
                              title: const SizedBox(height: 10, width: 10)),
                          InkWell(
                            onTap: _launchURL,
                            child: const Text(
                                style: TextStyle(color: Colors.blue),
                                "Browser with video and audio playback - Click here"),
                          )
                        ]),
                      ),
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[2],
                                onChanged: (v) =>
                                    setState(() => _checkboxValues[2] = v),
                                title: const SizedBox(height: 10, width: 10)),
                            InkWell(
                                onTap: _launchText,
                                child: const Text(
                                    style: TextStyle(color: Colors.blue),
                                    "Keyboard (Do all the keys work and report correctly?) - Click here")),
                          ])),
                      YaruTile(
                          enabled: true,
                          leading: Row(children: [
                            YaruCheckButton(
                                value: _checkboxValues[3],
                                onChanged: (v) =>
                                    setState(() => _checkboxValues[3] = v),
                                title: const SizedBox(height: 10, width: 10)),
                            const Text(
                                "Touchpad (Does the touchpad feel responsive)"),
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
