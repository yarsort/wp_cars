import 'package:flutter/material.dart';
import 'package:wp_car/models/message.dart';
import 'package:wp_car/system/bottom_navigation_bar.dart';

class ScreenMessages extends StatefulWidget {
  const ScreenMessages({Key? key}) : super(key: key);

  @override
  State<ScreenMessages> createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages> {

  List<Message> listMessages= [];

  bool loadingMessages = false;

  loadMessages() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Повідомлення'),
      ),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
      body: loadingMessages
          ? bodyProgress()
          : listMessages.isEmpty
          ? noMessages()
          : yesMessages(),
    );
  }

  Widget bodyProgress() {
    return const Center(
        child: CircularProgressIndicator(
          value: null,
          strokeWidth: 4.0,
        ));
  }

  Widget yesMessages() {
    return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            loadingMessages = true;
          });

          await loadMessages();

          setState(() {
            loadingMessages = false;
          });
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                //carsCards(),
              ],
            )
        )
    );
  }

  Widget noMessages() {
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
              'Повідомлень немає', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

}
