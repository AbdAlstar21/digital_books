// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class LoadingControl with ChangeNotifier {
  void add_loading() {
    notifyListeners();
  }
}