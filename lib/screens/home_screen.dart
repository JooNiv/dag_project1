import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "../components/entry_form.dart";
import "../components/month_grid.dart";
import "../services/entry_service.dart";
import '../components/greet_user.dart';
import '../components/floating_button.dart';
import '../components/screen_base.dart';
import '../components/responsive_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final dateTimeString = "${date.year}-${date.month}-${date.day}";

    return ScreenBase(
        floatingActionButton: const FloatingButton(
          route: "/settings",
          icon: Icons.settings,
        ),
        body: ResponsiveWidget(
          mobile: Center(child: _buildRightPanel()),
          tablet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: _buildLeftPanel(context, dateTimeString)),
              const SizedBox(width: 20),
              Flexible(child: _buildRightPanel()),
            ],
          ),
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeftPanel(context, dateTimeString),
              const SizedBox(width: 20),
              _buildRightPanel(),
            ],
          ),
        ));
  }

  Widget _buildLeftPanel(BuildContext context, String dateTimeString) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
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
          //width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetUser(),
              EntryForm(dateTimeString: dateTimeString),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return SingleChildScrollView(
      child: GetBuilder<EntryService>(
        builder: (_) => Column(
          children: List.generate(12, (index) => MonthGrid(month: index)),
        ),
      ),
    );
  }
}
