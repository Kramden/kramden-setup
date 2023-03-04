import 'package:flutter/material.dart';
import 'package:dbus/dbus.dart';
import 'package:process_run/cmd_run.dart';
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
  late String hardDriveCapacity = "";
  late String systemRam = "";
  late String hardDriveUsed = "";
  late String hardDriveAvailable = "";
  late String hardDriveUsage = "";
  late String memoryTotal = "";
  late String swapTotal = "";
  late String vendor = "";
  late String hostname = "";
  late String hardwareModel = "";
  late String OSName = "";
  late String kramdenIdentifier = "";

  void getSystemInfo() async {
    final client = DBusClient.system();
    final object = DBusRemoteObject(client,
        path: DBusObjectPath('/org/freedesktop/hostname1'),
        name: 'org.freedesktop.hostname1');
    final properties =
        await object.getAllProperties('org.freedesktop.hostname1');
    properties.forEach((name, value) {
      if (name == 'Hostname') {
        hostname = value.toNative();
      } else if (name == 'HardwareVendor') {
        vendor = value.toNative();
      } else if (name == 'HardwareModel') {
        hardwareModel = value.toNative();
      } else if (name == 'OperatingSystemPrettyName') {
        OSName = value.toNative();
      }
      print('$name: ${value.toNative()}');
    });
    if (hostname.startsWith("K") || hostname.startsWith("k")) {
      kramdenIdentifier = hostname;
    }
    print("==================================");
    print(hostname);
    print(vendor);
    print(hardwareModel);
    print(OSName);
    print(kramdenIdentifier);

    /*
    final ProcessCmd cmd = ProcessCmd('grep', ['model name', '/proc/cpuinfo']);
    final result = await runCmd(cmd, verbose: false, commandVerbose: false);
    final output = result.stdout;
    final system = output.split(': ');
    print(system[0]);
    print("HERE");
    print(output);
    //print(systemRam);
    */
  }

  void getMemoryInfo() async {
    final ProcessCmd cmd = ProcessCmd('free', ['-h', '--si']);
    final result = await runCmd(cmd, verbose: false, commandVerbose: false);
    final output = result.stdout.toString();
    final memory = output.split('        ');
    memoryTotal = memory[4].trim();
    swapTotal = memory[10].trim();
  }

  void getHardDriveInfo() async {
    final ProcessCmd cmd = ProcessCmd('df', ['-h', '/']);
    final result = await runCmd(cmd, verbose: false, commandVerbose: false);
    final output = result.stdout.toString();
    final hardDrive = output.split('  ');
    hardDriveCapacity = hardDrive[5];
    hardDriveUsed = hardDrive[6];
    hardDriveAvailable = hardDrive[7];
    hardDriveUsage = hardDrive[8];
  }

  void getBatteryInfo() async {
    final upower = UPowerClient();
    await upower.connect();
    for (var device in upower.devices) {
      if (device.type == UPowerDeviceType.battery) {
        print("Capacity: ${device.capacity.round()}");
        print("Percentage: ${device.percentage}");
        batteryCapacity = device.capacity.round().toString();
      }
    }
    upower.close();
  }

  @override
  void initState() {
    super.initState();
    getBatteryInfo();
    getHardDriveInfo();
    getMemoryInfo();
    getSystemInfo();
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
                  title: const Text("System"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kramden Identifier: $kramdenIdentifier"),
                      Text("Manufacturer: $vendor"),
                      Text("Model: $hardwareModel"),
                      Text("CPU: $hardDriveAvailable"),
                      Text("OS: $OSName"),
                    ],
                  ),
                  style: YaruTileStyle.normal,
                ),
                YaruTile(
                  title: const Text("Hard Drive"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Capacity: $hardDriveCapacity"),
                      Text("Used: $hardDriveUsed"),
                      Text("Available: $hardDriveAvailable"),
                      Text("Usage: $hardDriveUsage"),
                    ],
                  ),
                  style: YaruTileStyle.normal,
                ),
                YaruTile(
                  title: const Text("System Memory"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total RAM: $memoryTotal"),
                      Text("Total swap: $swapTotal"),
                    ],
                  ),
                  style: YaruTileStyle.normal,
                ),
                YaruTile(
                  title: const Text("Battery"),
                  subtitle: Text("Capacity: ${batteryCapacity.toString()} %"),
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
    );
  }
}
