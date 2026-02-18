import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';


class EntryService extends GetxController {
  final storage = Hive.box("entries");

  saveEntryAsync(String dateTimeString, String mood, String comment) async {
    await storage.put(dateTimeString, {"mood": mood, "comment": comment});
    update();
  }

  getEntry(String dateTimeString) {
    return storage.get(dateTimeString);
  }

  getColorForDate(String dateTimeString) {
    var entry = storage.get(dateTimeString);
    if (entry == null) {
      return Colors.transparent;
    }

    switch (entry["mood"]) {
      case "Very Bad":
        return const Color.fromARGB(255, 156, 39, 176); // Purple
      case "Bad":
        return const Color.fromARGB(255, 236, 8, 8); // Red
      case "Okay":
        return const Color.fromARGB(255, 255, 153, 0); // Orange
      case "Good":
        return const Color.fromARGB(255, 255, 235, 59); // Yellow
      case "Very Good":
        return const Color.fromARGB(255, 76, 175, 80); // Green
      default:
        return Colors.transparent;
    }
  }

  deleteEntry(String dateTimeString) async {
    await storage.delete(dateTimeString);
    update();
  }

  removeAll() async {
    await storage.clear();
    update();
  }
}
