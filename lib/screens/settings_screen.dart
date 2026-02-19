import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../services/settings_service.dart';
import '../services/entry_service.dart';
import '../components/floating_button.dart';
import '../components/screen_base.dart';
import '../components/responsive_widget.dart';
import '../components/buttons.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBase(
        floatingActionButton:
            const FloatingButton(route: "/", icon: Icons.arrow_back),
        body: ResponsiveWidget(
            mobile: MobileSettings(),
            tablet: MobileSettings(),
            desktop: DesktopSettings()));
  }
}

// ignore: must_be_immutable
class DesktopSettings extends StatelessWidget {
  final RxMap<String, Color> colorSettings = <String, Color>{}.obs;
  final _formKey = GlobalKey<FormBuilderState>();

  final SettingsService settingsService = Get.find<SettingsService>();
  final EntryService entryService = Get.find<EntryService>();

  DesktopSettings({super.key}) {
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
    return SizedBox(
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBuilderTextField(
                        name: "name",
                        initialValue: settingsService.getName(),
                        validator: FormBuilderValidators.required(),
                        decoration: const InputDecoration(
                            labelText: "Your Name",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Obx(() => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ...colorSettings.entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 17, bottom: 17),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                color: selectedColorSettingKey
                                                            .value ==
                                                        entry.key
                                                    ? Colors.black
                                                    : Colors.grey,
                                                width: selectedColorSettingKey
                                                            .value ==
                                                        entry.key
                                                    ? 3
                                                    : 1,
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NormalButton(
                                onPressed: () async {
                                  await _handleButtonPress();
                                },
                                text: "Save Settings"),
                            const SizedBox(height: 20),
                            WarningButton(
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
                              text: "Reset Colors",
                            ),
                            const SizedBox(height: 20),
                            DangerButton(
                                onPressed: () async {
                                  await entryService.removeAll();
                                  await settingsService.removeAll();
                                  Get.toNamed("/welcome");
                                },
                                text: "Delete all data")
                          ])
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MobileSettings extends StatelessWidget {
  final RxMap<String, Color> colorSettings = <String, Color>{}.obs;
  final _formKey = GlobalKey<FormBuilderState>();

  final SettingsService settingsService = Get.find<SettingsService>();
  final EntryService entryService = Get.find<EntryService>();

  MobileSettings({super.key}) {
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

  Rx<Color> pickerColor = const Color(0xff443a49).obs;
  var selectedColorSettingKey = "Very Bad".obs;

  void changeColor(Color color) {
    pickerColor.value = color;
    colorSettings[selectedColorSettingKey.value] = color;
  }

  Future<void> showColorPickerDialog(
      BuildContext context, String key, Color current) async {
    pickerColor.value = current;
    selectedColorSettingKey.value = key;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color for "$key"'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Obx(() => ColorPicker(
                    pickerColor: pickerColor.value,
                    onColorChanged: (color) => pickerColor.value = color,
                  )),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                changeColor(pickerColor.value);
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  _handleButtonPress(BuildContext context) async {
    if (_formKey.currentState!.saveAndValidate()) {
      await settingsService.saveSettingAsync(
          "name", _formKey.currentState?.value["name"]);
      await settingsService.saveSettingAsync(
          "colorSettings",
          Map.fromEntries(
              colorSettings.entries.map((e) => MapEntry(e.key, e.value))));
      _formKey.currentState?.reset();
      Get.toNamed("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "name",
                    initialValue: settingsService.getName(),
                    validator: FormBuilderValidators.required(),
                    decoration: const InputDecoration(
                        labelText: "Your Name", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Mood Colors",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Column(
                        children: colorSettings.entries.map((entry) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(entry.key),
                              trailing: GestureDetector(
                                onTap: () => showColorPickerDialog(
                                    context, entry.key, entry.value),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: entry.value,
                                    border: Border.all(
                                      color: selectedColorSettingKey.value ==
                                              entry.key
                                          ? Colors.black
                                          : Colors.grey,
                                      width: selectedColorSettingKey.value ==
                                              entry.key
                                          ? 3
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: NormalButton(
                        onPressed: () => _handleButtonPress(context),
                        text: "Save Settings"),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: WarningButton(
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
                      text: "Reset Colors",
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: DangerButton(
                        onPressed: () async {
                          await entryService.removeAll();
                          await settingsService.removeAll();
                          Get.toNamed("/welcome");
                        },
                        text: "Delete all data"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
