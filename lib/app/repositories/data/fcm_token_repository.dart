import 'package:http/http.dart' as http;
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_fcmToken_repository.dart';

class FcmTokenRepository implements IFcmtokenRepository {
  final String baseUrl = 'http://vktrng.ddns.net:8080/api/FCMToken';
  Future<void> sendFCMTokenWithUserId(String userId, String fcmToken) async {
    http.get(Uri.parse('$baseUrl/user/$userId/token/$fcmToken'));
  }
}
