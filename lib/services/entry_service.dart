import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'settings_service.dart';


class EntryService extends GetxController {
  final storage = Hive.box("entries");

  final SettingsService settingsService = Get.find<SettingsService>();

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
      return Colors.grey;
    }

    var color = settingsService.getColorSettings()[entry["mood"]];
    return color ?? Colors.grey;
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
