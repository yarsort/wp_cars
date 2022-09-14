import 'package:flutter/material.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/screens/cars/car_client.dart';
import 'package:wp_car/screens/cars/car_client_add.dart';
import 'package:wp_car/services/car_service.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';
import 'package:wp_car/system/system.dart';

class ScreenCarsClient extends StatefulWidget {
  const ScreenCarsClient({Key? key}) : super(key: key);

  @override
  State<ScreenCarsClient> createState() => _ScreenCarsClientState();
}

class _ScreenCarsClientState extends State<ScreenCarsClient> {
  int userId = 0;
  List<Car> listCars = [];
  bool loadingCars = false;

  @override
  void initState() {
    if (listCars.isEmpty) {
      loadOrders();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Мої автомобілі'),
        actions: [
          IconButton(onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenCarClientAdd(),
              ),
            );
            setState(() {
              loadOrders();
            });
          }, icon: const Icon(Icons.add)),
        ],
      ),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: loadingCars
          ? bodyProgress()
          : listCars.isEmpty
              ? noOrders()
              : yesOrders(),
    );
  }

  loadOrders() async {
    setState(() {
      loadingCars = true;
    });

    listCars.clear();

    // User settings
    userId = await getUserId();

    // Request to server
    ApiResponse response = await getCars();

    // Read response
    if (response.error == null) {
      setState(() {
        for (var item in response.data as List<dynamic>) {
          listCars.add(item);
        }

        loadingCars = loadingCars ? !loadingCars : loadingCars;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ScreenLogin()),
                (route) => false)
          });
    } else {
      showErrorMessage('${response.error}', context);
    }

    setState(() {
      loadingCars = false;
    });
  }

  Widget bodyProgress() {
    return const Center(
        child: CircularProgressIndicator(
      value: null,
      strokeWidth: 4.0,
    ));
  }

  Widget yesOrders() {
    return RefreshIndicator(
        onRefresh: () async {
          await loadOrders();
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                carsCards(),
              ],
            )));
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
          Text('Список автомобілів порожній',
              style: TextStyle(color: Colors.grey)),
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
                loadOrders();
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
                      carItem.image != ''
                          ? carItem.image
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

}
