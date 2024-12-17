import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:get_it/get_it.dart';
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
  final authRepository = GetIt.I<IAuthRepository>();

  List<Widget> _pages = [];
  List<TabItem> _tabItems = [];

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
  void initState() {
    super.initState();
    _initializeUserRole();
  }

  Future<void> _initializeUserRole() async {
    final userRole = await authRepository.getRole();
    setState(() {
      switch (userRole) {
        case 'Waiter':
          _pages = [
            SafeArea(child: HomePage()),
            SafeArea(child: OrderPage()),
            SafeArea(child: SchedulePage()),
          ];
          _tabItems = [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.restaurant_menu, title: 'Order'),
            TabItem(icon: Icons.date_range, title: 'Schedule'),
          ];
          break;
        case 'Chef':
          _pages = [
            SafeArea(child: HomePage()),
            SafeArea(child: SchedulePage()),
          ];
          _tabItems = [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.date_range, title: 'Schedule'),
          ];
          break;
        default:
          _pages = [];
          _tabItems = [];
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to disable back button functionality
        return false;
      },
      child: Scaffold(
        body: _pages.isEmpty
            ? Center(child: CircularProgressIndicator())
            : PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: _pages,
                physics: NeverScrollableScrollPhysics(),
              ),
        bottomNavigationBar: _tabItems.isEmpty
            ? SizedBox.shrink()
            : ConvexAppBar(
                items: _tabItems,
                initialActiveIndex: _selectedIndex,
                onTap: _onItemTapped,
                style: _tabItems.length.isOdd
                    ? TabStyle.fixedCircle
                    : TabStyle.reactCircle,
                color: Colors.grey,
                backgroundColor: Colors.white,
                activeColor: Colors.orange,
              ),
      ),
    );
  }
}
