import 'package:fov_fall2024_waiter_mobile_app/app/entities/attendance_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/commands/home_page_command.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_storage_service.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/background_image_by_time.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/location_service.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthRepository authRepository = AuthRepository();
  final _locationService = LocationService();
  final attendanceRepository = GetIt.I<IAttendanceRepository>();
  final storageService = GetIt.I<IStorageService>();
  String? _fullName;
  double? _latitude;
  double? _longitude;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
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
    DateFormat dateFormat = DateFormat("dd/MM/YYYY");
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
      // const shiftId = "exampleShiftId";
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

  void _loadUserName() async {
    final fullName = await authRepository.getFullname();
    setState(() {
      _fullName = fullName ?? 'Unknown User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getBackgroundImage()),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('lib/assets/icons/avatar.png'),
            ),
            SizedBox(height: 16),
            Text(
              _fullName ?? 'Loading...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Profile'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                    ),
                    onTap: () {
                      storageService.deleteAll();
                      _handleCheckout();
                    },
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
