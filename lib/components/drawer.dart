import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'buttons.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SizedBox(
              width: double.infinity,
              child: NavDrawerButtons(
                onPressed: () => Get.toNamed("/welcome"),
                text: "Intro Screen",
              ),
            ),
          ),
          const SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SizedBox(
              width: double.infinity,
              child: NavDrawerButtons(
                onPressed: () => Get.toNamed("/settings"),
                text: "Settings",
              ),
            ),
          ),
          const SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SizedBox(
              width: double.infinity,
              child: NavDrawerButtons(
                onPressed: () => Get.toNamed("/"),
                text: "Home",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
