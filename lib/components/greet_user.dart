import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/settings_service.dart';

class GreetUser extends StatelessWidget {
  final SettingsService settingsService = Get.find<SettingsService>();

  GreetUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        "Hello, ${settingsService.getName()}!",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
