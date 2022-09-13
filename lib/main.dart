import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wp_car/db/init_db.dart';
import 'package:wp_car/home.dart';
import 'package:wp_car/system/splash.dart';

void main() async {

  // Так себе надувательство :)
  WidgetsFlutterBinding.ensureInitialized();

  // Включаем только портретную ориентацию
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // Подключаем Firebase для авторизации
  //await Firebase.initializeApp();

  // Красим статусар в синий цвет
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.teal));

  // Выполняем основную программу
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void dispose() {
    DatabaseHelper.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WP Cars',
      theme: ThemeData(
        fontFamily: 'ACDisplay',
        primarySwatch: Colors.teal,
      ),
      home: const ScreenSplashScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        //Locale('ru'),
        Locale('en'),
        Locale('uk'),
        // ... other locales the app supports
      ],
      locale: const Locale('uk'),
    );
  }
}
