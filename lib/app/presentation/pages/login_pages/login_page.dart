import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/commands/home_page_command.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/sub_pages/take_attendance_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _securityCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final authRepository = GetIt.I<IAuthRepository>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('security_code') && prefs.containsKey('password')) {
      _securityCodeController.text = prefs.getString('security_code')!;
      _passwordController.text = prefs.getString('password')!;
      _rememberMe = true;
      _autoLogin();
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('security_code', _securityCodeController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('security_code');
      await prefs.remove('password');
    }
  }

  Future<void> _autoLogin() async {
    if (_securityCodeController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      final response = await authRepository.login(
        _securityCodeController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login successful')));
        Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
      } else {
        String errorMessage = response['error'] ?? 'Login failed';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                'Welcome!!',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _securityCodeController,
                decoration: InputDecoration(
                  labelText: 'Security Code',
                  hintText: 'Enter your security code',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _rememberMe = newValue!;
                      });
                    },
                  ),
                  Text('Remember me'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final response = await authRepository.login(
      _securityCodeController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login successful')));
      _saveCredentials();
      Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
      String errorMessage = response['error'] ?? 'Login failed';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
