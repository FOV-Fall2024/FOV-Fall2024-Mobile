import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/location_service.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class TakeAttendancePage extends StatefulWidget {
  @override
  _TakeAttendancePageState createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription<Object?>? _subscription;
  bool scanned = false;
  RespondStatus rs = RespondStatus(status: false, message: '');
  final _locationService = LocationService();
  //QR attribute
  double? _latitude;
  double? _longitude;
  String? _userId = '';

  final attendanceRepository = AttendanceRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);
    controller.start();
  }

  // Barcode handling function
  void _handleBarcode(BarcodeCapture capture) async {
    final String? qrCodeData = capture.barcodes.first.rawValue;

    if (qrCodeData != null && !scanned) {
      setState(() {
        scanned = true;
      });
      await _fetchLocation();
      await _fetchUserId();

      try {
        if (_latitude != null &&
            _longitude != null &&
            _userId != null &&
            _userId!.isNotEmpty) {
          // Perform check-in
          final response = await attendanceRepository.checkIn(
            qrCodeData,
            _userId!,
            _latitude!,
            _longitude!,
          );

          if (response['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(response['message'] ?? 'Check-in successful!')),
            );
            setState(() {
              rs = RespondStatus.success(
                  response['message'] ?? 'Check-in successful!');
            });
          } else {
            String errorMessage = response['error'] ?? 'Check-in failed.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
            setState(() {
              rs = RespondStatus.error(errorMessage);
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Missing location or user ID for check-in.')),
          );
          setState(() {
            rs = RespondStatus(
                status: false,
                message:
                    'You need to provide location access for this to work!');
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        controller.stop();
      }
    }
  }

  Future<void> _fetchLocation() async {
    bool hasPermission = await _locationService.checkLocationPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services.')),
      );
      return;
    }

    // Get current position
    Position position = await _locationService.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _fetchUserId() async {
    String? id = await GetIt.I<IAuthRepository>().getUserId();
    setState(() {
      _userId = id;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
        controller.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _subscription?.cancel();
        _subscription = null;
        controller.stop();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(
            children: [
              if (!scanned)
                MobileScanner(
                  controller: controller,
                ),
              if (!scanned)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 4),
                          ),
                        ),
                        SizedBox(height: 100),
                        Card(
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Scan QR code provided by your manager to take attendance',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Scanned Status and Return Button
              if (scanned)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          rs.status ? Icons.check_circle : Icons.cancel,
                          color: rs.status ? Colors.green : Colors.red,
                          size: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          rs.message,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        if (rs.status)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.mainMenu);
                            },
                            child: Text('Return to Home Screen'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                          ),
                        if (!rs.status)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TakeAttendancePage()));
                            },
                            child: Text('Take attendance again'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _subscription?.cancel();
    _subscription = null;
    await controller.dispose();
    super.dispose();
  }
}

class RespondStatus {
  final bool status;
  final String message;

  RespondStatus({required this.status, required this.message});

  factory RespondStatus.success(String message) =>
      RespondStatus(status: true, message: message);
  factory RespondStatus.error(String message) =>
      RespondStatus(status: false, message: message);
}
