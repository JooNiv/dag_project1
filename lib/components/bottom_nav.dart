import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'responsive_widget.dart';
import 'buttons.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  final date = DateTime.now();

  final dateTimeString =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        mobile: Container(
            height: 50,
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/"),
                    icon: const Icon(Icons.home, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/entry/$dateTimeString"),
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/settings"),
                    icon: const Icon(Icons.settings, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/statistics"),
                    icon: const Icon(Icons.bar_chart, color: Colors.black),
                  ),
                ),
              ],
            )),
        tablet: Container(
            height: 50,
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/"),
                    icon: const Icon(Icons.home, color: Colors.black),
                    text: "Home",
                  ),
                ),
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/entry/$dateTimeString"),
                    icon: const Icon(Icons.add, color: Colors.black),
                    text: "Add Entry",
                  ),
                ),
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/settings"),
                    icon: const Icon(Icons.settings, color: Colors.black),
                    text: "Settings",
                  ),
                ),
                Expanded(
                  child: NavDrawerButtons(
                    onPressed: () => Get.toNamed("/statistics"),
                    icon: const Icon(Icons.bar_chart, color: Colors.black),
                    text: "Statistics",
                  ),
                ),
              ],
            )),
        desktop: Container(
          height: 50,
          color: Colors.blueGrey,
          child: const Center(
            child: Text(
              "Made by Joonas with Flutter",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
