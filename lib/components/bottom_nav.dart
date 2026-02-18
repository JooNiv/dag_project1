import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.blueGrey,
      child: const Center(
        child: Text(
          "Made by Joonas with Flutter",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
