import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import "services/entry_service.dart";
import "services/settings_service.dart";
import "screens/home_screen.dart";

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("entries");
  await Hive.openBox("settings");

  Get.lazyPut<EntryService>(() => EntryService());
  Get.lazyPut<SettingsService>(() => SettingsService());

  runApp(GetMaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Mood Pixels"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: HomeScreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.settings),
      ),
      drawer: const Drawer(
        child: Text("Settings will go here"),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.blueGrey,
        child: const Center(
          child: Text(
            "Made by Joonas with Flutter",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  ));
}
