// ignore_for_file: unused_field, unused_element, avoid_print, duplicate_ignore

import 'package:digital_books/pages/categories/category_data.dart';
import 'package:digital_books/pages/categories/single_category.dart';
import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../function.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;
  void getDataCategory(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "categories/readcat.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      categoryList!.add(CategoryData(
        cat_id: arr[i]["cat_id"],
        cat_name: arr[i]["cat_name"],
        //  cat_image: arr[i]["cat_image"],
        cat_date: arr[i]["cat_date"],
        cat_thumbnail: arr[i]["cat_thumbnail"],
      ));
    }
    loadingList = false;
    setState(() {});
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    myScroll!.dispose();
    categoryList!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    categoryList = <CategoryData>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDataCategory(0, "");

    myScroll?.addListener(() {
      // ignore: duplicate_ignore
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataCategory(i, "");
        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text("إدارة الأقسام");

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon = const Icon(Icons.close);
      _appBarTitle = TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          print(text);

          categoryList!.clear();
          i = 0;
          getDataCategory(0, text);
          myProv.add_loading();
        },
      );
    } else {
      _searchIcon = const Icon(Icons.search);
      _appBarTitle = const Text("إدارة الأقسام");
    }
    myProv.add_loading();
  }

  bool isFabVisibleAdd = true;

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      backgroundColor: pcWhite,
      //start for add button
      //end for add button
      // appBar: AppBar(
      //   // title: const Text("التصنيفات"),
      //   title: _appBarTitle,
      //   centerTitle: true,
      //   actions: [
      //     Container(
      //       padding: const EdgeInsets.all(10),
      //       child: GestureDetector(
      //         onTap: () {
      //           _searchPressed(myProvider);
      //         },
      //         child: _searchIcon,
      //       ),
      //     )
      //   ],
      // ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() {
              isFabVisibleAdd = true;
            });
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() {
              isFabVisibleAdd = false;
            });
          }
          return true;
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          //color: Colors.amber,
          child: RefreshIndicator(
            onRefresh: () async {
              i = 0;
              categoryList!.clear();
              getDataCategory(0, "");
            },
            key: refreshKey,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: ListView.builder(
                      controller: myScroll,
                      itemCount: categoryList!.length,
                      itemBuilder: (context, index) {
                        final item = categoryList![index];
                        return SingleCategory(
                          cat_index: index,
                          categories: categoryList![index],
                        );
                      },
                    ),
                  ),
                  Positioned(
                      child: loadingList ? circularProgress() : const Text(""),
                      bottom: 0,
                      left: MediaQuery.of(context).size.width / 2)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
