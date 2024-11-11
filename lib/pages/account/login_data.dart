
import 'dart:convert';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../config.dart';
import '../main.dart';

Future<bool> loginUsers(
    // ignore: non_constant_identifier_names
    String user_email, String user_password, BuildContext context) async {
  String url = api_path +
      "users/login.php?user_email=" +
      user_email +
      "&user_password=" +
      user_password +
      "&token=" +
      token;
  http.Response response = await http.get(Uri.parse(url));
  if (json.decode(response.body)["code"] == "200") {
    Map arr = json.decode(response.body)["message"];
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString(G_user_id, arr["user_id"]);
    sh.setString(G_user_name, arr["user_name"]);
    sh.setString( G_user_thumbnail, arr["user_thumbnail"]);
    sh.setString(G_user_email, arr["user_email"]);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) =>  const Home()));    
    return true;
  } else {
    return false;
  }
}
