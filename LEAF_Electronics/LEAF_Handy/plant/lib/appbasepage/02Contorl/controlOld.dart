// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';

class ItemName {
  List<int> counters;
  String nameOfTitle;
  List<String> restOfTitle;

  ItemName(
      {required this.counters,
      required this.nameOfTitle,
      required this.restOfTitle});
}

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> with SingleTickerProviderStateMixin {
  final List<ItemName> items = [
    ItemName(
        counters: [700, 500, 20, 3],
        nameOfTitle: 'CO2',
        restOfTitle: ['CO2', 'LimitLow', 'Interval', 'Duration']),
    ItemName(
        counters: [500, 2, 20, 3],
        nameOfTitle: 'Hum',
        restOfTitle: ['Hum', 'LimitLow', 'Interval', 'Duration']),
    ItemName(
        counters: [700, 500, 20],
        nameOfTitle: 'Temp',
        restOfTitle: ['Temp', 'LimitLow', 'Interval']),
    ItemName(
        counters: [700, 500, 20, 3],
        nameOfTitle: 'EC',
        restOfTitle: ['EC', 'LimitLow', 'Interval', 'Duration']),
  ];
  Timer? _timer;

  void _incrementCounter(int itemIndex, int index) {
    setState(() {
      items[itemIndex].counters[index]++;
    });
  }

  void _decrementCounter(int itemIndex, int index) {
    setState(() {
      items[itemIndex].counters[index]--;
    });
  }

  Widget _pubControlValue(int itemIndex, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '${items[itemIndex].restOfTitle[index]}',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _decrementCounter(itemIndex, index),
                  onLongPressStart: (details) {
                    _timer = Timer.periodic(const Duration(milliseconds: 200),
                        (timer) {
                      _decrementCounter(itemIndex, index);
                    });
                  },
                  onLongPressEnd: (details) {
                    _timer!.cancel();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.orange,
                    child: const Center(
                      child: Expanded(
                        flex: 1,
                        child: Text(
                          '-',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      '${items[itemIndex].counters[index]}',
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _incrementCounter(itemIndex, index),
                  onLongPressStart: (details) {
                    if (_timer != null && _timer!.isActive) {
                      _timer!.cancel();
                    }
                    _timer = Timer.periodic(const Duration(milliseconds: 200),
                        (timer) {
                      _incrementCounter(itemIndex, index);
                    });
                  },
                  onLongPressEnd: (details) {
                    if (_timer != null && _timer!.isActive) {
                      _timer!.cancel();
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.orange,
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _asdf(int itemIndex) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //color: Colors.red,
            child: Text(
              items[itemIndex].nameOfTitle,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.lightGreen,
            child: Column(
              children: [
                for (int j = 0; j < items[itemIndex].restOfTitle.length; j++)
                  _pubControlValue(itemIndex, j),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, intindex) {
        return Column(
          children: [for (int i = 0; i < items.length; i++) _asdf(i)],
        );
      },
    ));
  }
}
