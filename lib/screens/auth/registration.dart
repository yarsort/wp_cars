import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_car/home.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/user.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/system.dart';

class ScreenRegistration extends StatefulWidget {
  const ScreenRegistration({Key? key}) : super(key: key);

  @override
  State<ScreenRegistration> createState() => _ScreenRegistrationState();
}

class _ScreenRegistrationState extends State<ScreenRegistration> {
  bool loading = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // string for displaying the error Message
  String? errorMessage;

  // Our form key
  final _formKey = GlobalKey<FormState>();

  // Editing Controller
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// Name
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ('Ім\'я не може бути порожнім');
          }
          if (!regex.hasMatch(value)) {
            return ('Вкажіть ім\'я (мінімум 3 символа)');
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          labelText: 'Ім\'я',
          hintText: 'Ім\'я',
          border: OutlineInputBorder(),
        ));

    // Email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ('Вкажіть Ваш E-mail');
          }
          // reg expression for email validation
          if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
              .hasMatch(value)) {
            return ('Вкажіть правильний E-mail');
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: 'E-mail',
          hintText: 'E-mail',
          border: OutlineInputBorder(),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ('Вкажіть пароль');
          }
          if (!regex.hasMatch(value)) {
            return ('Вкажіть правильний пароль (мінімум 6 символів)');
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: 'Пароль',
          hintText: 'Пароль',
          border: OutlineInputBorder(),
        ));

    // Confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return 'Паролі не співпадають';
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: 'Підтвердження пароля',
          hintText: 'Підтвердження пароля',
          border: OutlineInputBorder(),
        ));

    final signUpButton = ElevatedButton(
        onPressed: () async {
          if (emailEditingController.text.trim() == '') {
            showErrorMessage('Паролі не співпадають', context);
            return;
          }
          if (passwordEditingController.text !=
              confirmPasswordEditingController.text) {
            showErrorMessage('Паролі не співпадають', context);
            return;
          }

          _registerUser();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 50,
            ),
            Text(
              'Зареєструватися',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ));

    final loginButton = ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue[200]),
        ),
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ScreenLogin()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 50,
            ),
            Text(
              'Увійти',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       // passing this to our root
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),
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
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.asset(
                          'assets/images/wpsales_logo.png',
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 15),
                    firstNameField,
                    const SizedBox(height: 15),
                    emailField,
                    const SizedBox(height: 15),
                    passwordField,
                    const SizedBox(height: 15),
                    confirmPasswordField,
                    const SizedBox(height: 15),
                    signUpButton,
                    const SizedBox(height: 15),
                    loginButton,
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    if (loading) {
      return;
    }

    ApiResponse response = await register(firstNameEditingController.text,
        emailEditingController.text, passwordEditingController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token);
    await pref.setInt('userId', user.id);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ScreenHomePage()),
        (route) => false);
  }
}
