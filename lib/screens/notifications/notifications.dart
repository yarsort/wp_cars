import 'package:flutter/material.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';

class ScreenNotifications extends StatefulWidget {
  const ScreenNotifications({Key? key}) : super(key: key);

  @override
  State<ScreenNotifications> createState() => _ScreenNotificationsState();
}

class _ScreenNotificationsState extends State<ScreenNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Нагадування'),
      ),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          //demoCard(),
          //balanceCard(),
          //documentsCard(),
        ],
      ),
    );
  }
}
