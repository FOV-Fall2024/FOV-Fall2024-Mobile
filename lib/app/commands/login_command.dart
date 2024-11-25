import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/routes.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';

Future<void> loginCommand({
  required BuildContext context,
  required String securityCode,
  required String password,
  required IAuthRepository authRepository,
}) async {
  Map<String, dynamic>? userData =
      await authRepository.login(securityCode, password);

  if (userData['success'] == true) {
    Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to sign in. Please try again.'),
      ),
    );
  }
}
