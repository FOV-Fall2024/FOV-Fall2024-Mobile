import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_storage_service.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/fcm_token_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/redis_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class AuthRepository implements IAuthRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/v1/Auth';
  final _storageService = GetIt.I<IStorageService>();
  final fcmTokenRepository = FcmTokenRepository();
  static final _firebaseMessaging = FirebaseMessaging.instance;
  final String _tokenKey = 'auth_token';
  //Save personal info
  final String _fullName = '_fullName';
  final String _employeeId = '_employeeId';
  final String _restaurantId = '_restaurantId';

  ///API related section
  // Login
  Future<Map<String, dynamic>> login(String code, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'code': code, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final fcmToken = await _firebaseMessaging.getToken();
        if (responseData['reasonStatusCode'] == 'Success') {
          await storeUserInfo(responseData['metadata']);
          await fcmTokenRepository.sendFCMtoken(
              responseData['metadata']['id'], fcmToken.toString());
          return {'success': true, 'data': responseData};
        }
        return {'success': false, 'error': 'Invalid token received'};
      } else {
        return {
          'success': false,
          'error': 'Failed to login',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    final url = Uri.parse('$_baseUrl/change-password');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}'
    };
    final body = jsonEncode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to change password',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // View (current) profile detail
  Future<Map<String, dynamic>> profileDetail() async {
    final url = Uri.parse('$_baseUrl/me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}'
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to fetch profile details',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Edit profile
  Future<Map<String, dynamic>> editProfile(
      String address, String lastName, String firstName) async {
    final url = Uri.parse('$_baseUrl/edit-profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}'
    };
    final body = jsonEncode({
      'address': address,
      'lastName': lastName,
      'firstName': firstName,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to edit profile',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  /// Flutter secure storage relate section
  // Store user info
  Future<void> storeUserInfo(Map<String, dynamic> metadata) async {
    await _storageService.write(_tokenKey, metadata['accessToken']);
    await _storageService.write(_fullName, metadata['fullName']);
    await _storageService.write(_employeeId, metadata['id']);
  }

  // Getter for storage
  Future<String?> getToken() async {
    return await _storageService.read(_tokenKey);
  }

  Future<String?> getFullname() async {
    return await _storageService.read(_fullName);
  }

  Future<String?> getUserId() async {
    return await _storageService.read(_employeeId);
  }

  Future<String?> getRestaurantId() async {
    return await _storageService.read(_restaurantId);
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storageService.delete(_tokenKey);
  }

  // Delete all token (for log out)
  Future<void> deleteAllToken() async {
    await _storageService.deleteAll();
  }
}
