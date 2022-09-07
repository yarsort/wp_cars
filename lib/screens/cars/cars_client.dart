import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wp_car/models/car.dart';
import 'package:wp_car/screens/cars/car_client.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';
import 'package:wp_car/system/system.dart';

class ScreenCarsClient extends StatefulWidget {
  const ScreenCarsClient({Key? key}) : super(key: key);

  @override
  State<ScreenCarsClient> createState() => _ScreenCarsClientState();
}

class _ScreenCarsClientState extends State<ScreenCarsClient> {
  List<Car> listCars = [];

  bool loadingCars = false;

  @override
  void initState() {

    super.initState();
    renewItem();

  }

  @override
  Widget build(BuildContext context) {
    var bodyProgress = const Center(
        child: CircularProgressIndicator(
          value: null,
          strokeWidth: 4.0,
        ));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Мої автомобілі'),
      ),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: loadingCars
          ? bodyProgress
          : listCars.isEmpty
          ? noOrders()
          : listOrders(),
    );
  }

  renewItem() async {
    listCars.clear();

    // Car carItem1 = Car();
    // carItem1.name = 'Audi A4 B8';
    // carItem1.nickname = 'Аудюшка';
    // carItem1.yearProduction = '2008';
    // carItem1.mileage = 128900;
    // carItem1.vin = 'WV2ZZZ70ZXH095869';
    // carItem1.rating = 108;
    // carItem1.picture =
    //     'https://cdn3.focus.bg/autodata/i/audi/a4/a4-b8/medium/36227e9ccefec249e81d8842d7197714.jpg';
    // listCars.add(carItem1);
    //
    // Car carItem2 = Car();
    // carItem2.name = 'Opel Kadet D';
    // carItem2.nickname = 'Развалюха';
    // carItem2.yearProduction = '1974';
    // carItem2.mileage = 383900;
    // carItem2.vin = 'WV1ZZZ7HZ7H111446';
    // carItem2.rating = 10;
    // carItem2.picture =
    //     'https://upload.wikimedia.org/wikipedia/commons/a/a6/Opel_Kadett_D_1_v_sst.jpg';
    // listCars.add(carItem2);
    //
    // Car carItem3 = Car();
    // carItem3.name = 'Suzuki Vitara';
    // carItem3.nickname = 'Хитрий Японець';
    // carItem3.yearProduction = '2015';
    // carItem3.mileage = 233900;
    // carItem3.vin = 'WVWNL9AN1DE579867';
    // carItem3.picture =
    //     'https://www.avtogermes.ru/images/marks/suzuki/vitara/ii-restajling/colors/a6h/92f05cbe7823ed965e76ce487d09a8d2.png';
    // listCars.add(carItem3);
    //
    // Car carItem5 = Car();
    // carItem5.name = 'Volkswagen B8';
    // carItem5.nickname = 'ДелаетВещи';
    // carItem5.yearProduction = '2017';
    // carItem5.mileage = 203900;
    // carItem5.vin = 'WV1ZZZ7HZEH086112';
    // carItem5.rating = 98;
    // carItem5.picture =
    //     'https://upload.wikimedia.org/wikipedia/commons/9/91/VW_Passat_B8_Limousine_2.0_TDI_Highline.JPG';
    // listCars.add(carItem5);
    //
    // Car carItem7 = Car();
    // carItem7.name = 'Renault Kengoo Test Width Double Limit';
    // carItem7.yearProduction = '2021';
    // carItem7.mileage = 2200;
    // carItem7.vin = 'WV2ZZZ70ZXH095869';
    // carItem7.rating = 345;
    // carItem7.picture =
    // 'https://upload.wikimedia.org/wikipedia/commons/4/4a/Renault_Kangoo_I_front_20090121.jpg';
    // listCars.add(carItem7);

    try {
      const url =
          'http://78.154.187.81:35844/baza_center/hs/app/v1/getdata';

      var jsonPost = '{"method":"get_client_cars", '
          '"authorization":"38597848-s859-f588-g5568-1245987832sd"}';

      const headersPost = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS'
      };

      var response = await http
          .post(Uri.parse(url), headers: headersPost, body: jsonPost)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        return http.Response('Error', 500);
      });

      dynamic myResponse;

      if (response.statusCode == 200) {
        myResponse = json.decode(response.body);

        // Если получили негативный результат от сервера, то прервем
        if (myResponse['result'] == false) {
          showErrorMessage('Error loading cars...', context);
          return;
        }

        listCars.clear();

        for (var itemCar in myResponse['data']) {
          // Запись в список заказов
          Car carItem = Car();
          carItem.uid = itemCar['uid'];
          carItem.name = itemCar['name'];
          carItem.nickname = '';
          carItem.yearProduction = itemCar['yearProduction'];
          carItem.mileage = 203900;
          carItem.vin = itemCar['vin'];
          carItem.rating = 98;
          carItem.picture = 'https://cdn3.focus.bg/autodata/i/audi/a4/a4-b8/medium/36227e9ccefec249e81d8842d7197714.jpg';
          listCars.add(carItem);
        }
      } else {
        showErrorMessage('Server 500 error...', context);
      }
    } catch (error) {
      debugPrint(error.toString());
      showErrorMessage('Server error...', context);
    }

    setState(() {});
  }

  Widget listOrders() {
    return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            loadingCars = true;
          });

          await renewItem();

          setState(() {
            loadingCars = false;
          });
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                carsCards(),
              ],
            )
        )
    );
  }

  Widget noOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.list_alt,
            color: Colors.grey,
            size: 60.0,
          ),
          Text(
            'Список автомобілів порожній', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget carsCards() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: listCars.length,
      itemBuilder: (context, index) {
        var carItem = listCars[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: GestureDetector(
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
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Image.network(
                      fit: BoxFit.fitWidth,
                      carItem.picture != ''
                          ? carItem.picture
                          : 'https://placeimg.com/640/480/vehicle',
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    //leading: const Icon(Icons.directions_car),
                    title: Row(
                      children: [
                        Expanded(child: Text(carItem.name)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text('${carItem.mileage.toString()} км'),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            carItem.nickname,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text('${carItem.yearProduction} рік'),
                        ),
                      ],
                    ),
                  ),
                ],
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
