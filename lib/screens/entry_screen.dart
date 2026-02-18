import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/entry_form.dart';
import '../components/floating_button.dart';
import '../components/screen_base.dart';

class EntryScreen extends StatelessWidget {

  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String dateTimeString = Get.parameters["dateTimeString"] ?? "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
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
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EntryForm(dateTimeString: dateTimeString),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}