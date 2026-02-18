import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../services/settings_service.dart';

class GreetUser extends StatelessWidget {

  final SettingsService settingsService = Get.find<SettingsService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 50, left: 50, top: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        "Hello, ${settingsService.getName()}!",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}