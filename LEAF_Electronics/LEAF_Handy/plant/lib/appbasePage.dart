// ignore_for_file: file_names, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant/appbasepage/02Contorl/control.dart';
import 'package:plant/appbasepage/01Data/dataNGraph.dart';
import 'package:plant/appbasepage/00Home/home.dart';
import 'package:plant/appbasepage/03Robot/robot.dart';
import 'package:plant/appbasepage/04Setting/setting.dart';

class AppBasePage extends StatefulWidget {
  const AppBasePage({super.key});

  @override
  State<AppBasePage> createState() => _AppBasePageState();
}

class _AppBasePageState extends State<AppBasePage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  double? _size;
  final String _databaseURL =
      'https://plantsquare-589ae-default-rtdb.firebaseio.com/';
  String? id;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference();
    _size = 25;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          '박재형의 식물공장',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: TabBarView(
        children: [Home(), DataNGraph(), Control(), Robot(), Setting()],
        controller: _controller,
      ),
      bottomNavigationBar: Container(
        color: Colors.green,
        child: TabBar(
          tabs: <Tab>[
            Tab(
              icon: Icon(
                Icons.home,
                size: _size,
              ),
              text: '홈',
            ),
            Tab(
              icon: Icon(
                Icons.auto_graph,
                size: _size,
              ),
              text: '데이터',
            ),
            Tab(
              icon: Icon(
                Icons.devices,
                size: _size,
              ),
              text: '컨트롤',
            ),
            Tab(
              icon: Icon(
                Icons.home_repair_service,
                size: _size,
              ),
              text: '로봇',
            ),
            Tab(
              icon: Icon(
                Icons.settings,
                size: _size,
              ),
              text: '설정',
            ),
          ],
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.white, //<-- Unselected text color
          controller: _controller,
          isScrollable: false, // <-- add this line
        ),
      ),
    );
  }
}
