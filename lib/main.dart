import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<GratefulController>(() => GratefulController());
  Get.lazyPut<GratefulService>(() => GratefulService());
  runApp(
    GetMaterialApp(
      home: HomeScreen(),
    ),
  );
}

class GratefulService {
  final storage = Hive.box("storage");

  List getContent() {
    return storage.get("entries") ?? [];
  }

  void updateContent(List newContent) {
    storage.put("entries", newContent);
  }
}

class GratefulController {
  final service = Get.find<GratefulService>();
  RxList entries;

  GratefulController(): entries = [].obs {
    entries.value = service.getContent();
  }

  void updateContent(String newEntry) {
    entries.add(newEntry);
    service.updateContent(entries);
  }

  int size() {
    return entries.length;
  }
}

class HomeScreen extends StatelessWidget {
  final GratefulController controller = Get.find<GratefulController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Obx(
              () => controller.size() == 0
                  ? const Text('No entries yet')
                  : Text(controller.entries.last)
            ),
            Obx(() => Text('Total entries: ${controller.size()}')),
            ElevatedButton(
              onPressed: () => Get.to(AddEntryScreen()),
            child: const Text("Add entry"),
            ),
          ],
        )
      )
    );
  }
}

class AddEntryScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final GratefulController controller = Get.find<GratefulController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Add entry"),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "content",
                    decoration: const InputDecoration(labelText: "Content"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        controller.updateContent(_formKey.currentState!.value["content"]);
                        _formKey.currentState?.reset();
                        Get.back();
                      }
                    },
                    child: const Text("Save")
                  )
                ],
              )
            ),
          ],
        )
      )
    );
  }
}