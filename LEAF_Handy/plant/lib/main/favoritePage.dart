// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
