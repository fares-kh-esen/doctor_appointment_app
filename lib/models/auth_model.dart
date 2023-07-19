import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {}; //update user details when login
  Map<String, dynamic> appointment =
      {}; //update upcoming appointment when login
  List<Map<String, dynamic>> favGroomers = []; //get latest favorite groomer
  List<Map<String, dynamic>> groomers = []; //get latest favorite groomer

  bool get isLogin {
    return _isLogin;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

  bool hasGroomerInFavs(groomer) {
    for (var i = 0; i < favGroomers.length; i++) {
      if (favGroomers[i]['groomer_id'] == groomer['groomer_id']) {
        return true;
      }
    }
    return false;
  }

//ni nak update latest favorite list and notify all widgets
  void setFavList(Map<String, dynamic> groomer) {
    if (hasGroomerInFavs(groomer)) {
      favGroomers.removeWhere(
          (element) => element['groomer_id'] == groomer['groomer_id']);
    } else {
      favGroomers.add(groomer);
    }
    notifyListeners();
  }

//and this is to return latest favorite groomer list
  // List<Map<String, dynamic>> get getFavGroomer {
  //   FavGroomer.clear();

  //   //list out groomer list according to favorite list
  //   for (var num in _fav) {
  //     for (var groomer in user['groomer']) {
  //       if (num == groomer['groomer_id']) {
  //         favGroomer.add(groomer);
  //       }
  //     }
  //   }
  //   return favGroomer;
  // }

//when login success, update the status
  void loginSuccess(data) {
    _isLogin = true;
    final resData = json.decode(data);

    //update all these data when login
    user = resData['user'];
    for (var i = 0; i < resData['groomers'].length; i++) {
      groomers.add(resData['groomers'][i]);
    }

    // appointment = appointmentInfo;
    // if (user['details'] != null && user['details']['fav'] != null) {
    //   _fav = json.decode(user['details']['fav']);
    // }

    notifyListeners();
  }
}
