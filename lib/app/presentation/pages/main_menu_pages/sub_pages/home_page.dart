import 'dart:ui';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/background_image_by_time.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/take_attendance_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/setting_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/commands/home_page_command.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/location_service.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_storage_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authRepository = GetIt.I<IAuthRepository>();
  final attendanceRepository = GetIt.I<IAttendanceRepository>();
  final storageService = GetIt.I<IStorageService>();
  late Future<AttendanceStatus> futureMatch;
  Timer? _timer;
  String? _fullName;
  final _locationService = LocationService();
  double? _latitude;
  double? _longitude;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    futureMatch = AttendanceShiftService().isUserCheckIn();
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

  Future<void> _fetchLocation() async {
    bool hasPermission = await _locationService.checkLocationPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services.')),
      );
      return;
    }
    Position position = await _locationService.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _handleCheckout() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    setState(() {
      isLoading = true;
    });

    await _fetchLocation();

    if (_latitude == null || _longitude == null) {
      setState(() {
        isLoading = false;
      });
      _showStatusDialog(false, 'Unable to retrieve location.');
      return;
    }

    try {
      String? shiftId = await storageService.read("currentShift");
      final date = dateFormat.format(DateTime.now());

      final response = await attendanceRepository.checkOut(
        shiftId.toString(),
        date,
        _latitude!,
        _longitude!,
      );

      if (response['success'] == true) {
        _showStatusDialog(true, response['message'] ?? 'Check-out successful!');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showStatusDialog(false, response['error'] ?? 'Check-out failed.');
      }
    } catch (e) {
      _showStatusDialog(false, 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showStatusDialog(bool isSuccess, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? Colors.green : Colors.red,
            size: 60,
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                      FutureBuilder<AttendanceStatus>(
                        future: futureMatch,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            switch (snapshot.data) {
                              case AttendanceStatus.noSchedule:
                                return textWithWhiteBackground(
                                    'No shift assigned to you for the next 15 minutes',
                                    Colors.black);
                              case AttendanceStatus.userIsCheckIn:
                                return Column(
                                  children: [
                                    textWithWhiteBackground(
                                        'Attendance Status:\nChecked In',
                                        Colors.green),
                                    ElevatedButton(
                                      onPressed: () {
                                        _handleCheckout();
                                      },
                                      child: Text('Check out'),
                                    ),
                                  ],
                                );
                              case AttendanceStatus.userIsNotCheckIn:
                                return Column(
                                  children: [
                                    textWithWhiteBackground(
                                        'Attendance Status:\nNot Checked In',
                                        Colors.deepOrangeAccent),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TakeAttendancePage()),
                                        );
                                      },
                                      child: Text('Take Attendance'),
                                    ),
                                  ],
                                );
                              case AttendanceStatus.noShiftMatch:
                                return textWithWhiteBackground(
                                    'No Shift Found.\nPlease contact your manager.',
                                    Colors.red);
                              case null:
                                return textWithWhiteBackground(
                                    'No Shift Found.\nPlease contact your manager.',
                                    Colors.red);
                            }
                          }
                          return Center(
                            child: Text(
                              'Unknown Status',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        },
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

Widget textWithWhiteBackground(String txtString, Color txtColor) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.white60),
    child: Text(
      txtString,
      textAlign: TextAlign.center,
      style:
          TextStyle(fontSize: 24, color: txtColor, fontWeight: FontWeight.bold),
    ),
  );
}
