import 'dart:io' as io;

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
            ),
          )),
      bottomNavigationBar: const Footer(),
    );
  }
}
