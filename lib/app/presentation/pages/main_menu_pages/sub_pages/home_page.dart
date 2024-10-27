import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/test_pages/location_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/setting_page.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isChecked = false;
  String _currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onContainerTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _onContainerTapped,
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('avatar.png'),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Doe',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Waiter',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 100),
                // Bell Icon
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.notification);
                  },
                ),
              ],
            ),
            SizedBox(height: 80),
            Center(
              child: Column(
                children: [
                  Text(
                    'Current Time: $_currentTime',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Attendance Status: ${_isChecked ? "Checked" : "Not Yet"}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: _isChecked ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isChecked
                        ? null
                        : () {
                            setState(() {
                              _isChecked = true;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationPage()));
                          },
                    child: Text(
                      'Take Attendance',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(80),
                      backgroundColor:
                          _isChecked ? Colors.grey : Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
