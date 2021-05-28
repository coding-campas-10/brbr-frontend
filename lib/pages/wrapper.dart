import 'package:brbr/pages/home.dart';
import 'package:brbr/pages/profile.dart';
import 'package:brbr/pages/search.dart';
import 'package:flutter/material.dart';

class BRBRWrapper extends StatefulWidget {
  @override
  _BRBRWrapperState createState() => _BRBRWrapperState();
}

class _BRBRWrapperState extends State<BRBRWrapper> {
  final _pages = [HomePage(), SearchPage(), ProfilePage()], _appBars = [homePageAppBar(), searchPageAppbar(), profilePageAppbar()];
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_pageIndex],
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color.fromRGBO(0, 227, 147, 1),
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
