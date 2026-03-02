import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "../components/entry_form.dart";
import "../components/month_grid.dart";
import "../services/entry_service.dart";
import '../components/greet_user.dart';
import '../components/floating_button.dart';
import '../components/screen_base.dart';
import '../components/responsive_widget.dart';
import '../utils/date_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeString = todayDateKey();

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
      ),
    );
  }

  Widget _buildLeftPanel(BuildContext context, String dateTimeString) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Card(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetUser(),
                EntryForm(dateTimeString: dateTimeString),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    final now = DateTime.now();
    final currentMonthIndex = now.month - 1;
    final currentMonthKey = GlobalKey();

    if (_selectedYear == now.year) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = currentMonthKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 350),
            alignment: 0.1,
            curve: Curves.easeOut,
          );
        }
      });
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => setState(() => _selectedYear--),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    'Year $_selectedYear',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _selectedYear++),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<EntryService>(
            builder: (_) => Column(
              children: List.generate(
                12,
                (index) => index == currentMonthIndex && _selectedYear == now.year
                    ? MonthGrid(key: currentMonthKey, month: index, year: _selectedYear)
                    : MonthGrid(month: index, year: _selectedYear),
              ),
            ),
          ),
        ],
      ),
    );
  }
}