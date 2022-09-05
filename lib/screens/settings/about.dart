import 'package:flutter/material.dart';

class ScreenAbout extends StatefulWidget {
  const ScreenAbout({Key? key}) : super(key: key);

  @override
  _ScreenAboutState createState() => _ScreenAboutState();
}

class _ScreenAboutState extends State<ScreenAbout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Про додаток'),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Призначення',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text(
                          'Додаток розроблено для менеджерів продажу та працівників складу, які працюють '
                          'віддалено і не можуть користуватися обліковими '
                          'системами на комп\'ютері. \n'),
                      Text(
                        'Авторство',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text('Розробник: Стрижаков Ярослав \n'
                          'Пошта: yarsort@gmail.com \n'
                          'Telegram канал додатку: https://t.me/wp_sales_yarsoft\n'),
                      Text(
                          'Побажання по вдосконаленню або новим функціям прошу '
                              'надсилати в коментарях каналу або на пошту.'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
