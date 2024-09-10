import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Scout extends StatefulWidget {
  const Scout({required Key key}) : super(key: key);

  @override
  _ScoutState createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
  List<Map<String, dynamic>>? scoutData; // APIレスポンスを格納するリスト
  bool isLoading = true; // ローディング状態を管理する変数

  @override
  void initState() {
    super.initState();
    fetchScoutData(); // 初期化時にデータを取得
  }

  Future<void> fetchScoutData() async {
    final url = Uri.parse('http://localhost:8003/api/scout'); // APIのURL
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          // レスポンスからscoutデータを取得
          scoutData = List<Map<String, dynamic>>.from(
              json.decode(response.body)['scout']);
          isLoading = false; // ローディングを終了
        });
      } else {
        setState(() {
          scoutData = null; // エラーメッセージを格納
          isLoading = false; // ローディングを終了
        });
      }
    } catch (e) {
      setState(() {
        scoutData = null; // 例外処理
        isLoading = false; // ローディングを終了
      });
    }
  }

  void navigateToDetailScreen(Map<String, dynamic> scout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(scout: scout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[50],
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator() // データ取得中はローディングインジケーターを表示
            : scoutData == null || scoutData!.isEmpty
                ? const Text('No data available') // データがない場合のメッセージ
                : ListView.builder(
                    itemCount: scoutData!.length,
                    itemBuilder: (context, index) {
                      final scout = scoutData![index];
                      return GestureDetector(
                        onTap: () => navigateToDetailScreen(scout), // カードをタップしたときの処理
                        child: Card(
                          margin: const EdgeInsets.all(8.0), // カードの外側のマージン
                          child: Padding(
                            padding: const EdgeInsets.all(16.0), // カード内のパディング
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '紹介会社: ${scout['displayed_name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8), // スペーサー
                                Text('${scout['scout_message']}'),
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

// 詳細画面のクラス
class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> scout;

  const DetailScreen({Key? key, required this.scout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スカウト')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '紹介会社: ${scout['displayed_name']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('メッセージ: ${scout['scout_message']}', style: const TextStyle(fontSize: 18)),
            // 他の詳細情報をここに追加できます
          ],
        ),
      ),
    );
  }
}
