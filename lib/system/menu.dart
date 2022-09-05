import 'package:flutter/material.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';

class ScreenMainMenu extends StatefulWidget {
  const ScreenMainMenu({Key? key}) : super(key: key);

  @override
  State<ScreenMainMenu> createState() => _ScreenMainMenuState();
}

class _ScreenMainMenuState extends State<ScreenMainMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Меню'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: const [
                //demoCard(),
                //balanceCard(),
                //documentsCard(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
    );
  }
}
