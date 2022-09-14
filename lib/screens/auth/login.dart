import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_car/home.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/user.dart';
import 'package:wp_car/screens/auth/registration.dart';
import 'package:wp_car/services/user_service.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {

  double heightWindow = 0;

  bool loading = false;

  // Form key
  final _formKey = GlobalKey<FormState>();
  final _formSingleKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  // string for displaying the error Message
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  void _loginUser() async {
    ApiResponse response = await login(emailController.text, passwordController.text);
    if (response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }
    else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token);
    await pref.setInt('userId', user.id);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const ScreenHomePage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.teal,
        ),
        child: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const SizedBox(height: 100),
              const Icon(Icons.car_repair, size: 120, color: Colors.white),
              emailField(),
              passwordField(),
              login2Button(),
              registration2Button(),
              const SizedBox(height: 190),
              Text(
                'TM Yarsoft. Version: ${_packageInfo.version}. Build:  ${_packageInfo.buildNumber}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget emailField() {

    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 15, 36, 0),
      child: TextFormField(
          autofocus: false,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ('Введіть E-Mail');
            }
            // reg expression for email validation
            if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                .hasMatch(value)) {
              return ('Будь ласка, введіть правильний E-mail');
            }
            return null;
          },
          onSaved: (value) {
            emailController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.mail),
            contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            //labelText: 'E-mail',
            hintText: 'E-mail',
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0),
            ),
          )),
    );

  }

  Widget passwordField(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 15, 36, 0),
      child: TextFormField(
          autofocus: false,
          controller: passwordController,
          obscureText: true,
          validator: (value) {
            RegExp regex = RegExp(r'^.{6,}$');
            if (value!.isEmpty) {
              return ('Вкажіть пароль');
            }
            if (!regex.hasMatch(value)) {
              return ('Введіть пароль (мінімум 6 символів)');
            }
            //return ('Невід');
          },
          onSaved: (value) {
            passwordController.text = value!;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            hintText: 'Пароль',
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0),
            ),
          )
      ),
    );

  }

  Widget login2Button(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 15, 36, 0),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal[200]),
          ),
          onPressed: () async {
            _loginUser();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(height: 50,),
              Text('Увійти',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
            ],
          )),
    );

  }

  Widget registration2Button() {

    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 15, 36, 0),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal[200]),
          ),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const ScreenRegistration()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(height: 50,),
              Text('Зареєструватися',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
            ],
          )),
    );

  }
}