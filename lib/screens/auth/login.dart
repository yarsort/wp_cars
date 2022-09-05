import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wp_car/home.dart';
import 'package:wp_car/screens/auth/registration.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    // Email field
    final emailField = TextFormField(
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
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail, color: Colors.blue,),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          labelText: 'E-mail',
          hintText: 'E-mail',
          border: OutlineInputBorder(),
        ));

    // Password field
    final passwordField = TextFormField(
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
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.vpn_key, color: Colors.blue,),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          labelText: 'Пароль',
          hintText: 'Пароль',
          border: OutlineInputBorder(),
        ));

    final login2Button = ElevatedButton(
        onPressed: () async {
          signIn(emailController.text, passwordController.text);
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
        ));

    final registration2Button = ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue[200]),
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
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_splash.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            //color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      child: SizedBox(),
                    ),
                    SizedBox(
                         height: MediaQuery.of(context).size.height * 0.15,
                         child: Image.asset(
                           'assets/images/wpsales_logo.png',
                           fit: BoxFit.contain,
                         )),
                    const SizedBox(height: 30),
                    emailField,
                    const SizedBox(height: 15),
                    passwordField,
                    const SizedBox(height: 15),
                    login2Button,
                    const SizedBox(height: 15),
                    registration2Button,
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      'TM Yarsoft. Version: ${_packageInfo.version}. Build:  ${_packageInfo.buildNumber}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showMessage(String textMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(textMessage),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  // Login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ScreenHomePage())),
        });
        showMessage('Авторизація успішно виконана!');

      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'Вказано неправильний E-mail.';
            break;
          case 'wrong-password':
            errorMessage = 'Вказано неправильний пароль.';
            break;
          case 'user-not-found':
            errorMessage = 'Користувача не знайдено.';
            break;
          case 'user-disabled':
            errorMessage = 'Користувача вимкнено.';
            break;
          case 'too-many-requests':
            errorMessage = 'Занадто багато запитів підключення.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Операція авторизації користувача не підключена.';
            break;
          default:
            errorMessage = 'Невідома помилка.';
        }
        showMessage(errorMessage!);
        debugPrint(error.code);
      }
    }
  }
}