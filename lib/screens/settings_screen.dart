import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../services/settings_service.dart';
import '../services/entry_service.dart';
import '../components/floating_button.dart';
import '../components/screen_base.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  final RxMap<String, Color> colorSettings = <String, Color>{}.obs;
  final _formKey = GlobalKey<FormBuilderState>();

  final SettingsService settingsService = Get.find<SettingsService>();
  final EntryService entryService = Get.find<EntryService>();

  SettingsScreen({super.key}) {
    final raw = settingsService.getColorSettings();
    if (raw is Map<String, Color>) {
      colorSettings.assignAll(raw);
    } else if (raw is Map) {
      colorSettings.assignAll(
        raw.map(
            (k, v) => MapEntry(k.toString(), v is Color ? v : Color(v as int))),
      );
    }
  }

  _handleButtonPress() {
    if (_formKey.currentState!.saveAndValidate()) {
      settingsService.saveSettingAsync(
          "name", _formKey.currentState?.value["name"]);

      settingsService.saveSettingAsync(
          "colorSettings",
          Map.fromEntries(
              colorSettings.entries.map((e) => MapEntry(e.key, e.value))));
      _formKey.currentState?.reset();
      Get.toNamed("/");
    }
  }

  Rx<Color> pickerColor = const Color(0xff443a49).obs;
  Rx<Color> currentColor = const Color(0xff443a49).obs;

  var selectedColorSettingKey = "Very Bad".obs;

  void changeColor(Color color) async {
    pickerColor.value = color;
    colorSettings[selectedColorSettingKey.value] = color;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
      floatingActionButton: const FloatingButton(route: "/", icon: Icons.arrow_back),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
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
            width: 1000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Settings",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          name: "name",
                          initialValue: settingsService.getName(),
                          validator: FormBuilderValidators.required(),
                          decoration:
                              const InputDecoration(labelText: "Your Name"),
                        ),
                        const SizedBox(height: 20),
                        Row(children: [
                          Obx(() => Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ...colorSettings.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 17, bottom: 17),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(child: Text(entry.key)),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              pickerColor.value = entry.value;
                                              selectedColorSettingKey.value =
                                                  entry.key;
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: entry.value,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              )),
                          Obx(() => ColorPicker(
                              pickerColor: pickerColor.value,
                              onColorChanged: changeColor)),
                        ]),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () async {
                              await _handleButtonPress();
                            },
                            child: const Text("Save Settings")),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await settingsService.resetColorSettings();
                            final raw = settingsService.getColorSettings();
                            if (raw is Map<String, Color>) {
                              colorSettings.assignAll(raw);
                            } else if (raw is Map) {
                              colorSettings.assignAll(
                                raw.map(
                                  (k, v) => MapEntry(k.toString(),
                                      v is Color ? v : Color(v as int)),
                                ),
                              );
                            }
                            selectedColorSettingKey.value = "Very Bad";
                            pickerColor.value =
                                const Color.fromARGB(255, 156, 39, 176);
                          },
                          child: const Text("Reset Colors"),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () async {
                              await entryService.removeAll();
                              await settingsService.removeAll();
                              Get.toNamed("/welcome");
                            },
                            child: const Text("Delete all data"))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
