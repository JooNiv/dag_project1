import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import "src/entry_form.dart";
import "src/month_grid.dart";
import "services/entry_service.dart";

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("entries");

  Get.lazyPut<EntryService>(() => EntryService());

  runApp(
    GetMaterialApp(
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String dateTimeString =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: EntryForm(dateTimeString: dateTimeString),
          ),
        ),
        const SizedBox(width: 20),
        SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<EntryService>(
                builder: (_) => Column(
                  children:
                      List.generate(12, (index) => MonthGrid(month: index)),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
