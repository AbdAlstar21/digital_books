// ignore_for_file: unused_import, non_constant_identifier_names, must_be_immutable
//changed//
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import 'package:digital_books/pages/provider/loading.dart';

import '../config.dart';
import '../function.dart';

List<BooksData>? bookList;
List<BooksData>? bookListFav;
String imageBook = images_path + "books/";
String fileBook = files_path;

class BooksData {
  String book_publisher; 
  String? cat_id;
  String? publisher_id;
  String fav_id;
  String rep_id;
  String eva_id;
  String book_id;
  String book_name;
  String book_author_name;
  String book_lang;
  bool book_block;
  String book_date;
  String book_summary;
  String book_thumbnail;
   String? book_image;
  double? book_eva;
  String? book_download;
  int? book_page_number;
  int? book_Number_of_reviews;
  String book_size;
   String book_file;
  

  BooksData({
     this.cat_id,
      this.publisher_id,
    required this.fav_id,
    required this.eva_id,
    required this.rep_id,
    required this.book_publisher,
    required this.book_id,
    required this.book_name,
    required this.book_author_name,
    required this.book_lang,
    required this.book_block,
    required this.book_date,
    required this.book_summary,
    required this.book_thumbnail,
    this.book_image,
    this.book_eva,
    this.book_download,
    this.book_page_number,
    this.book_Number_of_reviews,
   required this.book_size,
    required this.book_file, 
  });
}
