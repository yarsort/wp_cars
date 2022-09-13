import 'dart:convert';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:wp_car/system/system.dart';

// get all cars
Future<ApiResponse> getCars() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(carsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['cars'].map((p) => Car.fromJson(p)).toList();
        // we get list of cars, so we need to map each item to car model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Create car
Future<ApiResponse> createCar(
    String name,
    String nickname,
    String description,
    String yearProduction,
    String mileage,
    String vinCode,
    String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(carsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }, body: image != null ? {
          'type_transport_id': '0',
          'car_brand_id': '0',
          'car_model_id': '0',
          'uid': '00000000-0000-0000-0000-000000000000',
          'code': '00000000-0000-0000-0000-000000000000',
          'name': name.toString(),
          'nickname': nickname.toString(),
          'description': description.toString(),
          'year_production': yearProduction.toString(),
          'mileage': mileage.toString(),
          'vin_code': vinCode.toString(),
          'image': image
        } : {
          'type_transport_id': '0',
          'car_brand_id': '0',
          'car_model_id': '0',
          'uid': '00000000-0000-0000-0000-000000000000',
          'code': '00000000-0000-0000-0000-000000000000',
          'name': name.toString(),
          'nickname': nickname.toString(),
          'description': description.toString(),
          'year_production': yearProduction.toString(),
          'mileage': mileage.toString(),
          'vin_code': vinCode.toString()
        });

    // here if the image is null we just send the body, if not null we send the image too

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError + e.toString();
  }
  return apiResponse;
}

// Edit car
Future<ApiResponse> editCar(
    int carId,
    String name,
    String nickname,
    String description,
    String yearProduction,
    String mileage,
    String vinCode,
    String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$carsURL/$carId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }, body: image != null ? {
          'type_transport_id': 0,
          'car_brand_id': 0,
          'car_model_id': 0,
          'uid': '00000000-0000-0000-0000-000000000000',
          'code': '00000000-0000-0000-0000-000000000000',
          'name': name.toString(),
          'nickname': nickname.toString(),
          'description': description.toString(),
          'year_production': int.parse(yearProduction),
          'mileage': int.parse(mileage),
          'vin_code': vinCode.toString(),
          'image': image
        } : {
          'type_transport_id': 0,
          'car_brand_id': 0,
          'car_model_id': 0,
          'uid': '00000000-0000-0000-0000-000000000000',
          'code': '00000000-0000-0000-0000-000000000000',
          'name': name.toString(),
          'nickname': nickname.toString(),
          'description': description.toString(),
          'year_production': int.parse(yearProduction),
          'mileage': int.parse(mileage),
          'vin_code': vinCode.toString()
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Delete car
Future<ApiResponse> deleteCar(int carId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$carsURL/$carId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Like or unlike car
Future<ApiResponse> likeUnlikeCar(int carId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$carsURL/$carId/likes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}