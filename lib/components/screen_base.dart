import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'bottom_nav.dart';
import 'drawer.dart';

class ScreenBase extends StatelessWidget {

  final Widget body;
  final Widget? floatingActionButton;

  const ScreenBase({
    required this.body,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      floatingActionButton: floatingActionButton,
      drawer: const DrawerComponent(),
      bottomNavigationBar: const BottomNav(),
      body: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: body,
    ));
  }
}