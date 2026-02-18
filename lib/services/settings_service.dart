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

  getRawName() {
    return storage.get("name");
  }

  getColorSettings() {
    final raw = storage.get("colorSettings");
    if (raw == null) {
      return {
        "Very Bad": const Color.fromARGB(255, 156, 39, 176),
        "Bad": const Color.fromARGB(255, 236, 8, 8),
        "Okay": const Color.fromARGB(255, 255, 153, 0),
        "Good": const Color.fromARGB(255, 255, 235, 59),
        "Very Good": const Color.fromARGB(255, 76, 175, 80),
      };
    }
    return Map<String, Color>.fromEntries(
      (raw as Map).entries.map(
            (e) => MapEntry(
              e.key.toString(),
              e.value is Color ? e.value : Color(e.value as int),
            ),
          ),
    );
  }

  resetColorSettings() async {
    await storage.delete("colorSettings");

    await storage.put("colorSettings", {
      "Very Bad": const Color.fromARGB(255, 156, 39, 176),
      "Bad": const Color.fromARGB(255, 236, 8, 8),
      "Okay": const Color.fromARGB(255, 255, 153, 0),
      "Good": const Color.fromARGB(255, 255, 235, 59),
      "Very Good": const Color.fromARGB(255, 76, 175, 80),
    });

    update();
  }

  removeAll() async {
    await storage.clear();
    update();
  }
}
