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
      _loadCars();
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
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenCarClientAdd(),
                  ),
                );
                setState(() {
                  _loadCars();
                });
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: RefreshIndicator(
          onRefresh: () async {
            await _loadCars();
          },
          child: loadingCars
              ? bodyProgress()
              : listCars.isEmpty
                  ? noCars()
                  : yesCars()),
    );
  }

  _loadCars() async {
    setState(() {
      loadingCars = true;
    });

    listCars.clear();

    // User settings
    userId = await getUserId();

    // Request to server
    ApiResponse response = await getUserCars();

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

  Widget yesCars() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            carsCards(),
          ],
        ));
  }

  Widget noCars() {
    return ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/2-100,),
              const Icon(
                Icons.car_rental,
                color: Colors.grey,
                size: 60.0,
              ),
              const Text('Список автомобілів порожній',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
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
                _loadCars();
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
                          ? siteURL + carItem.image
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
