import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_sample/websocket/websocket_manager.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http; // HTTPリクエスト用のパッケージをインポート

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatRoom extends StatefulWidget {
  final String roomId; // room_idを受け取る

  const ChatRoom({Key? key, required this.roomId}) : super(key: key);

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  StreamSubscription? _subscription;
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '1');

  @override
  void initState() {
    super.initState();
    fetchChatRoomMessages(); // 初期化時にメッセージを取得
    WebSocketManager().connect(dotenv.get('WEBSOCKET_ENDPOINT'));
    _listenForMessages(); // メッセージのリスナーを設定
  }

  Future<void> fetchChatRoomMessages() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8003/api/chat/${widget.roomId}')); // APIリクエストを送信

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // ここでレスポンスを処理し、_messagesに追加します
      final messages = (data as List)
          .map((d) => types.TextMessage(
                author: types.User(id: d['user_id']),
                createdAt: int.parse(d['created_at']), // 修正: 文字列をintに変換
                id: randomString(),
                text: d['message'],
              ))
          .toList();
      setState(() {
        _messages.addAll(messages); // 取得したメッセージを追加
      });
    } else {
      // エラーハンドリング
      print('Failed to load messages: ${response.statusCode}');
    }
  }

  void _listenForMessages() {
    final channel = WebSocketManager().channel;
    if (channel != null) {
      final broadcastStream = channel.stream.asBroadcastStream();
      // 既存のリスナーがある場合は、リスナーを解除
      _subscription = broadcastStream.listen((message) {
        print('WebSocket message: $message');
        final decodedMessage = jsonDecode(message); // JSONをデコード

        // types.TextMessageに変換
        final textMessage = types.TextMessage(
          author: types.User(id: decodedMessage['user_id']),
          createdAt: decodedMessage['created_at'],
          id: randomString(), // 一意のIDを生成
          text: decodedMessage['message'],
        );

        setState(() {
          _messages.add(textMessage); // 受信したメッセージをリストに追加
        });
      }, onError: (error) {
        // エラーハンドリング
        print('WebSocket error: $error');
      }, onDone: () {
        // ストリームが終了した場合の処理
        print('WebSocket connection closed');
        print(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('チャット画面')),
        body: Chat(
          user: _user,
          messages: _messages,
          onSendPressed: _handleSendPressed,
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
