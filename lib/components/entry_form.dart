import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import "../services/entry_service.dart";
import '../services/settings_service.dart';
import '../utils/date_utils.dart';
import 'buttons.dart';
import 'responsive_widget.dart';

class EntryFormController extends GetxController {
  final EntryService entryService = Get.find<EntryService>();
  final SettingsService settingsService = Get.find<SettingsService>();

  var selectedMood = ''.obs;
  var comment = ''.obs;

  Map<String, Color> get moodColors => settingsService.getColorSettings();

  void setMood(String mood) => selectedMood.value = mood;

  void setComment(String value) => comment.value = value;

  Future<void> submit(
      String dateTimeString, GlobalKey<FormBuilderState> formKey) async {
    if (formKey.currentState!.saveAndValidate()) {
      await entryService.saveEntryAsync(
        dateTimeString,
        formKey.currentState?.value["mood"],
        formKey.currentState?.value["comment"],
      );
      if (Get.currentRoute.startsWith('/entry')) {
        Get.toNamed('/');
      }
    }
  }

  Future<void> deleteEntry(String dateTimeString) async {
    await entryService.deleteEntry(dateTimeString);
    if (Get.currentRoute.startsWith('/entry')) {
      Get.toNamed('/');
    }
  }
}

class EntryForm extends StatelessWidget {
  final String dateTimeString;
  final formKey = GlobalKey<FormBuilderState>();
  EntryForm({super.key, required this.dateTimeString});

  @override
  Widget build(BuildContext context) {
    final EntryFormController controller =
        Get.put(EntryFormController(), tag: dateTimeString);

    final entry = controller.entryService.getEntry(dateTimeString);

    if (controller.selectedMood.value.isEmpty && entry?["mood"] != null) {
      controller.selectedMood.value = entry!["mood"];
    }
    if (controller.comment.value.isEmpty && entry?["comment"] != null) {
      controller.comment.value = entry!["comment"];
    }

    return FormBuilder(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Get.currentRoute.startsWith('/entry')
                  ? Builder(
                      builder: (context) {
                        var date = dateTimeStringToDateTime(dateTimeString);
                        return Text(
                          "Entry for ${date?.day} ${monthNames[date!.month - 1]} ${date.year}, ${getDayNameThisYear(date.month - 1, date.day)}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      },
                    )
                  : Text(
                      "Today is ${DateTime.now().day} ${monthNames[DateTime.now().month - 1]} ${DateTime.now().year}, ${getDayNameThisYear(DateTime.now().month - 1, DateTime.now().day)}\nHow was your day?",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: controller.moodColors.entries.map((entry) {
                  final isSelected = controller.selectedMood.value == entry.key;
                  return GestureDetector(
                    onTap: () {
                      controller.setMood(entry.key);
                      formKey.currentState?.fields['mood']
                          ?.didChange(entry.key);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: entry.value,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(entry.key, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                }).toList(),
              )),
          FormBuilderField<String>(
            name: "mood",
            initialValue: controller.selectedMood.value,
            validator: FormBuilderValidators.required(),
            builder: (FormFieldState<String> field) {
              if (field.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    field.errorText ?? '',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),
          Obx(() => FormBuilderTextField(
                name: "comment",
                initialValue: controller.comment.value,
                validator: FormBuilderValidators.required(),
                decoration: const InputDecoration(
                    labelText: "Comment", border: OutlineInputBorder()),
                onChanged: (val) => controller.setComment(val ?? ''),
              )),
          const SizedBox(height: 20),
          
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: double.infinity,
              child: NormalButton(
                text: "Submit",
                onPressed: () => controller.submit(dateTimeString, formKey),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: DangerButton(
                text: "Delete Entry",
                onPressed: () => controller.deleteEntry(dateTimeString),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
