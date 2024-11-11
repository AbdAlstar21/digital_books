// ignore_for_file: unused_import, non_constant_identifier_names, avoid_print, deprecated_member_use, dead_code

import 'package:digital_books/pages/config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import '';

Future<bool> updateDownload(
    Map arrInsert, String urlPage, BuildContext context) async {
  String url = api_path + "$urlPage?token=" + token;
  var uri = Uri.parse(url);
  print(uri.path);
  var request = http.MultipartRequest("POST", uri);
  for (var entry in arrInsert.entries) {
    request.fields[entry.key] = entry.value;
  }
  var response = await request.send();

  if (response.statusCode == 200) {
    print("Send succefull");
    return true;
  } else {
    return false;
    print("not send");
  }
}

Future<bool> SaveData(Map arrInsert, String urlPage, BuildContext context,
    Widget Function() movePage, String type) async {
  String url = api_path + "$urlPage?token=" + token;
  print(url);
  http.Response respone = await http.post(Uri.parse(url), body: arrInsert);
  if (json.decode(respone.body)["code"] == "200") {
    if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    } else {
      Navigator.pop(context);
    }

    print("success");
    return true;
  } else {
    print("Failer");
    return false;
  }
}

Future<bool> SaveFav(
    Map arrInsert, String urlPage, BuildContext context) async {
  String url = api_path + "$urlPage?token=" + token;
  print(url);
  http.Response respone = await http.post(Uri.parse(url), body: arrInsert);
  if (json.decode(respone.body)["code"] == "200") {
    print("success");
    return true;
  } else {
    print("Failer");
    return false;
  }
}

Future SaveDataListRepEva(Map arrInsert, String urlPage,
    Widget Function() movePage, BuildContext context, String type) async {
  String url = api_path + "${urlPage}?token=" + token;

  http.Response respone = await http.post(Uri.parse(url), body: arrInsert);
  // print(respone.body);
  if (json.decode(respone.body)["code"] == "200") {
   Map arr = json.decode(respone.body)["message"];

    print("success");
    if (type == "update") {
      Navigator.pop(context);
    } else if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    }
    
    return arr;
  } else {
    print("Failer");
    // return false;
  }
  return arrInsert;
}

Future<Map> SaveDataList(
    Map arrInsert, String urlPage, BuildContext context, String type) async {
  String url = api_path + "${urlPage}?token=" + token;

  http.Response respone = await http.post(Uri.parse(url), body: arrInsert);
  // print(respone.body);
  if (json.decode(respone.body)["code"] == "200") {
    Map arr = json.decode(respone.body)["message"];

    print("success");
    // print(arr);
    return arr;
  } else {
    print("Failer");
    // return false;
  }
  return arrInsert;
}

Future<bool> uploadImageWithData(
    dynamic imageFile,
    Map arrInsert,
    String urlPage,
    BuildContext context,
    Widget Function() movePage,
    String type) async {
  if (imageFile == null) {
    await SaveData(arrInsert, urlPage, context, movePage, type);
    return false;
  }
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

  var length = await imageFile.length();
  String url = api_path + "$urlPage?token=" + token;
  var uri = Uri.parse(url);
  print(uri.path);
  var request = http.MultipartRequest("POST", uri);
  var multipartFile = http.MultipartFile("file", stream, length,
      filename: basename(imageFile.path));
  for (var entry in arrInsert.entries) {
    request.fields[entry.key] = entry.value;
  }

  request.files.add(multipartFile);
  var response = await request.send();

  if (response.statusCode == 200) {
    print("Send succefull");
    if (type == "update") {
      Navigator.pop(context);
    } else if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    }
    return true;
  } else {
    return false;
    print("not send");
  }
}

Future<bool> SaveFile(dynamic file, Map arrInsert, String urlPage,
    BuildContext context, Widget Function() movePage, String type) async {
  String url = api_path + "$urlPage?token=" + token;
  var uri = Uri.parse(url);
  print(uri.path);
  var request = http.MultipartRequest("POST", uri);
  var uploadFile = await http.MultipartFile.fromPath("myfile", file);
  for (var entry in arrInsert.entries) {
    request.fields[entry.key] = entry.value;
  }
  request.files.add(uploadFile);
  var response = await request.send();
  if (response.statusCode == 200) {
    print("Send succefull");
    if (type == "update") {
      Navigator.pop(context);
    } else if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    }
    return true;
  } else {
    return false;
    print("not send");
  }
}

Future<bool> uploadFileWithData(
    dynamic file,
    dynamic imageFile,
    Map arrInsert,
    String urlPage,
    BuildContext context,
    Widget Function() movePage,
    String type) async {
  // if (file == null && imageFile == null) {
  //   await SaveData(arrInsert, urlPage, context, movePage, type);
  //   return false;
  // }
  //  if (file == null) {
  //   await uploadImageWithData(
  //       imageFile, arrInsert, urlPage, context, movePage, type);
  //   return false;
  // }
  // else
  if (imageFile == null) {
    await SaveFile(file, arrInsert, urlPage, context, movePage, type);
    return false;
  }
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();
  String url = api_path + "$urlPage?token=" + token;
  var uri = Uri.parse(url);
  print(uri.path);
  var request = http.MultipartRequest("POST", uri);
  var multipartFile = http.MultipartFile("image", stream, length,
      filename: basename(imageFile.path));
  var uploadFile = await http.MultipartFile.fromPath("myfile", file);
  for (var entry in arrInsert.entries) {
    request.fields[entry.key] = entry.value;
  }
  request.files.add(uploadFile);
  request.files.add(multipartFile);
  var response = await request.send();
  if (response.statusCode == 200) {
    print("Send succefull");
    if (type == "update") {
      Navigator.pop(context);
    } else if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    }
    return true;
  } else {
    return false;
    print("not send");
  }
}

////

Future<List> getData(
    int count, String urlPage, String strSearch, String param) async {
  String url = api_path +
      "$urlPage?${param}txtsearch=$strSearch&start=$count&end=10&token=" +
      token;
  print(url);
  http.Response respone = await http.post(Uri.parse(url));
  List arr = (json.decode(respone.body)["message"]);
  if (json.decode(respone.body)["code"] == "200") {
    {
       print(arr);
      return arr;
    }
  }
  return arr;
}

Future<bool> deleteData(String col_id, String val_id, String urlPage) async {
  String url = api_path + "$urlPage?$col_id=$val_id&token=" + token;
  print(url);
  http.Response respone = await http.post(Uri.parse(url));

  if (json.decode(respone.body)["code"] == "200") {
    return true;
  } else {
    return false;
  }
}
