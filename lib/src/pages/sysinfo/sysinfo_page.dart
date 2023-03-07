import 'package:dbus/dbus.dart';
import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:upower/upower.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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
  String batteryCapacity = "";
  String hardDriveCapacity = "";
  String systemRam = "";
  String hardDriveUsed = "";
  String hardDriveAvailable = "";
  String hardDriveUsage = "";
  String memoryTotal = "";
  String swapTotal = "";
  String vendor = "";
  String hostname = "";
  String hardwareModel = "";
  String cpuModel = "";
  String OSName = "";
  String identifier = "";

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
      //print('$name: ${value.toNative()}');
    });
    if (hostname.startsWith("K") ||
        hostname.startsWith("D") ||
        hostname.startsWith("L")) {
      identifier = hostname;
    }
    //print("==================================");
    //print(hostname);
    //print(vendor);
    //print(hardwareModel);
    //print(OSName);
    //print(identifier);

    final ProcessCmd cmd = ProcessCmd('grep', ['model name', '/proc/cpuinfo']);
    final result = await runCmd(cmd, verbose: false, commandVerbose: false);
    cpuModel =
        result.stdout.toString().split(': ')[1].split('model name')[0].trim();
    //print(cpuModel);
    setState(() {});
  }

  void getMemoryInfo() async {
    final ProcessCmd cmd = ProcessCmd('free', ['-h', '--si']);
    final result = await runCmd(cmd, verbose: false, commandVerbose: false);
    final output = result.stdout.toString();
    final memory = output.split('        ');
    memoryTotal = memory[4].trim();
    swapTotal = memory[10].trim();
    setState(() {});
  }

  void getHardDriveInfo() async {
    final ProcessCmd capacityCmd =
        ProcessCmd('df', ['-h', '--output=size', '/']);
    final capacityResult =
        await runCmd(capacityCmd, verbose: false, commandVerbose: false);
    hardDriveCapacity = capacityResult.stdout
        .toString()
        .trimLeft()
        .replaceAll('  ', ' ')
        .split(' ')[1]
        .toString()
        .trimLeft()
        .trimRight();
    //print(hardDriveCapacity);
    final ProcessCmd usedCmd = ProcessCmd('df', ['-h', '--output=used', '/']);
    final usedResult =
        await runCmd(usedCmd, verbose: false, commandVerbose: false);
    hardDriveUsed = usedResult.stdout
        .toString()
        .trimLeft()
        .replaceAll('  ', ' ')
        .split(' ')[1]
        .toString()
        .trimLeft()
        .trimRight();
    //print(hardDriveUsed);
    final ProcessCmd availCmd = ProcessCmd('df', ['-h', '--output=avail', '/']);
    final availResult =
        await runCmd(availCmd, verbose: true, commandVerbose: false);
    hardDriveAvailable = availResult.stdout
        .toString()
        .trimLeft()
        .replaceAll('  ', ' ')
        .split(' ')[1]
        .toString()
        .trimLeft()
        .trimRight();
    //print(hardDriveAvailable);
    final ProcessCmd usageCmd = ProcessCmd('df', ['-h', '--output=pcent', '/']);
    final usageResult =
        await runCmd(usageCmd, verbose: false, commandVerbose: false);
    hardDriveUsage = usageResult.stdout
        .toString()
        .trimLeft()
        .replaceAll('  ', ' ')
        .split(' ')[1]
        .toString()
        .trimLeft()
        .trimRight();
    //print(hardDriveUsage);
    setState(() {});
  }

  void getBatteryInfo() async {
    final upower = UPowerClient();
    await upower.connect();
    for (var device in upower.devices) {
      if (device.type == UPowerDeviceType.battery) {
        //print("Capacity: ${device.capacity.round()}");
        //print("Percentage: ${device.percentage}");
        batteryCapacity = device.capacity.round().toString();
      }
    }
    upower.close();
    setState(() {});
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
                      Text("Identifier: $identifier"),
                      Text("Manufacturer: $vendor"),
                      Text("Model: $hardwareModel"),
                      Text("CPU: $cpuModel"),
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
    );
  }
}
