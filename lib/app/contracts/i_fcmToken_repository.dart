abstract class IFcmtokenRepository {
  Future<void> sendFCMTokenWithUserId(String userId, String fcmToken);
}
