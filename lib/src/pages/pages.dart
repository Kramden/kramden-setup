import 'package:flutter/widgets.dart';
import 'landscape/landscape_page.dart';
import 'sysinfo/sysinfo_page.dart';

class PageBuilder {
  const PageBuilder({
    required this.iconBuilder,
    required this.titleBuilder,
    required this.pageBuilder,
  });

  final WidgetBuilder iconBuilder;
  final WidgetBuilder titleBuilder;
  final WidgetBuilder pageBuilder;
}

const pages = [
  PageBuilder(
    iconBuilder: SysinfoPage.buildIcon,
    titleBuilder: SysinfoPage.buildTitle,
    pageBuilder: SysinfoPage.buildDetail,
  ),
  PageBuilder(
    iconBuilder: LandscapePage.buildIcon,
    titleBuilder: LandscapePage.buildTitle,
    pageBuilder: LandscapePage.buildDetail,
  ),
];
