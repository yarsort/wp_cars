import 'package:flutter/material.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/models/post.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/services/post_service.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/system.dart';

class ScreenPostsCar extends StatefulWidget {
  final Car carItem;

  const ScreenPostsCar({Key? key, required this.carItem}) : super(key: key);

  @override
  State<ScreenPostsCar> createState() => _ScreenPostsCarState();
}

class _ScreenPostsCarState extends State<ScreenPostsCar> {
  Color bgGreyColor = Colors.grey.shade100;
  Color bgWhiteColor = Colors.white;

  List<Post> listPosts = [];
  bool loadingPosts = false;

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Бортжурнал'),
        actions: [
          IconButton(
              onPressed: () {
                _addPost();
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await _loadPosts();
          },
          child: loadingPosts
              ? bodyProgress()
              : listPosts.isEmpty
                  ? noPosts()
                  : yesPosts()),
    );
  }

  _addPost() async {}

  _loadPosts() async {
    setState(() {
      loadingPosts = true;
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

        loadingPosts = loadingPosts ? !loadingPosts : loadingPosts;
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
      loadingPosts = false;
    });
  }

  Widget bodyProgress() {
    return const Center(
        child: CircularProgressIndicator(
      value: null,
      strokeWidth: 4.0,
    ));
  }

  Widget noPosts() {
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 100,
            ),
            const Icon(
              Icons.list_alt,
              color: Colors.grey,
              size: 60.0,
            ),
            const Text('Список публікацій порожній',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget yesPosts() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            carPosts(),
          ],
        ));
  }

  Widget carPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: listPosts.length,
          itemBuilder: (context, index) {
            final item = listPosts[index];
            return CarPostMedium(carPost: item, carItem: widget.carItem);
          },
        ),
      ],
    );
  }

  Widget titleJournal() {
    return Padding(
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
                  child: const Icon(
                    Icons.add,
                    color: Colors.teal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CarPostMedium extends StatefulWidget {
  final Post carPost;
  final Car carItem;

  const CarPostMedium({Key? key, required this.carPost, required this.carItem})
      : super(key: key);

  @override
  State<CarPostMedium> createState() => _CarPostMediumState();
}

class _CarPostMediumState extends State<CarPostMedium> {
  int view = 0;
  int like = 23;
  int comment = 18;
  int countWords = 0;

  @override
  Widget build(BuildContext context) {
    countWords = widget.carPost.body.split(' ').length;

    //debugPrint(siteURL + widget.carPost.image);

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
                              siteURL + widget.carItem.image, loadingBuilder:
                                  (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }),
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
                    Text(widget.carPost.title,
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
                          child: Text(widget.carPost.body,
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
                              Text(shortDateToString(widget.carPost.createdAt),
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
                      widget.carPost.image != ''
                          ? siteURL + widget.carPost.image
                          : 'https://placeimg.com/640/480/vehicle',
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }),
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
            Text(view.toString()),
          ],
        ),
      ],
    );
  }
}
