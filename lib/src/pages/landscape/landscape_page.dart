import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final model = context.watch<LandscapeModel>();
    return Scaffold(
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: const Text("Landscape"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        //onPressed: () => context.read<LandscapeModel>().load(randomInt()),
        onPressed: () {},
        child: const Icon(YaruIcons.refresh),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
