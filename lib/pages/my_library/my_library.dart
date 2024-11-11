import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/books/favorite.dart';
// import 'package:digital_books/pages/my_library/my_books.dart';
import 'package:flutter/material.dart';

import '../books/books.dart';
import '../books/my_Download.dart';

class MyLibrary extends StatelessWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          bottom: const TabBar(
            labelStyle: TextStyle(fontFamily: "Cairo", fontSize: 15),
            labelColor: pcBlack,
            tabs: [
              Tab(
                  text: "التنزيلات",
                  icon:
                      Icon(Icons.download, size: 30, color: Color(0xFF1B5E20))),
              // color: Colors.green)),
              Tab(
                text: "المفضلة",
                icon: Icon(Icons.favorite,
                    size: 30,
                    // color: Colors.purple,
                    color: Colors.purple),
              ),
              Tab(
                  text: "كتبي",
                  icon: Icon(Icons.my_library_books_outlined,
                      size: 30,
                      // color: Colors.brown,
                      color: Colors.orangeAccent)),
            ],
          ),
          title: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'مكتبتي',
              // style: TextStyle(
              //     fontSize: 30, fontFamily: "Cairo", color: Colors.blue),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,

          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     size: 30,
          //     color: Colors.blue,
          //   ),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
        ),
        body: const TabBarView(
          children: [
            myDownloads(),
            MyFavorite(),
            Books(),
         ],
        ),
      ),
    );
  }
}
