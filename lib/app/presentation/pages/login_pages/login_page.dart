import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController securityCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final AuthRepository authRepository = AuthRepository();
  bool _isLoading = false;
  bool _rememberMe = false;

  void _login() async {
    String securityCode = securityCodeController.text;
    String password = passwordController.text;
    Map<String, dynamic>? userData =
        await authRepository.login(securityCode, password);
    if (userData['success'] == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successfully.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign in',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80),
            Text(
              "Waiter code",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: securityCodeController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Enter your waiter code',
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Password",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text("Remember Me"),
              ],
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _login,
                    child: Text("Login",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 202, 156, 94),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        minimumSize: Size.fromHeight(40)),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    securityCodeController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
