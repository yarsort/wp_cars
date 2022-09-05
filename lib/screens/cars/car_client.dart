import 'package:flutter/material.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';

class ScreenCarClient extends StatefulWidget {
  final Car carItem;

  const ScreenCarClient({Key? key, required this.carItem}) : super(key: key);

  @override
  State<ScreenCarClient> createState() => _ScreenCarClientState();
}

class _ScreenCarClientState extends State<ScreenCarClient> {

  List<Car> listCars = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.carItem.name),
      ),
      //bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          carCard(),
        ],
      ),
    );
  }

  Widget carCard() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listCars.length,
      itemBuilder: (context, index) {
        var priceItem = listCars[index];
        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Card(
              elevation: 2,
              child: ListTile(
                title: Text(priceItem.name),
              ),
            ));
      },
    );
  }
}
