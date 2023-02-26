import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upower/upower.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../../../widgets.dart';

class SysinfoPage extends StatefulWidget {
  //static var buildDetail;

  const SysinfoPage({super.key});

  void getBatteryInfo() async {
    final upower = UPowerClient();
    await upower.connect();
    for (var device in upower.devices) {
      if (device.type == UPowerDeviceType.battery) {
        print("Capacity: ${device.capacity}");
        print("Percentage: ${device.percentage}");
        print("Icon: ${device.iconName}");
      }
    }
    upower.close();
    //final battery = await upower.devices();
    //final battery = await upower.getBattery();
    //print(battery);
  }

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.computer);
  }

  static Widget buildTitle(BuildContext context) {
    return const Text("System Info");
  }

  static Widget buildDetail(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: const SysinfoPage(),
    );
  }

  @override
  State<SysinfoPage> createState() => _SysinfoPageState();
}

class _SysinfoPageState extends State<SysinfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(kYaruPagePadding),
        child: Text("System Info"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.getBatteryInfo(),
        child: const Icon(YaruIcons.refresh),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
