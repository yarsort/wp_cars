import 'package:flutter/material.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/models/order_customer.dart';
import 'package:wp_car/models/post.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';
import 'package:wp_car/system/system.dart';

class ScreenCarClient extends StatefulWidget {
  final Car carItem;

  const ScreenCarClient({Key? key, required this.carItem}) : super(key: key);

  @override
  State<ScreenCarClient> createState() => _ScreenCarClientState();
}

class _ScreenCarClientState extends State<ScreenCarClient> {
  List<OrderCustomer> listOrders = [];
  List<Post> listPosts = [];

  readPosts() async {
    Post post1 = Post();
    post1.title = 'Заміна подшипників на колесо';
    post1.description =
        'Пройдя все этапы гнева, и страданий, несколько раз за 6 месяцев истина была обретина. Осознав что фазы показывают ересь я решил выставить их как положено, был достигнут результат';
    post1.picture = 'https://agro-ukraine.com/imgs/board/28/881128-2.jpg';
    listPosts.add(post1);

    Post post2 = Post();
    post2.title = 'Ремонт підвіски автомобіля';
    post2.description =
        'Пройдя все этапы гнева, и страданий, несколько раз за 6 месяцев истина была обретина. Осознав что фазы показывают ересь я решил выставить их как положено, был достигнут результат';
    post2.picture = 'http://365cars.ru/wp-content/uploads/2013/12/podveska-avtomobilja-ustrojstvo.jpg';
    listPosts.add(post2);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      //bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          autoPicture(),
          autoName(),
          const Divider(),
          autoParameters(),
          const Divider(),
          carPosts(),
        ],
      ),
    );
  }

  Widget autoPicture() {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Image.network(
        fit: BoxFit.fitWidth,
        widget.carItem.picture != ''
            ? widget.carItem.picture
            : 'https://placeimg.com/640/480/vehicle',
      ),
    );
  }

  Widget autoName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 0),
      child: Text(
        widget.carItem.name,
        style: const TextStyle(
            fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget autoParameters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 1),
      child: SizedBox(
        height: 40,
        child: ListView(
          physics:
              const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              height: 50,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0), //
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.teal),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(widget.carItem.yearProduction),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              height: 50,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                    ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.teal),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(widget.carItem.mileage.toString()),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                    ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_scanner, color: Colors.teal),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Text(widget.carItem.vin),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget carCard() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listOrders.length,
      itemBuilder: (context, index) {
        var orderItem = listOrders[index];
        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                      'Замовлення № ${orderItem.numberFrom1C} від ${fullDateToString(orderItem.date)}'),
                  subtitle: Column(
                    children: [
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.date_range,
                              color: iconColor, size: 20),
                          const SizedBox(width: 5),
                          Flexible(
                              child: Text(fullDateToString(orderItem.date))),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(Icons.domain, color: iconColor, size: 20),
                          const SizedBox(width: 5),
                          Flexible(
                              flex: 1, child: Text(orderItem.nameContract)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(children: [
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: iconColor, size: 20),
                                    const SizedBox(width: 5),
                                    Text(shortDateToString(
                                        orderItem.dateSending)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.history_toggle_off,
                                        color: iconColor, size: 20),
                                    const SizedBox(width: 5),
                                    Text(shortDateToString(
                                        orderItem.datePaying)),
                                  ],
                                )
                              ],
                            )),
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.price_change,
                                        color: iconColor, size: 20),
                                    const SizedBox(width: 5),
                                    Text(
                                        doubleToString(orderItem.sum) + ' грн'),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.format_list_numbered_rtl,
                                        color: iconColor, size: 20),
                                    const SizedBox(width: 5),
                                    Text('${orderItem.countItems} поз'),
                                  ],
                                )
                              ],
                            ))
                      ]),
                    ],
                  ),
                )));
      },
    );
  }

  Widget carPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 8, 8, 0),
          child: Text('Бортжурнал',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: listPosts.length,
          itemBuilder: (context, index) {
            final item = listPosts[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 8, 0),
              child: GestureDetector(
                onTap: () async {},
                child: Card(
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            fit: BoxFit.fitWidth,
                            item.picture != ''
                                ? item.picture
                                : 'https://placeimg.com/640/480/vehicle',
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        //leading: const Icon(Icons.directions_car),
                        title: Text(item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                            )),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.description,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
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
        ),
      ],
    );
  }
}
