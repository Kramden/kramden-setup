import 'package:flutter/widgets.dart';

import 'identify/identify_page.dart';
import 'landscape/landscape_page.dart';
import 'reset/reset_page.dart';
import 'sysinfo/sysinfo_page.dart';
import 'manualtest/manualtest_page.dart';

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
    iconBuilder: IdentifyPage.buildIcon,
    titleBuilder: IdentifyPage.buildTitle,
    pageBuilder: IdentifyPage.buildDetail,
  ),
  PageBuilder(
    iconBuilder: SysinfoPage.buildIcon,
    titleBuilder: SysinfoPage.buildTitle,
    pageBuilder: SysinfoPage.buildDetail,
  ),
  PageBuilder(
    iconBuilder: ManualTestPage.buildIcon,
    titleBuilder: ManualTestPage.buildTitle,
    pageBuilder: ManualTestPage.buildDetail,
  ),
  PageBuilder(
    iconBuilder: LandscapePage.buildIcon,
    titleBuilder: LandscapePage.buildTitle,
    pageBuilder: LandscapePage.buildDetail,
  ),
  PageBuilder(
    iconBuilder: ResetPage.buildIcon,
    titleBuilder: ResetPage.buildTitle,
    pageBuilder: ResetPage.buildDetail,
  ),
];
