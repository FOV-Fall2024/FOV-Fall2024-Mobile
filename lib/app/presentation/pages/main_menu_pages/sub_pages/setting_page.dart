import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_storage_service.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/background_image_by_time.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/check_out_page.dart';
import 'package:get_it/get_it.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthRepository authRepository = AuthRepository();
  final storageService = GetIt.I<IStorageService>();
  String? _fullName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
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
                    leading: Icon(Icons.edit),
                    title: Text('Checkout'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckOutPage()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                    ),
                    onTap: () {
                      storageService.deleteAll();
                      Navigator.pushReplacementNamed(context, '/login');
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
