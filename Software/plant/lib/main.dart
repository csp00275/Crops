// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:plant/signPage.dart';
import 'package:plant/loginPage.dart';
import 'package:plant/appbasePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //MobileAds.instance.initialzie();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Sqaure',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/sign': (context) => SignPage(),
        '/base': (context) => AppBasePage(),
      },
    );
  }
}
