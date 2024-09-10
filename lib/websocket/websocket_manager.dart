import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  static WebSocketChannel? _channel;
  static bool _isConnected = false;

  factory WebSocketManager() {
    return _instance;
  }

  WebSocketManager._internal();

  void connect(String url) {
    if (_channel == null) {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
    }
  }

  WebSocketChannel? get channel => _channel;

  void disconnect() {
    if (_isConnected) {
      _channel?.sink.close();
      _channel = null;
      _isConnected = false;
    }
  }
}