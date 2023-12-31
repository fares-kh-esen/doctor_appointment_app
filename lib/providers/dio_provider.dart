import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  //get token
  // static String appUrl = "192.168.1.27:8000";
  static String appUrl = "10.0.2.2:8000";
  Future<dynamic> getToken(String email, String password) async {
    // try {
    print('getToken');
    var response = await Dio().post('http://$appUrl/api/login',
        data: {'email': email, 'password': password});

    if (response.statusCode == 200 && response.data != '') {
      print(response.data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data);
      return true;
    } else {
      return false;
    }
    // } catch (error) {
    //   return error;
    // }
  }

  //get user data
  Future<dynamic> getUser(String token) async {
    // try {
    print('getUser');
    var user = await Dio().get('http://$appUrl/api/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    print(user.statusCode);
    print(user.data);
    if (user.statusCode == 200 && user.data != '') {
      return json.encode(user.data);
    }
    // } catch (error) {
    //   return error;
    // }
  }

  //register new user
  Future<dynamic> registerUser(
      String username, String email, String password) async {
    try {
      var user = await Dio().post('http://$appUrl/api/register',
          data: {'name': username, 'email': email, 'password': password});
      if (user.statusCode == 201 && user.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      print('bookAppointment');
      var response = await Dio().post('http://$appUrl/api/book',
          data: {'date': date, 'day': day, 'time': time, 'groomer_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getAppointments(String token) async {
    try {
      var response = await Dio().get('http://$appUrl/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store rating details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      var response = await Dio().post('http://$appUrl/api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'doctor_id': doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store fav doctor
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('http://$appUrl/api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('http://$appUrl/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
}
