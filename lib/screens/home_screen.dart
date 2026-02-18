import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "../components/entry_form.dart";
import "../components/month_grid.dart";
import "../services/entry_service.dart";
import '../components/greet_user.dart';

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