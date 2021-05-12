import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/account/account_page.dart';
import 'package:time_tracker/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker/app/home/tab_items.dart';

import 'jobs/jobs_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItems _currentTab = TabItems.job;
  final Map<TabItems, GlobalKey<NavigatorState>> navigarorKeys = {
    TabItems.job: GlobalKey<NavigatorState>(),
    TabItems.entries: GlobalKey<NavigatorState>(),
    TabItems.account: GlobalKey<NavigatorState>(),
  };
  Map<TabItems, WidgetBuilder> get widgetBuilders {
    return {
      TabItems.job: (_) => JobsPage(),
      TabItems.entries: (_) => Container(),
      TabItems.account: (_) => AccounPage(),
    };
  }

  void _selectedTab(TabItems tabItems) {
    if(tabItems ==_currentTab){
      // pop to first route
      navigarorKeys[tabItems].currentState.popUntil((route)=>route.isFirst);
    }else{
    setState(() => _currentTab = tabItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    // use WillPopScope when u right back to previous page the app is not close
    // directly it will work on back to back page
    // WillPopScope=> to control the back button on ANDROID(doed nothing on iOS)
    // Use global keys to control each navigation stack
    return WillPopScope(
      // maybePop()=>
      // more than one route -> pop and return true
      // only one route -> no pop and return false
      onWillPop: ()async =>!await navigarorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _selectedTab,
        widgetBuilders: widgetBuilders,
        navigarorKeys: navigarorKeys,
      ),
    );
  }
}
