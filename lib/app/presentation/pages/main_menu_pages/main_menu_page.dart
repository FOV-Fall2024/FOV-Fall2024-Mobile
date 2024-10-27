import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import './sub_pages/home_page.dart';
import './sub_pages/shift_page.dart';
import './sub_pages/order_page.dart';
import './sub_pages/paycheck_page.dart';
import './sub_pages/clockout_page.dart';

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  static List<Widget> _pages = <Widget>[
    SafeArea(child: HomePage()),
    SafeArea(child: ShiftPage()),
    SafeArea(child: OrderPage()),
    SafeArea(child: PaycheckPage()),
    SafeArea(child: ClockoutPage()),
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
          TabItem(icon: Icons.work, title: 'Shift'),
          TabItem(icon: Icons.restaurant_menu, title: 'Order'),
          TabItem(icon: Icons.request_quote, title: 'Paycheck'),
          TabItem(icon: Icons.do_not_disturb_on, title: 'Clockout'),
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
