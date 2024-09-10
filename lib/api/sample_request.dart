import 'dart:convert';
import 'package:http/http.dart' as http; // httpという変数を通して、httpパッケージにアクセス

Future<dynamic> sampleRequest() async {
  // 1. http通信に必要なデータを準備をする
  //   - URL、クエリパラメータの設定
  final url = Uri.parse('http://localhost:8003/api/chat/');

  final http.Response res = await http.get(url);

  // 3. 戻り値をArticleクラスの配列に変換
  // 4. 変換したArticleクラスの配列を返す(returnする)
  if (res.statusCode == 200) {
    // レスポンスをモデルクラスへ変換
    // final List<dynamic> body = jsonDecode(res.body);
    final dynamic body = jsonDecode(res.body);
    return body;
  } else {
    // エラー時は、レスポンスを型指定せずにObjectに変換して返す
    final dynamic body = jsonDecode(res.body);
    return body;
  }
}
