import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'Pages/Dashboard.dart';
import 'MainScreen.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const defaultPadding = 16.0;

void main() {
  GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static var screen;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    MyApp.screen = DashboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Tracking System',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF212332),
        canvasColor: secondaryColor,
      ),
      home: MainScreen(),
    );
  }
}