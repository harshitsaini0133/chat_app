import 'package:socket_io_client/socket_io_client.dart';
import '../api/api_routes.dart';
import '../services/local_storage.dart';

class SocketService {
  Socket? _socket;

  Socket get socket {
    if (_socket == null) {
      throw Exception("Socket not initialized");
    }
    return _socket!;
  }

  Future<void> connect() async {
    final token = await LocalStorage().getToken();

    _socket = io(
      ApiConstants.baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders(
            token != null ? {'Authorization': token} : {},
          ) // Adjust based on how backend expects token
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {});

    _socket!.onConnectError((data) {});

    _socket!.onDisconnect((_) {});
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void emit(String event, dynamic data) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(event, data);
    } else {}
  }

  void on(String event, Function(dynamic) callback) {
    if (_socket != null) {
      _socket!.on(event, callback);
    }
  }
}
