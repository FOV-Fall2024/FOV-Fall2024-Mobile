import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import './sub_pages/home_page.dart';
import './sub_pages/order_page.dart';
import './sub_pages/schedule_page.dart';

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  static List<Widget> _pages = <Widget>[
    SafeArea(child: HomePage()),
    SafeArea(
        child: OrderPage()), // This is the OrderPage that will be refreshed
    SafeArea(child: SchedulePage()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.restaurant_menu, title: 'Order'),
          TabItem(icon: Icons.date_range, title: 'Schedule'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
        style: TabStyle.fixedCircle,
        color: Colors.grey,
        backgroundColor: Colors.white,
        activeColor: Colors.orange,
      ),
    );
  }
}
