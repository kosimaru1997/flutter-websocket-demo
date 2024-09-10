import 'package:flutter/material.dart';
import 'package:flutter_application_sample/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
           backgroundColor: Colors.white,
         ),
          textTheme: Theme.of(context).textTheme.apply(
               bodyColor: Colors.black,
             ),
        ),
      home: const HomeScreen(),
    );
  }
}