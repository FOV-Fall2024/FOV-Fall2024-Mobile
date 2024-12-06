import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/location_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage>
    with WidgetsBindingObserver {
  final _locationService = LocationService();
  final attendanceRepository = AttendanceRepository();
  bool isLoading = false;

  // QR attributes
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      const shiftId = "exampleShiftId";
      final date = dateFormat.format(DateTime.now());

      final response = await attendanceRepository.checkOut(
        shiftId,
        date,
        _latitude!,
        _longitude!,
      );

      if (response['success'] == true) {
        _showStatusDialog(true, response['message'] ?? 'Check-out successful!');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap here to checkout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleCheckout,
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text('Check Out'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
