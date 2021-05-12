// enum values can be acceed by index
import 'package:flutter/material.dart';

enum TabItems {
  job,
  entries,
  account,
}
// The const Keyword it Defines a compile-time constant 
class TabItemData {
  const TabItemData({
    @required this.title,
    @required this.icon,
  });
  final String title;
  final IconData icon;

  static const Map<TabItems, TabItemData> allTabs = {
    TabItems.job:TabItemData(title: 'Jobs',icon: Icons.work),
    TabItems.entries:TabItemData(title: 'Entries',icon: Icons.view_headline),
    TabItems.account:TabItemData(title: 'Account',icon: Icons.person),
  };
}
