import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/tab_items.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigarorKeys,
  }) : super(key: key);
  final TabItems currentTab;
  final ValueChanged<TabItems> onSelectTab;
  final Map<TabItems, WidgetBuilder> widgetBuilders;
  final Map<TabItems, GlobalKey<NavigatorState>> navigarorKeys;
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItems.job),
          _buildItem(TabItems.entries),
          _buildItem(TabItems.account),
        ],
        onTap: (index) => onSelectTab(TabItems.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItems.values[index];
        return CupertinoTabView(
          navigatorKey: navigarorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItems tabItems) {
    final itemData = TabItemData.allTabs[tabItems];
    final selectedTabColor =
        currentTab == tabItems ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: selectedTabColor,
      ),
      title: Text(
        itemData.title,
        style: TextStyle(
          color: selectedTabColor,
        ),
      ),
    );
  }
}
