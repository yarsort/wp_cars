import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wp_car/home.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/system.dart';

class ScreenSplashScreen extends StatefulWidget {
  const ScreenSplashScreen({Key? key}) : super(key: key);

  @override
  _ScreenSplashScreenState createState() => _ScreenSplashScreenState();
}

class _ScreenSplashScreenState extends State<ScreenSplashScreen> {

  bool visible = false;
  DateTime currentBackPressTime = DateTime.now();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.teal,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                const Icon(Icons.car_repair, size: 120, color: Colors.white),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'WP',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 80,
                      color: Colors.white),textAlign: TextAlign.center,
                ),
                const Text(
                  'cars',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.white),textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Коли любиш своє авто',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.teal.shade100),textAlign: TextAlign.center,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Text(
                  'TM Yarsoft. Version: ${_packageInfo.version}. Build:  ${_packageInfo.buildNumber}',
                  style: TextStyle(color: Colors.teal.shade400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future initializeUser() async {

    String token = await getToken();
    if(token == ''){
      Timer(
        const Duration(seconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                const ScreenLogin()),
                (Route<dynamic> route) => false),
      );
    }
    else {
      ApiResponse response = await getUserDetail();
      if (response.error == null){
        Timer(
          const Duration(seconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                  const ScreenHomePage()),
                  (Route<dynamic> route) => false),
        );
      }
      else if (response.error == unauthorized){
        Timer(
          const Duration(seconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                  const ScreenLogin()),
                  (Route<dynamic> route) => false),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showMessage('Для виходу натисніть кнопку "Назад" ще раз.', context);
      return false;
    }
    return true;
  }

  cornerLogo() {
    return CircleAvatar(
      radius: 58,
      child: ClipOval(
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          height: 114,
          width: 114,
        ),
      ),
    );
  }

  logo() {
    return Image.asset(
      'assets/app_logo.png',
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    );
  }
}
