import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/location_service.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationService _locationService = LocationService();
  double? _latitude;
  double? _longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'temp page to get location, should run this background; foreground is for camera taking QR code.'),
              SizedBox(height: 40),
              Text('LAT: ${_latitude ?? 'Loading...'}'),
              Text('LNG: ${_longitude ?? 'Loading...'}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _fetchLocation,
                child: const Text("Get Current Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fetches the current location
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
}
