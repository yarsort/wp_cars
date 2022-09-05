import 'package:flutter/material.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';

class ScreenMessages extends StatefulWidget {
  const ScreenMessages({Key? key}) : super(key: key);

  @override
  State<ScreenMessages> createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Повідомлення'),
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
