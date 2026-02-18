import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../services/settings_service.dart';

class IntroScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  final SettingsService settingsService = Get.find<SettingsService>();

  IntroScreen({super.key});

  _handleButtonPress() {
    if (_formKey.currentState!.saveAndValidate()) {
      settingsService.saveSettingAsync(
          "name", _formKey.currentState?.value["name"]);
      _formKey.currentState?.reset();
      Get.toNamed("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: 1000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Welcome to Mood Pixels!\n\nThis app helps you track your mood over time. You can log your mood daily and see how it changes with the calendar view. Let's get started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "name",
                    initialValue: settingsService.getRawName() ?? "",
                    validator: FormBuilderValidators.required(),
                    decoration: const InputDecoration(labelText: "Your Name"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _handleButtonPress,
                      child: const Text("Get Started"))
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
