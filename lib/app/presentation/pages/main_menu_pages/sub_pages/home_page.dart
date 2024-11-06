import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/background_image_by_time.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/test_pages/location_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/setting_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthRepository authRepository = AuthRepository();
  bool _isChecked = false;
  Timer? _timer;
  String? _fullName;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void _loadUserInfo() async {
    final fullName = await authRepository.getFullname();
    setState(() {
      _fullName = fullName ?? 'Unknown User';
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBackgroundImage()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withOpacity(0.0),
            ),
          ),
          Padding(
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
                                backgroundImage:
                                    AssetImage('lib/assets/icons/avatar.png'),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _fullName ?? 'Loading...',
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
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                      Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: AnalogClock(
                          dateTime: DateTime.now(),
                          isKeepTime: true,
                          hourHandColor: Colors.black,
                          minuteHandColor: Colors.black,
                          secondHandColor: Colors.red,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Attendance Status: ${_isChecked ? "Checked" : "Not Yet"}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: _isChecked ? Colors.green : Colors.amber,
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
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15),
                          ),
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            _isChecked ? Colors.grey : Colors.lightBlue,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
