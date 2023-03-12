import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'pages.dart';

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
