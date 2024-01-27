import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'pages.dart';

final stage = io.Platform.environment['USER'].toString().toLowerCase();

final completedSteps = CompletedSteps();

class CompletedSteps extends ValueNotifier<List<String>> {
  CompletedSteps() : super([]);
  final List<String> _completedSteps = [];
  final List<String> _requiredSteps = [
    'Identity',
    'System Info',
    'Graphics, Video, and Audio',
    'USB',
    'Landscape'
  ];

  List<String>? get completedSteps => _completedSteps;
  void addCompletedStep(String value) {
    if (_completedSteps.contains(value)) return;
    _completedSteps.add(value);
    notifyListeners();
  }

  List<String> checkRequired() {
    final List<String> missingSteps = [];
    for (var i in _requiredSteps) {
      if (!_completedSteps.contains(i)) {
        missingSteps.add(i);
      }
    }

    missingSteps.forEach(print);
    return missingSteps;
  }
}

class ProviderSetupApp extends StatelessWidget {
  const ProviderSetupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        themeMode: ThemeMode.dark,
        builder: (context, child) => Scaffold(
          appBar: const YaruWindowTitleBar(
            title: Text("Setup"),
          ),
          body: child,
        ),
        home: const ProviderSetupPage(),
      ),
    );
  }
}

class ProviderSetupPage extends StatelessWidget {
  const ProviderSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (stage == "osload") {
      // If OS Load stage don't show manual tests page and drop those required tests
      pages.removeAt(3); // Manual Test page
      completedSteps._requiredSteps.removeAt(3);
      completedSteps._requiredSteps.removeAt(2);
    } else if (stage == "finaltest") {
      // If Final Test, don't show landscape
      pages.removeAt(1); // Landscape page
      pages.removeAt(0); // Identity page
      completedSteps._requiredSteps.removeAt(4);
      completedSteps._requiredSteps.removeAt(0);
    } else {
      // If not OS Load or Final Test, don't require any steps
      completedSteps._requiredSteps.clear();
      // Only Display System Info
      pages.removeAt(pages.length - 1); // Reset page is last
      pages.removeAt(3); // Manual Test
      pages.removeAt(1); // Landscape page
      pages.removeAt(0); // Identity page
    }

    return YaruNavigationPage(
      length: pages.length,
      itemBuilder: (context, index, selected) => YaruNavigationRailItem(
        selected: selected,
        icon: pages[index].iconBuilder(context),
        label: pages[index].titleBuilder(context),
        style: YaruNavigationRailStyle.labelled,
      ),
      pageBuilder: (context, index) => pages[index].pageBuilder(context),
    );
  }
}

class ProviderSetupPreview extends StatelessWidget {
  const ProviderSetupPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const YaruTitleBar(
        isMinimizable: true,
        isMaximizable: true,
        isClosable: true,
      ),
      body: YaruNavigationPage(
        length: pages.length,
        itemBuilder: (context, index, selected) => YaruNavigationRailItem(
          icon: pages[index].iconBuilder(context),
          label: pages[index].titleBuilder(context),
          style: YaruNavigationRailStyle.compact,
          selected: selected,
        ),
        pageBuilder: (context, index) => const SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(YaruIcons.refresh),
      ),
    );
  }
}
