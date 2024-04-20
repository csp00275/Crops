// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plant/data/control_data.dart';

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (int itemsIndex = 0; itemsIndex < items.length; itemsIndex++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          items[itemsIndex].nameOfTitle,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              for (int index = 0;
                                  index < items[itemsIndex].restOfTitle.length;
                                  index++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            items[itemsIndex]
                                                .restOfTitle[index],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // 버튼이 클릭됐을 때 수행할 동작
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 40,
                                            minHeight: 40,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 100,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          '${items[itemsIndex].counters[index]}',
                                          style: const TextStyle(
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 40,
                                            minHeight: 40,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // ControlButton(
                                      //   onPressed: _incrementCounter(
                                      //       itemsIndex, index),
                                      //   plusMinus: '+',
                                      //   itemsIndex: itemsIndex,
                                      //   index: index,
                                      // ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    ));
  }

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
}

class ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String plusMinus;
  final int itemsIndex;
  final int index;

  const ControlButton(
      {required this.onPressed,
      required this.plusMinus,
      required this.index,
      required this.itemsIndex,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
