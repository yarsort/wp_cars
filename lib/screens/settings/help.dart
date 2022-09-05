import 'package:flutter/material.dart';

class ScreenHelp extends StatefulWidget {
  const ScreenHelp({Key? key}) : super(key: key);

  @override
  _ScreenHelpState createState() => _ScreenHelpState();
}

class _ScreenHelpState extends State<ScreenHelp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Довідка'),
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
                        'Замовлення покупців',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text(
                          'Використовуються для формування списку товарів в замовлення покупцем. \n\n'
                              'Вивантажуються в облікову систему та реєструються '
                              'в ній як документ "Замовлення покупця".\n'),
                      Text(
                        'Повернення товарів від покупців',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text('Використовуються для формування списку товарів які '
                          'повертаються від покупця. Можуть створюватися '
                          'на основі замовлення покупця. \n\n'
                          'Вивантажуються в облікову систему та реєструються '
                          'в ній як документ "Повернення товарів від покупця".\n'),
                      Text(
                        'Прибутковий касовий ордер',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text(
                          'Використовуються для оплати товарів та можуть створюватися '
                              'на основі замовлення покупця. \n\n'
                              'Вивантажуються в облікову систему та реєструються '
                              'в ній як документ "Прибутковий касовий ордер".\n'),
                      Text(
                        'Інвентаризація товарів на складі',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text('Використовуються для оплати перерахунку товарів на '
                          'вибраному складі. \n\nДля сканування можливе використання'
                          ' сканерів штрихкодів та ручне введення фактичної кількості'
                          ' методом підбору. \n\n'
                          'Вивантажуються в облікову систему та реєструються '
                          'в ній як документ "Інвентаризація товарів на складі".\n'),
                      Text(
                        'Чек ККМ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text(
                          'Використовуються для формування списку товарів в замовлення '
                              'покупцем у роздрібних мережах із використанням ПРРО (програмних реєстраторів). \n\n'
                              'Вивантажуються в облікову систему та реєструються '
                              'в ній як документ "Чек ККМ".\n'),
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
