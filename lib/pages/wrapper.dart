import 'package:brbr/constants/colors.dart';
import 'package:brbr/pages/home.dart';
import 'package:brbr/pages/more.dart';
import 'package:brbr/pages/explore.dart';
import 'package:flutter/material.dart';

class BRBRWrapper extends StatefulWidget {
  @override
  _BRBRWrapperState createState() => _BRBRWrapperState();
}

class _BRBRWrapperState extends State<BRBRWrapper> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _pages = [HomePage(), ExplorePage(), MorePage()], _appBars = [homePageAppBar(context), null, null];
    return Scaffold(
      appBar: _appBars[_pageIndex],
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: BRBRColors.highlight,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
      ),
    );
  }
}
