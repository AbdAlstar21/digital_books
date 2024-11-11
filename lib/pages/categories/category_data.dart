// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, unused_import, must_be_immutable
import 'package:provider/provider.dart';
import '../function.dart';
import '../config.dart';
import 'package:digital_books/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_network/image_network.dart';
import 'package:digital_books/pages/books/books_cat.dart';


List<CategoryData>? categoryList;
String imageCategory = images_path + "categories/";

class CategoryData {
  String cat_id;
  String cat_name;
   String? cat_image;
  String cat_thumbnail;
  String cat_date;
  CategoryData({
    required this.cat_id,
    required this.cat_name,
     this.cat_image,
    required this.cat_thumbnail,
    required this.cat_date,
  });
}
