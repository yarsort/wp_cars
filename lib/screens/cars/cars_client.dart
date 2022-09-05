import 'package:flutter/material.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/screens/cars/car_client.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';

class ScreenCarsClient extends StatefulWidget {
  const ScreenCarsClient({Key? key}) : super(key: key);

  @override
  State<ScreenCarsClient> createState() => _ScreenCarsClientState();
}

class _ScreenCarsClientState extends State<ScreenCarsClient> {
  List<Car> listCars = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    renewItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Мої автомобілі'),
      ),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            carsCard(),
          ],
        ),
      ),
    );
  }

  renewItem() async {
    listCars.clear();

    Car carItem1 = Car();
    carItem1.name = 'Audi A4 B8';
    listCars.add(carItem1);

    Car carItem2 = Car();
    carItem2.name = 'Suzuki B8';
    listCars.add(carItem2);

    Car carItem3 = Car();
    carItem3.name = 'Suzuki B8';
    listCars.add(carItem3);

    Car carItem5 = Car();
    carItem5.name = 'Volkswagen B8';
    listCars.add(carItem5);

    Car carItem6 = Car();
    carItem6.name = 'Renault Escudo';
    listCars.add(carItem6);

    Car carItem7 = Car();
    carItem7.name = 'Renault Kengoo Test Width Limit';
    listCars.add(carItem7);

    setState(() {});
  }

  Widget carsCard() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listCars.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var carItem = listCars[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: SizedBox(
            height: 150,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Image.network(
                      'https://placeimg.com/640/480/any',
                      fit: BoxFit.contain,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                        child: Text(
                          carItem.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget carsCardTemplate() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: listCars.length,
      itemBuilder: (context, index) {
        var carItem = listCars[index];
        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Card(
              elevation: 2,
              child: ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenCarClient(carItem: carItem),
                    ),
                  );
                  setState(() {
                    renewItem();
                  });
                },
                title: Text(carItem.name),
              ),
            ));
      },
    );
  }
}
