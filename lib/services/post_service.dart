import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/post.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:wp_car/system/system.dart';

const postsURL = '$baseURL/post-car';

// get all posts
Future<ApiResponse> getCarPosts(carID) async {
  ApiResponse apiResponse = ApiResponse();
  try {

    // User settings
    var userId = await getUserId();

    String token = await getToken();
    final response = await http.get(Uri.parse("$postsURL/$carID"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJsonLaravel(p)).toList();
        // we get list of posts, so we need to map each item to post model
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
    debugPrint(e.toString());
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Create post
Future<ApiResponse> createCarPost(
    String categoryId,
    String carId,
    String title,
    String description,
    String mileage,
    String cost,
    String tags,
    bool draft,
    bool enableComments,
    String? image
    ) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(postsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null ? {
          'post_category_id': categoryId,
          'car_id': carId,
          'title': title,
          'body': description,
          'cost': cost,
          'mileage': mileage,
          'tags': tags,
          'draft': draft?'1':'0',
          'enable_comments': enableComments?'1':'0',
          'image': image
        } : {
          'post_category_id': categoryId,
          'car_id': carId,
          'title': title,
          'body': description,
          'cost': cost,
          'mileage':  mileage,
          'tags': tags,
          'draft': draft?'1':'0',
          'enable_comments': enableComments?'1':'0',
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
    debugPrint(e.toString());
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Edit post
Future<ApiResponse> editCarPost(
    int carId,
    int postId,
    String title,
    String description,
    int mileage,
    double cost,
    String? image
    ) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$postsURL/$carId/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null ? {
          'car_id': carId,
          'title': title.toString(),
          'body': description.toString(),
          'mileage':  mileage,
          'cost': cost,
          'draft': 0,
          'enable_comments': 1,
          'image': image
        } : {
          'auto_id': carId,
          'title': title.toString(),
          'body': description.toString(),
          'mileage':  mileage,
          'cost': cost,
          'draft': 0,
          'enable_comments': 1,
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

// Delete post
Future<ApiResponse> deleteCarPost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$postsURL/$postId'),
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

// Like or unlike post
Future<ApiResponse> likeUnlikePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$postsURL/$postId/likes'),
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