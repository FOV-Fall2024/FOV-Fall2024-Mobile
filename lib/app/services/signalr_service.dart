import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();

  factory SignalRService() {
    return _instance;
  }

  SignalRService._internal() {
    _hubConnection = HubConnectionBuilder()
        .withUrl("http://vktrng.ddns.net:8080/notification-hub")
        .withAutomaticReconnect(
            retryDelays: [2000, 5000, 10000, 20000]).build();
    _hubConnection.on("ReceiveNotificationToWaiter", _handleNotification);
  }

  late HubConnection _hubConnection;
  final StreamController<Map<String, String>> _notificationStreamController =
      StreamController<Map<String, String>>.broadcast();

  Stream<Map<String, String>> get notificationStream =>
      _notificationStreamController.stream;

  Future<void> connect(String employeeId, String role) async {
    await _hubConnection.start();
    print("Connected to SignalR");
    await _hubConnection.invoke("SendEmployeeId", args: [employeeId, role]);
  }

  void _handleNotification(List<Object?>? args) {
    if (args != null && args.length == 2) {
      var orderId = args[0] as String;
      var orderDetailId = args[1] as String;

      _notificationStreamController.add({
        'orderId': orderId,
        'orderDetailId': orderDetailId,
      });
    }
  }

  void disconnect() {
    _hubConnection.stop();
    _notificationStreamController.close();
    print("Disconnected from SignalR");
  }
}
