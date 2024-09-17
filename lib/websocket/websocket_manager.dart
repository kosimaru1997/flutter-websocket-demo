import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'dart:io'; // Assuming you're using a WebSocket from dart:io

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  static WebSocketChannel? _channel;
  static bool _isConnected = false;

  factory WebSocketManager() {
    return _instance;
  }

  WebSocketManager._internal();

  WebSocket? _webSocket; // WebSocket instance
  StreamController<String> _controller = StreamController<String>.broadcast();
  Stream<String> get stream => _controller.stream;

  void connect(String endpoint) async {
    if (!_isConnected) {
      _webSocket = await WebSocket.connect(endpoint);
      print('☆☆☆☆☆☆☆---------websocket connected---------☆☆☆☆☆☆☆');
      _isConnected = true;
      _webSocket!.listen((message) {
        print(message);
        _controller.add(message); // Add incoming messages to the stream
      }, onError: (error) {
        print(error);
        print('[LISTENER ERROR]----------WebSocket connection closed with error---------');
        _controller.addError(error);
        connect(endpoint); // Reconnect to the WebSocket
      }, onDone: () {
        dispose();
        print('----------WebSocket connection closed---------');
        _isConnected = false;
      });

      Timer.periodic(Duration(minutes: 5), (timer) {
        if (_isConnected) {
          print('ping');
          _webSocket!.add('ping'); // Pingメッセージを送信
        } else {
          timer.cancel(); // 接続が切れたらタイマーをキャンセル
        }
      });

      // WebSocketの状態を確認するタイマー
      Timer.periodic(Duration(seconds: 10), (timer) {
        if (!_isConnected) {
          timer.cancel();
        }
        if (_isConnected && _webSocket?.readyState != WebSocket.open) {
          print('[TIMER] WebSocket is not open, attempting to reconnect...');
          timer.cancel();
          connect(endpoint); // 再接続を試みる
        }
      });
    }
  }

  WebSocketChannel? get channel => _channel;

  void disconnect() {
    if (_isConnected) {
      _webSocket?.close();
      _channel = null;
      _isConnected = false;
    }
  }

  void dispose() {
    // _controller.close(); // Close the StreamController
    _channel?.sink.close();
    _webSocket?.close(); // Close the WebSocket connection
    _isConnected = false;
  }

  void closeListener() {
    // _controller.close(); // Close the StreamController
    print('WebSocket listener closed');
  }

  void sendMessage(String message) {
    _webSocket?.add(message); // Send a message through the WebSocket
  }
}
