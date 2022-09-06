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
    carItem1.nickname = 'Аудюшка';
    carItem1.yearProduction = '2008';
    carItem1.mileage = 128900;
    carItem1.rating = 108;
    carItem1.picture = 'https://cdn3.focus.bg/autodata/i/audi/a4/a4-b8/medium/36227e9ccefec249e81d8842d7197714.jpg';
    listCars.add(carItem1);

    Car carItem2 = Car();
    carItem2.name = 'Suzuki B8';
    carItem2.yearProduction = '2010';
    carItem2.mileage = 133900;
    carItem2.rating = 10;
    carItem2.picture = 'https://www.avtogermes.ru/images/marks/suzuki/vitara/ii-restajling/colors/a6h/92f05cbe7823ed965e76ce487d09a8d2.png';
    listCars.add(carItem2);

    Car carItem3 = Car();
    carItem3.name = 'Suzuki Vitara';
    carItem3.nickname = 'Хитрий Японець';
    carItem3.yearProduction = '2015';
    carItem3.mileage = 233900;
    carItem3.picture = 'https://www.avtogermes.ru/images/marks/suzuki/vitara/ii-restajling/colors/a6h/92f05cbe7823ed965e76ce487d09a8d2.png';
    listCars.add(carItem3);

    Car carItem5 = Car();
    carItem5.name = 'Volkswagen B8';
    carItem5.yearProduction = '2017';
    carItem5.mileage = 203900;
    carItem5.rating = 98;
    carItem5.picture = 'https://upload.wikimedia.org/wikipedia/commons/9/91/VW_Passat_B8_Limousine_2.0_TDI_Highline.JPG';
    listCars.add(carItem5);

    Car carItem6 = Car();
    carItem6.name = 'Renault Escudo';
    carItem6.yearProduction = '2020';
    carItem6.mileage = 21200;
    listCars.add(carItem6);

    Car carItem7 = Car();
    carItem7.name = 'Renault Kengoo Test Width Limit';
    carItem7.yearProduction = '2021';
    carItem7.mileage = 2200;
    carItem7.rating = 345;
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
        var carName = carItem.name;

        if(carItem.nickname.trim() != ''){
          carName = '$carName (${carItem.nickname})';
        }

        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
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
                title: Text(carName),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('Рік:'),
                        Text('Пробіг:'),
                        Text('Рейтинг:'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(' ${carItem.yearProduction}'),
                        Text(' ${carItem.mileage}'),
                        Text(' ${carItem.rating.toString()}'),
                      ],
                    )
                    ],
                ),
                leading: Image.network(
                  carItem.picture != '' ? carItem.picture : 'https://placeimg.com/640/480/vehicle',
                  fit: BoxFit.contain,
                ),
              ),
            )
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
