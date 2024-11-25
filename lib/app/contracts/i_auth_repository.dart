abstract class IAuthRepository {
  Future<Map<String, dynamic>> login(String code, String password);
  Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword, String confirmPassword);
  Future<Map<String, dynamic>> profileDetail();
  Future<Map<String, dynamic>> editProfile(
      String address, String lastName, String firstName);

  Future<void> storeUserInfo(Map<String, dynamic> metadata);
  Future<String?> getToken();
  Future<String?> getFullname();
  Future<String?> getUserId();
  Future<String?> getRestaurantId();
  Future<void> deleteToken();
  Future<void> deleteAllToken();
}
