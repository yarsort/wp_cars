import 'package:flutter/material.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/models/order_customer.dart';
import 'package:wp_car/models/post.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/services/post_service.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';
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

  loadPosts() async {
    Post post1 = Post();
    post1.title = 'Заміна підшипників на колесо';
    post1.body =
        'Пройдя все этапы гнева, и страданий, несколько раз за 6 месяцев истина была обретина. Осознав что фазы показывают ересь я решил выставить их как положено, был достигнут результат. По сравнению с предшествующей моделью, A4 в кузове B7, новая B8 выросла в размерах - 160 мм прибавила колёсная база, 117 мм - общая длина. Это позволило увеличить пространство для ног задних пассажиров. Хотя габаритные размеры увеличились, снаряженная масса снизилась примерно на 10%. Размер багажника также увеличился: до 480 литров для седана и 1430 л для универсала (Avant) при сложенных задних сидениях. ';
    post1.image = 'https://agro-ukraine.com/imgs/board/28/881128-2.jpg';
    listPosts.add(post1);

    Post post2 = Post();
    post2.title = 'Ремонт підвіски автомобіля';
    post2.body =
        'Пройдя все этапы гнева, и страданий, несколько раз за 6 месяцев истина была обретина. Осознав что фазы показывают ересь я решил выставить их как положено, был достигнут результат';
    post2.image =
        'http://365cars.ru/wp-content/uploads/2013/12/podveska-avtomobilja-ustrojstvo.jpg';
    listPosts.add(post2);

    setState(() {});
  }

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if(response.error == null){
      setState(() {
        listPosts = response.data as List<Post>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const ScreenLogin()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  // Post like dislike
  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    }
    else if (response.error == unauthorized) {
      logout().then((value) =>
      {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ScreenLogin()), (
            route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
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
            title: Text(widget.carItem.name, style: const TextStyle(color: Colors.white, fontSize: 16.0,)),
            background: Image.network(
              widget.carItem.image,
              fit: BoxFit.cover,
            )),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Додати новий автомобіль',
            onPressed: () { /* ... */ },
          ),
        ]
    );
  }

  Widget autoPicture() {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Image.network(
        fit: BoxFit.fitWidth,
        widget.carItem.image,
      ),
    );
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
                width: 1.0, color: Colors.grey.shade200,
            )
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
        Padding(
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
                  const Spacer(),
                  SizedBox(
                    width: 50,
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.add, color: Colors.teal,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: listPosts.length,
          itemBuilder: (context, index) {
            int view = 0;
            int like = 23;
            int comment = 18;

            final item = listPosts[index];

            var countWords = item.body.split(' ').length;

            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                      widget.carItem.image),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.carItem.name,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.carItem.nickname,
                                      style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),

                      const Divider(indent: 8, endIndent: 8,),

                      /// Текст поста
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(item.body,
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
                                  width: 1.0, color: Colors.grey.shade100,
                                ),
                                top: BorderSide(
                                  width: 1.0, color: Colors.grey.shade100,
                                )
                            ),
                          ),
                          child: Image.network(
                            fit: BoxFit.fitWidth,
                            item.image != ''
                                ? item.image
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

                              const VerticalDivider(indent: 3, endIndent: 3,),

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
          },
        ),
      ],
    );
  }

  Widget postViewLikeComment(IconData icon, int view) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon,
                color: Colors.grey, size: 18),
            const SizedBox(
              width: 5,
            ),
            Text(view.toString()),
          ],
        ),
      ],
    );
  }

}
