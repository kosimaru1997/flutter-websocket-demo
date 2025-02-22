import 'package:flutter/material.dart';
import 'package:flutter_application_sample/api/sample_request.dart';
import 'package:flutter_application_sample/models/chatRoom.dart'; 
import 'package:flutter_application_sample/screens/chat_room.dart';
import 'package:flutter_application_sample/websocket/websocket_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({Key? key}) : super(key: key);

  @override
  ChatRoomListState createState() => ChatRoomListState();
}

class ChatRoomListState extends State<ChatRoomList> {
  List<ChatRoomDto>? chatRoomData; // APIレスポンスを格納するリスト
  bool isLoading = true; // ローディング状態を管理

  @override
  void initState() {
    super.initState();
    fetchChatRoomData(); // 初期化時にデータを取得
    WebSocketManager().connect(dotenv.get('WEBSOCKET_ENDPOINT'));
  }

  Future<void> fetchChatRoomData() async {
    try {
      final results = await sampleRequest(); // APIからデータを取得
      print(results); // デバッグ用に出力

      // resultsがマップ形式であることを確認
      if (results is Map<String, dynamic> && results.containsKey('room_list')) {
        setState(() {
          // room_listからChatRoomDtoのリストを取得
          chatRoomData = (results['room_list'] as List)
              .map((room) => ChatRoomDto.fromJson(room)) // ChatRoomDtoに変換
              .toList();
          isLoading = false; // ローディングを終了
        });
      } else {
        setState(() {
          chatRoomData = null; // エラー時はnullを格納
          isLoading = false; // ローディングを終了
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        chatRoomData = null; // エラー時はnullを格納
        isLoading = false; // ローディングを終了
      });
    }
  }

  void navigateToChatRoom(ChatRoomDto chatRoom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoom(roomId: "1",), // ChatRoom画面に遷移
      ),
    );
  }

  @override
  void dispose() {
    WebSocketManager().disconnect(); // WebSocket接続を切断
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('チャットルーム')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // データ取得中はローディングインジケーターを表示
            : chatRoomData == null || chatRoomData!.isEmpty
                ? const Text('No data available') // データがない場合のメッセージ
                : ListView.builder(
                    itemCount: chatRoomData!.length,
                    itemBuilder: (context, index) {
                      final chatRoom = chatRoomData![index];
                      return GestureDetector(
                        onTap: () =>
                            navigateToChatRoom(chatRoom), // カードをタップしたときの処理
                        child: Card(
                          margin: const EdgeInsets.all(8.0), // カードの外側のマージン
                          child: Padding(
                            padding: const EdgeInsets.all(16.0), // カード内のパディング
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'チャットルーム: ${chatRoom.roomId}', // チャットルームIDを表示
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8), // スペーサー
                                Text(
                                  'メッセージ: ${chatRoom.lastMessage ?? 'No messages'}', // 最後のメッセージを表示
                                ),
                                Text(
                                  '未確認メッセージ数: ${chatRoom.uncheckedCount}', // 未確認メッセージ数を表示
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ), // レスポンスメッセージをカード形式でリスト表示
      ),
    );
  }
}
