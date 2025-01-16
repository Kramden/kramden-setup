import 'dart:io' as io;
import 'package:dbus/dbus.dart';
import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:provider/provider.dart';
import 'package:provider_setup/app.dart';
import 'package:udisks/udisks.dart';
import 'package:upower/upower.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class SysinfoPage extends StatefulWidget {
  //static var buildDetail;

  const SysinfoPage({super.key});

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
  bool batteryPresent = false;
  Map<String, String> batteries = Map<String, String>();
  Map<String, int> drives = Map<String, int>();
  String systemRam = "0";
  String memoryTotal = "0";
  String swapTotal = "0";
  String vendor = "";
  String hostname = "";
  String hardwareModel = "";
  String cpuModel = "";
  String OSName = "";
  String identifier = "";
  String checkStdout = "";
  bool checkPassed = false;
  String installerVersion = "";
  bool isRegisteredWithLandscape = false;

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
    if (hostname.toLowerCase().startsWith("k") ||
        hostname.toLowerCase().startsWith("d") ||
        hostname.toLowerCase().startsWith("l")) {
      completedSteps.addCompletedStep('Identity');
    }
    identifier = hostname;
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

  void getInstallerVersion() async {
    if (io.File('/var/log/installer/kramden-iso').existsSync()) {
      installerVersion = io.File('/var/log/installer/kramden-iso')
          .readAsStringSync()
          .replaceAll('-amd64.iso', '');
      print(installerVersion);
    } else {
      print("File does not exist");
    }
    setState(() {});
  }

  void getMemoryInfo() async {
    final ProcessCmd cmd = ProcessCmd('free', ['-g', '--si']);
    final result = await runCmd(cmd, verbose: false, commandVerbose: false);
    final output = result.stdout.toString();
    final memory = output.split('        ');
    memoryTotal = memory[4].trim();
    swapTotal = memory[10].trim();
    setState(() {});
  }

  void getHardDriveInfo() async {
    final client = UDisksClient();
    await client.connect();

    for (var drive in client.drives) {
      if (!drive.removable) {
        drives[drive.model] = drive.size / 1024 / 1024 ~/ 1024;
      }
    }
    await client.close();
    setState(() {});
  }

  void getBatteryInfo() async {
    final upower = UPowerClient();
    await upower.connect();

    for (var device in upower.devices) {
      if (device.type == UPowerDeviceType.battery) {
        //print("Capacity: ${device.capacity.round()}");
        //print("Percentage: ${device.percentage}");
        batteries[device.model.toString()] = device.capacity.round().toString();
        batteryPresent = true;
      }
    }

    upower.close();
    setState(() {});
  }

  void getInstallCheck() async {
    final ProcessCmd checkCmd =
        ProcessCmd('/usr/bin/provider-install-check', []);
    final checkResult =
        await runCmd(checkCmd, verbose: false, commandVerbose: false);
    checkStdout = checkResult.stdout.toString();
    print(checkStdout);
    checkPassed = checkResult.exitCode == 0;
    setState(() {});
  }

  void checkIfRegisteredWithLandscape() async {
    final ProcessCmd cmd = ProcessCmd('sudo', [
      'landscape-config',
      '--is-registered',
    ]);
    final result = await runCmd(cmd, verbose: true, commandVerbose: true);
    isRegisteredWithLandscape = result.exitCode == 0;
    setState(() {});

    if (isRegisteredWithLandscape) {
      completedSteps.addCompletedStep('Landscape');
    }
  }

  @override
  void initState() {
    super.initState();
    getBatteryInfo();
    getHardDriveInfo();
    getMemoryInfo();
    getSystemInfo();
    getInstallCheck();
    getInstallerVersion();
    checkIfRegisteredWithLandscape();
    completedSteps.addCompletedStep('System Info');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          children: [
            const Text("System Info"),
            const Padding(padding: EdgeInsets.all(kYaruPagePadding)),
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
                      Text("Installer Version: $installerVersion"),
                      Text(
                          style: isRegisteredWithLandscape
                              ? const TextStyle(color: Colors.green)
                              : const TextStyle(color: Colors.orange),
                          "Registered with Landscape: $isRegisteredWithLandscape")
                    ],
                  ),
                  style: YaruTileStyle.normal,
                ),
                YaruTile(
                  title: const Text("Hard Drive"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: drives.entries
                        .map(
                          (e) => Row(
                            children: [
                              Text("Model: ${e.key.toString()}"),
                              Text("     "),
                              Text(
                                style: e.value < 115
                                  ? const TextStyle(color: Colors.orange)
                                  : const TextStyle(color: Colors.green),
                                "Capacity: ${e.value.toString()} GB")
                            ])
                        )
                        .toList()),
                ),
                YaruTile(
                  title: const Text("Memory"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          style: int.parse(memoryTotal) < 8
                              ? const TextStyle(color: Colors.orange)
                              : const TextStyle(color: Colors.green),
                          "RAM: $memoryTotal" "G"),
                      Text(
                          style: double.parse(swapTotal) < 4
                              ? const TextStyle(color: Colors.orange)
                              : const TextStyle(color: Colors.green),
                          "Swap: $swapTotal" "G"),
                    ],
                  ),
                  style: YaruTileStyle.normal,
                ),
                if (batteryPresent)
                  YaruTile(
                    title: const Text("Battery"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: batteries.entries
                          .map(
                            (e) => Text(
                                style: int.parse(e.value) < 70
                                    ? const TextStyle(color: Colors.orange)
                                    : const TextStyle(color: Colors.green),
                                "Capacity: ${e.value.toString()} %"),
                          )
                          .toList(),
                      )),
                YaruTile(
                  title: const Text("System Check"),
                  subtitle: Text(
                      style: checkPassed
                          ? const TextStyle(color: Colors.green)
                          : const TextStyle(color: Colors.red),
                      checkStdout),
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
