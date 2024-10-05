import 'package:redis/redis.dart';

class RedisService {

  Future<void> storeDRMtoRedis(
      String? deviceRecogitionToken, String userId) async {
    final conn = RedisConnection();
    try {
      conn.connect('vktrng.ddns.net', 6380).then((Command redisCommand){
        redisCommand
            .send_object(["HSET", "user_token", userId, deviceRecogitionToken]);
        redisCommand.get_connection().close();
      });
    } catch (e) {
      print('Error storing token: $e');
    }
  }
}
