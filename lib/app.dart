import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'pages.dart';
import 'settings.dart';

class KramdenSetupApp extends StatelessWidget {
  const KramdenSetupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      data: YaruThemeData(
        variant: context.select((Settings s) => s.variant),
      ),
      builder: (context, yaru, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        themeMode: context.select((Settings s) => s.theme),
        builder: (context, child) => Scaffold(
          appBar: const YaruWindowTitleBar(
            title: Text("Setup"),
          ),
          body: child,
        ),
        home: const KramdenSetupPage(),
      ),
    );
  }
}

class KramdenSetupPage extends StatelessWidget {
  const KramdenSetupPage({super.key});

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
      trailing: YaruNavigationRailItem(
        icon: const Icon(YaruIcons.settings),
        label: const Text("Settings"),
        style: YaruNavigationRailStyle.labelled,
        onTap: () => showSettingsDialog(
          context: context,
          themePreviewBuilder: (_) => const KramdenSetupPreview(),
        ),
      ),
    );
  }
}

class KramdenSetupPreview extends StatelessWidget {
  const KramdenSetupPreview({super.key});

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
        trailing: YaruNavigationRailItem(
          icon: const Icon(YaruIcons.settings),
          label: const Text("Settings"),
          style: YaruNavigationRailStyle.compact,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(YaruIcons.refresh),
      ),
    );
  }
}
