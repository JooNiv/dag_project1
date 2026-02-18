import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import "../utils/date_utils.dart";
import "../services/entry_service.dart";
import '../services/settings_service.dart';

class EntryForm extends StatefulWidget {
  final String dateTimeString;

  const EntryForm({super.key, required this.dateTimeString});

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  String? selectedMood;

  final _formKey = GlobalKey<FormBuilderState>();
  final EntryService entryService = Get.find<EntryService>();
  final SettingsService settingsService = Get.find<SettingsService>();

  Map<String, Color> moodColors = SettingsService().getColorSettings();

  _submit() async {
    if (_formKey.currentState!.saveAndValidate()) {
      await entryService.saveEntryAsync(
        widget.dateTimeString,
        _formKey.currentState?.value["mood"],
        _formKey.currentState?.value["comment"],
      );

      if (Get.currentRoute.startsWith('/entry')) {
        Get.toNamed('/');
      }
      //_formKey.currentState?.reset();
    }
  }

  _delete() async {
    await entryService.deleteEntry(widget.dateTimeString);
    if (Get.currentRoute.startsWith('/entry')) {
      Get.toNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Get.currentRoute.startsWith('/entry')
                  ? Builder(
                      builder: (context) {
                        var date = dateTimeStringToDateTime(widget.dateTimeString);
                        return Text(
                          "Entry for ${date?.day} ${monthNames[date!.month - 1]} ${date.year}, ${getDayNameThisYear(date.month - 1, date.day)}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      },
                    )
                  : Text(
                      "Today is ${DateTime.now().day} ${monthNames[DateTime.now().month - 1]} ${DateTime.now().year}, ${getDayNameThisYear(DateTime.now().month - 1, DateTime.now().day)}\nHow was your day?",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
          FormBuilderField<String>(
            name: "mood",
            validator: FormBuilderValidators.required(),
            builder: (FormFieldState<String> field) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: moodColors.entries.map((entry) {
                      final isSelected = field.value == entry.key;
                      return GestureDetector(
                        onTap: () => field.didChange(entry.key),
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
                            Text(entry.key,
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        field.errorText ?? '',
                        style:
                            TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          FormBuilderTextField(
            name: "comment",
            initialValue:
                entryService.getEntry(widget.dateTimeString)?["comment"],
            validator: FormBuilderValidators.required(),
            decoration: const InputDecoration(labelText: "Comment"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text("Submit")),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _delete, child: const Text("Delete Entry")),
        ],
      ),
    );
  }
}
