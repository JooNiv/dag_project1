import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class SettingsService extends GetxController {
  final storage = Hive.box("settings");

  saveSettingAsync(String key, dynamic value) async {
    await storage.put(key, value);
    update();
  }

  getName() {
    return storage.get("name") ?? "User";
  }

  getColorSettings() {
    return storage.get("colorSettings") ?? {
      "Very Bad": const Color.fromARGB(255, 156, 39, 176), // Purple
      "Bad": const Color.fromARGB(255, 236, 8, 8), // Red
      "Okay": const Color.fromARGB(255, 255, 153, 0), // Orange
      "Good": const Color.fromARGB(255, 255, 235, 59), // Yellow
      "Very Good": const Color.fromARGB(255, 76, 175, 80), // Green
    };
  }
}