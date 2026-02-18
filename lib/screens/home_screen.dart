import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import "../components/entry_form.dart";
import "../components/month_grid.dart";
import "../services/entry_service.dart";
import '../components/greet_user.dart';
import '../components/floating_button.dart';
import '../components/screen_base.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String dateTimeString =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    return ScreenBase(
        floatingActionButton:
            const FloatingButton(route: "/settings", icon: Icons.settings),
        body:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Container(
                        padding:
                            const EdgeInsets.only(right: 50, left: 50, top: 50),
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
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GreetUser(),
                            EntryForm(dateTimeString: dateTimeString),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        GetBuilder<EntryService>(
                          builder: (_) => Column(
                            children: List.generate(
                                12, (index) => MonthGrid(month: index)),
                          ),
                        ),
                      ],
                    ),
                  )
                ]));
  }
}
