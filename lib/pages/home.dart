import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'aboutPage.dart';
import 'albumPage.dart';
import 'organizePage.dart';
import '../services/mediaServices.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OrganizePage(),
    AlbumPage(),
    AboutPage(),
  ];

  @override
  void initState() {
    // 请求权限
    MediaServices().getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        // indicatorColor: Colors.amber,
        selectedIndex: _currentIndex,
        destinations: const <Widget>[
          NavigationDestination(selectedIcon: Icon(Icons.home), icon: Icon(Icons.home_outlined), label: 'Organize'),
          NavigationDestination(
              selectedIcon: Icon(Icons.image_rounded), icon: Icon(Icons.image_outlined), label: 'Album'),
          NavigationDestination(selectedIcon: Icon(Icons.more_horiz), icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
