// ignore_for_file:  file_names

import 'package:flutter/material.dart';
import 'package:plant/appbasepage/01Data/DetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataNGraph extends StatefulWidget {
  List<String>? devices;
  int? index;

  DataNGraph({
    Key? key,
    this.devices,
    this.index,
  }) : super(key: key);

  @override
  State<DataNGraph> createState() => _DataNGraphState();
}

class _DataNGraphState extends State<DataNGraph> {
  List<String> devices = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    getItems().then((value) {
      setState(() {
        devices = value;
      });
    });
  }

  void addItem() {
    TextEditingController _controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("새 기기 등록"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "새 기기 이름",
                  textAlign: TextAlign.left,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "이름을 입력하세요",
                  ),
                  controller: _controller,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("등록"),
                onPressed: () {
                  setState(() {
                    devices.add(_controller.text);
                    saveItems(devices);
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("취소"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void removeItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("기기 제거"),
            content: Text("해당 기기 (${devices[index]}) 를 제거하시겠습니까?"),
            actions: [
              TextButton(
                child: const Text("네"),
                onPressed: () {
                  setState(() {
                    devices.removeAt(index);
                    saveItems(devices);
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("아니오"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _onGridItemClicked(int index) {
    // Add the navigation to a new page here
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DetailPage(
          index: index,
          devices: devices,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void saveItems(List<String> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("items", items);
  }

// Retrieve the items list from shared preferences
  Future<List<String>> getItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("items") ?? [];
  }

  Future<bool> resetSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  Widget _padding(int index) {
    return GestureDetector(
      onLongPress: () {
        removeItem(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => _onGridItemClicked(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.green,
            ),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                '${devices[index]}',
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _paddingLastItem() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: FloatingActionButton(
        onPressed: addItem,
        child: const Text(
          '+',
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4 / 3,
                children: List.generate(devices.length + 1, (int index) {
                  return index == devices.length
                      ? _paddingLastItem()
                      : _padding(index);
                }),
              ),
            ),
          ),
          Center(
              child: TextButton(
            child: const Text('Debug: Reset'),
            onPressed: () {
              resetSharedPreferences();
            },
          ))
        ],
      ),
    );
  }
}
