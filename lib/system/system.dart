import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int selectedMenuIndex = 0;

const Color iconColor = Color.fromRGBO(120, 198, 247, 1);

const siteURL = 'http://192.168.50.4:8000';
const baseURL = 'http://192.168.50.4:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';

const carsURL = '$baseURL/cars';
const userCarsURL = '$baseURL/user-cars';
const commentsURL = '$baseURL/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

doubleToString(double sum) {
  var f = NumberFormat("##0.00", "en_US");
  return (f.format(sum).toString());
}

doubleThreeToString(double sum) {
  var f = NumberFormat("##0.000", "en_US");
  return (f.format(sum).toString());
}

shortDateToString(DateTime date) {
  // Проверка на пустую дату
  if (date == DateTime(1900, 1, 1)) {
    return '';
  }
  // Отформатируем дату
  var f = DateFormat('dd.MM.yyyy');
  return (f.format(date).toString());
}

fullDateToString(DateTime date) {
  // Проверка на пустую дату
  if (date == DateTime(1900, 1, 1)) {
    return '';
  }
  // Отформатируем дату
  var f = DateFormat('dd.MM.yyyy HH:mm:ss');
  return (f.format(date).toString());
}

showMessage(String textMessage, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blue,
      content: Text(textMessage),
      duration: const Duration(seconds: 3),
    ),
  );
}

showErrorMessage(String textMessage, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(textMessage),
      duration: const Duration(seconds: 2),
    ),
  );
}

TextButton kTextButton(String label, Function onPressed){
  return TextButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.teal),
        padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 10))
    ),
    onPressed: () => onPressed(),
    child: Text(label, style: const TextStyle(color: Colors.white),),
  );
}
