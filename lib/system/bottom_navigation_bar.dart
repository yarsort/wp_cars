import 'package:flutter/material.dart';
import 'package:wp_car/home.dart';
import 'package:wp_car/screens/cars/cars_client.dart';
import 'package:wp_car/screens/messages/message.dart';
import 'package:wp_car/screens/notifications/notifications.dart';
import 'package:wp_car/system/menu.dart';
import 'package:wp_car/system/system.dart';

class WidgetBottomNavigationBar extends StatefulWidget {
  const WidgetBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<WidgetBottomNavigationBar> createState() =>
      _WidgetBottomNavigationBarState();
}

class _WidgetBottomNavigationBarState extends State<WidgetBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedMenuIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), tooltip: 'Головна', label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_filled), tooltip: 'Авто', label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.message), tooltip: 'Повідомлення', label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), tooltip: 'Нагадування', label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), tooltip: 'Меню', label: '')
        ],
        onTap: (int index) {
          setState(() {
            selectedMenuIndex = index;
          });

          if(selectedMenuIndex == 0){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ScreenHomePage()));
          }
          if(selectedMenuIndex == 1){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ScreenCarsClient()));
          }
          if(selectedMenuIndex == 2){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ScreenMessages()));
          }
          if(selectedMenuIndex == 3){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ScreenNotifications()));
          }
          if(selectedMenuIndex == 4){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ScreenMainMenu()));
          }
        },
      ),
    );
  }
}
