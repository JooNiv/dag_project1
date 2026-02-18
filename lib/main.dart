import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import "services/entry_service.dart";
import "services/settings_service.dart";
import "screens/home_screen.dart";
import "screens/intro_screen.dart";
import "screens/settings_screen.dart";
import "screens/entry_screen.dart";

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("entries");
  await Hive.openBox("settings");

  Get.lazyPut<EntryService>(() => EntryService());
  Get.lazyPut<SettingsService>(() => SettingsService());

  final SettingsService settingsService = Get.find<SettingsService>();

  var initial = "/welcome";

  if (settingsService.getRawName() != null) {
    initial = "/";
  }

  runApp(GetMaterialApp(
    initialRoute: initial,
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/welcome", page: () => IntroScreen()),
        GetPage(name: "/settings", page: () => SettingsScreen()),
        GetPage(name: "/entry/:dateTimeString", page: () => EntryScreen()),
      ],
  ));
}
