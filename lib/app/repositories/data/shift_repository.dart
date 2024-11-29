import 'dart:convert';
import 'package:fov_fall2024_waiter_mobile_app/app/entities/shift_entity.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_shift_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:http/http.dart' as http;

class ShiftRepository implements IShiftRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/Shift';

  Future<List<Shifts>> getShifts() async {
    final url = Uri.parse(_baseUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await AuthRepository().getToken()}'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> shiftList = json.decode(response.body);
      return shiftList.map((shift) => Shifts.fromJson(shift)).toList();
    } else {
      throw Exception('Failed to load shifts');
    }
  }
}
