import 'package:flutter/material.dart';
import 'package:flutter_application_sample/screens/chat_room_list.dart';
import 'package:flutter_application_sample/screens/scout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  // 選択中フッターメニューのインデックスを一時保存する用変数
  int selectedIndex = 0;

  // 切り替える画面のリスト
  List<Widget> display = [
    HomePage(
      key: UniqueKey(),
    ),
    Scout(
      key: UniqueKey(),
    ),
    ChatRoomList(
      key: UniqueKey(),
    ),
    MyPage(
      key: UniqueKey(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sample App')),
        body: display[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none), label: 'スカウト'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'チャット'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'マイページ'),
          ],
          // 現在選択されているフッターメニューのインデックス
          currentIndex: selectedIndex,
          // フッター領域の影
          elevation: 1,
          // フッターメニュータップ時の処理
          onTap: (int index) {
            selectedIndex = index;
            setState(() {});
          },
          // 選択中フッターメニューの色
          fixedColor: Colors.cyan,
        ));
  }
}

// --------- 切り替える画面 -----------
class HomePage extends StatelessWidget {
  const HomePage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('ホーム'));
  }
}

class Notice extends StatelessWidget {
  const Notice({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[50],
      child: const Center(child: Text('スカウト')),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      child: const Center(child: Text('マイページ')),
    );
  }
}
