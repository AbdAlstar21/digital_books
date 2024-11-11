// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, duplicate_ignore

import 'package:digital_books/pages/book_details/book_details.dart';
import 'package:digital_books/pages/drawer/drawer.dart';
import 'package:digital_books/pages/home/categories.dart';
import 'package:digital_books/pages/my_library/my_library.dart';
import 'package:flutter/material.dart';
import 'package:digital_books/pages/config.dart';

import '../categories/categories.dart';
import 'home.dart';

class SelectedScreen extends StatefulWidget {
  const SelectedScreen({Key? key}) : super(key: key);

  @override
  _SelectedScreenState createState() => _SelectedScreenState();
}

class _SelectedScreenState extends State<SelectedScreen> {
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
   int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": const Home()},
    {"screen": const MyLibrary()}
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return 
    // DefaultTabController(
    //   length: 6,
    //   child: Directionality(
    //     textDirection: TextDirection.rtl,
    //     child:
         Scaffold(
          // backgroundColor: Colors.white,
          // key: _keyDrawer,
          // // endDrawer: const myDrawer(),
          // drawer: const myDrawer(),
          // drawerScrimColor: Colors.white,
          body:_screens[_selectedScreenIndex]["screen"],
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.rtl,
            child: BottomNavigationBar(
              

              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الصفحة الرئيسية',
                  //backgroundColor: Colors.pink,
                  //backgroundColor: PrimaryColorGrey,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.book,
                  ),
                  label: 'مكتبتي',
                  //backgroundColor: Colors.pink,
                  //backgroundColor: PrimaryColorGrey,
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.favorite),
                //   label: 'مفضلاتي',
                //   //backgroundColor: Colors.green,
                //   //backgroundColor:PrimaryColorGrey,
                // ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.notifications),
                //   label: 'الإشعارات',
                //   //backgroundColor: Colors.red,
                //   //backgroundColor: PrimaryColorGrey,
                // ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.school),
                //   label: 'الجامعة',
                // ),
              ],
              onTap:_selectScreen,
              currentIndex: _selectedScreenIndex,
              selectedItemColor: pcBlue,
              unselectedItemColor: Colors.grey,
            ),
          ),
    );
  }
}
