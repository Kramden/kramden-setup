import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upower/upower.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import '../../../widgets.dart';

class SysinfoPage extends StatefulWidget {
  //static var buildDetail;

  SysinfoPage({super.key});

  static Widget buildIcon(BuildContext context) {
    return const Icon(YaruIcons.computer);
  }

  static Widget buildTitle(BuildContext context) {
    return const Text("System Info");
  }

  static Widget buildDetail(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: SysinfoPage(),
    );
  }

  @override
  State<SysinfoPage> createState() => _SysinfoPageState();
}

class _SysinfoPageState extends State<SysinfoPage> {
  late String batteryCapacity = "";
  late String batteryPercentage = "";
  late String batteryIcon = "";

  void getBatteryInfo() async {
    final upower = UPowerClient();
    await upower.connect();
    for (var device in upower.devices) {
      if (device.type == UPowerDeviceType.battery) {
        print("Capacity: ${device.capacity}");
        print("Percentage: ${device.percentage}");
        print("Icon: ${device.iconName}");
        batteryCapacity = device.capacity.toString();
        batteryPercentage = device.percentage.toString();
        batteryIcon = device.iconName.toString();
      }
    }
    upower.close();
  }

  @override
  void initState() {
    super.initState();
    getBatteryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          children: [
            const Text("System Info"),
            YaruSection(
              child: Column(children: [
                YaruTile(
                  title: const Text("Battery Capacity"),
                  subtitle: Text(batteryCapacity),
                  style: YaruTileStyle.normal,
                ),
                YaruTile(
                  title: const Text("Battery Percentage"),
                  subtitle: Text(batteryPercentage),
                  style: YaruTileStyle.normal,
                ),
                YaruTile(
                  title: const Text("Battery Capacity"),
                  subtitle: Text(batteryCapacity),
                  style: YaruTileStyle.normal,
                ),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => getBatteryInfo(),
        child: const Icon(YaruIcons.refresh),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
