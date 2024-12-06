import 'package:http/http.dart' as http;

class FcmTokenRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/FCMToken';
  Future<void> sendFCMtoken(String userId, String? fcmToken) async =>
      await http.post(Uri.parse('$_baseUrl/user/$userId/token/$fcmToken'));
}
