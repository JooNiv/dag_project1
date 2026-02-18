import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingButton extends StatelessWidget {
  final String route;
  final IconData icon;

  const FloatingButton({super.key, required this.route, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Get.toNamed(route),
      child: Icon(icon),
    );
  }
}