import 'package:flutter/material.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/models/order_customer.dart';
import 'package:wp_car/models/post.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/screens/post/posts_car.dart';
import 'package:wp_car/screens/post/posts_car_add.dart';
import 'package:wp_car/services/post_service.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/system.dart';

class ScreenCarClient extends StatefulWidget {
  final Car carItem;

  const ScreenCarClient({Key? key, required this.carItem}) : super(key: key);

  @override
  State<ScreenCarClient> createState() => _ScreenCarClientState();
}

class _ScreenCarClientState extends State<ScreenCarClient> {
  final GlobalKey<FormState> _customListKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<OrderCustomer> listOrders = [];
  List<Post> listPosts = [];

  int userId = 0;
  bool _loading = true;

  Color bgGreyColor = Colors.grey.shade100;
  Color bgWhiteColor = Colors.white;

  _loadPosts() async {
    setState(() {
      _loading = true;
    });

    listPosts.clear();

    // Request to server
    ApiResponse response = await getCarPosts(widget.carItem.id);

    // Read response
    if (response.error == null) {
      setState(() {
        for (var item in response.data as List<dynamic>) {
          listPosts.add(item);
        }

        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ScreenLogin()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        key: _customListKey,
        slivers: <Widget>[
          sliverAppBar(),
          SliverList(
            key: _formKey,
            delegate: SliverChildListDelegate([
              //autoName(),
              autoParameters(),
              autoDescription(),
              carPosts(),
              showMorePosts(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget sliverAppBar() {
    return SliverAppBar(
        floating: false,
        pinned: true,
        snap: false,
        expandedHeight: 200,
        flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            centerTitle: true,
            title: Text(widget.carItem.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                )),
            background: Image.network(
              siteURL + widget.carItem.image,
              fit: BoxFit.cover,
            )),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Додати новий автомобіль',
            onPressed: () {
              /* ... */
            },
          ),
        ]);
  }

  Widget autoParameters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        color: bgWhiteColor,
        height: 56,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                height: 50,
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
                        child: Text(widget.carItem.vinCode),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget autoDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            width: 1.0,
            color: Colors.grey.shade200,
          )),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
          child: Text(widget.carItem.description,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.normal)),
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
        //verticalSpacer(),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Colors.grey.shade200),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0), //
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      children: [
                        const Text('Бортжурнал',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 9, 0),
              child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ScreenPostsCarAdd(carItem: widget.carItem),
                      ),
                    );
                    setState(() {
                      //_loadPosts();
                    });
                  },
                  child: const Icon(Icons.add)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: listPosts.length,
            itemBuilder: (context, index) {
              final item = listPosts[index];
              return CarPostMedium(carPost: item, carItem: widget.carItem);
            },
          ),
        ),
      ],
    );
  }

  Widget showMorePosts() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Ink(
        child: InkWell(
          splashColor: Colors.teal,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenPostsCar(carItem: widget.carItem),
              ),
            );
            setState(() {
              //_loadPosts();
            });
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.0, color: Colors.grey.shade200),
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0), //
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Читати весь бортжурнал',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, color: Colors.teal)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarPostShort extends StatefulWidget {
  final Post carPostChild;
  final Car carItemChild;

  const CarPostShort(
      {Key? key, required this.carPostChild, required this.carItemChild})
      : super(key: key);

  @override
  State<CarPostShort> createState() => _CarPostShortState();
}

class _CarPostShortState extends State<CarPostShort> {
  int view = 0;
  int like = 23;
  int comment = 18;
  int countWords = 0;

  @override
  Widget build(BuildContext context) {
    countWords = widget.carPostChild.body.split(' ').length;

    // debugPrint('Картинка: ${widget.carItemChild.image}');
    // debugPrint(siteURL+widget.carItemChild.image);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.0, color: Colors.grey.shade200),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0), //
          ),
        ),
        child: GestureDetector(
          onTap: () async {},
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Аватар та назва автомобіля
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: SizedBox(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          height: 45,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0), //
                            ),
                          ),
                          child: Image.network(
                              fit: BoxFit.fitWidth,
                              siteURL + widget.carItemChild.image),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.carItemChild.name,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(widget.carItemChild.nickname,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              const Divider(
                indent: 8,
                endIndent: 8,
              ),

              /// Назва поста
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.carPostChild.title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),

              /// Текст поста
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(widget.carPostChild.body,
                              maxLines: 4,
                              overflow: TextOverflow.fade,
                              //softWrap: false,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text('W:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.7),
                                      fontWeight: FontWeight.normal)),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(countWords.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.7),
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Text('Читати далі',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal.withOpacity(0.7),
                                    fontWeight: FontWeight.normal)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              /// Картинка поста
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.grey.shade100,
                        ),
                        top: BorderSide(
                          width: 1.0,
                          color: Colors.grey.shade100,
                        )),
                  ),
                  child: Image.network(
                    fit: BoxFit.fitWidth,
                    widget.carPostChild.image != ''
                        ? widget.carPostChild.image
                        : 'https://placeimg.com/640/480/vehicle',
                  ),
                ),
              ),

              /// Перегляди, лайки, комментарі
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// Перегляди
                      postViewLikeComment(Icons.visibility, view),

                      const VerticalDivider(),

                      /// Лайки
                      postViewLikeComment(Icons.favorite, like),

                      const VerticalDivider(
                        indent: 3,
                        endIndent: 3,
                      ),

                      /// Коментарі
                      postViewLikeComment(Icons.comment, comment),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postViewLikeComment(IconData icon, int view) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey, size: 18),
            const SizedBox(
              width: 5,
            ),
            Text(
              view.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
