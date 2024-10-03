import 'package:flutter/material.dart';
import './sub_pages/home_page.dart';
import './sub_pages/order_page.dart';
import './sub_pages/shift_page.dart';
import './sub_pages/setting_page.dart';

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    SafeArea(child: HomePage()),
    SafeArea(child: OrderPage()),
    SafeArea(child: ShiftPage()),
    SafeArea(child: SettingPage()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Shift',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
