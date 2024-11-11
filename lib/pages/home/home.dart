// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, duplicate_ignore

import 'package:digital_books/pages/book_details/book_details.dart';
import 'package:digital_books/pages/books/books.dart';
import 'package:digital_books/pages/drawer/drawer.dart';
import 'package:digital_books/pages/function.dart';
import 'package:digital_books/pages/home/categories.dart';
import 'package:flutter/material.dart';
import 'package:digital_books/pages/config.dart';
import 'package:provider/provider.dart';

import '../books/books_data.dart';
import '../books/books_all.dart';
import '../books/books_cat.dart';
import '../books/books_download.dart';
import '../books/books_eva.dart';
import '../books/books_new.dart';
import '../books/books_old.dart';
import '../categories/categories.dart';
import '../provider/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  ///
  ///
  void getrepname(int count, String strSearch) async {
    setState(() {});
    List arr = await getData(count, "reports/readrep.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      repList!.add(Rep(rep_id: arr[i]["rep_id"], rep_note: arr[i]["rep_note"]));
    }
    setState(() {});
  }

  void getevaname(int count, String strSearch) async {
    setState(() {});
    List arr = await getData(count, "reports/readrep.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      evaList!.add(Eva(
        eva_id: arr[i]["eva_id"],
        eva_note: arr[i]["eva_note"],
        eva_avg: arr[i]["eva_avg"],
      ));
    }
    setState(() {});
  }

  var myarr_category = [
    {
      "category_id": "1",
      "category_name": "category_1",
      "category_image": "images/im1.jfif"
    },
    {
      "category_id": "2",
      "category_name": "category_2",
      "category_image": "images/im2.jfif"
    },
    {
      "category_id": "3",
      "category_name": "category_3",
      "category_image": "images/im3.jfif"
    },
    {
      "category_id": "4",
      "category_name": "category_4",
      "category_image": "images/im4.jfif"
    },
    {
      "category_id": "5",
      "category_name": "category_5",
      "category_image": "images/im5.jfif"
    },
    {
      "category_id": "6",
      "category_name": "category_6",
      "category_image": "images/im6.jfif"
    },
    {
      "category_id": "7",
      "category_name": "category_7",
      "category_image": "images/im7.jfif"
    },
    {
      "category_id": "8",
      "category_name": "category_8",
      "category_image": "images/im8.jfif"
    },
  ];

  ///
  ///

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    myScroll!.dispose();
    bookList!.clear();
  }

  @override
  void initState() {
    repList = <Rep>[];
    evaList = <Eva>[];
    getrepname(0, "");

    getevaname(0, "");
    // ignore: todo
    // TODO: implement initState
    super.initState();
    bookList = <BooksData>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    // getDataBook(0, "");

    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataBook(i, "");
        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;

  void getDataBook(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "books/readbook_user.php", strSearch,
        "user_id=${G_user_id_val}&");
    for (int i = 0; i < arr.length; i++) {
      bookList!.add(BooksData(
        eva_id: arr[i]["eva_id"],

        rep_id: arr[i]["rep_id"],
        book_id: arr[i]["book_id"], //
        cat_id: arr[i]["cat_id"],
        fav_id: arr[i]["fav_id"],
        book_name: arr[i]["book_name"], //
        book_author_name: arr[i]["book_author_name"],
        book_lang: arr[i]["book_lang"], //
        book_block: arr[i]["book_block"] == "1" ? true : false,
        book_date: arr[i]["book_date"],
        book_summary: arr[i]["book_summary"],
        book_thumbnail: arr[i]["book_thumbnail"],
        book_eva: 4.2,
        book_download: (arr[i]["book_download"]).toString(),
        book_Number_of_reviews: 12,
        book_size: arr[i]["book_size"],
        book_publisher: arr[i]["book_publisher"],
        book_file: arr[i]["book_file"], //
      ));
      List avg = await getData(count, "evas/readeva_avg.php", strSearch,
          "book_id=${bookList![i].book_id}&");
      if (avg[0]["eva_avg"] != null) {
        bookList![i].book_eva = double.parse(avg[0]["eva_avg"]);
      }
      if (avg[0]["eva_count"] != null) {
        bookList![i].book_Number_of_reviews = int.parse(avg[0]["eva_count"]);
      }
    }
    loadingList = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var myProv = Provider.of<LoadingControl>(context);
    return DefaultTabController(
      length: 6,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          // backgroundColor: Colors.white,
          key: _keyDrawer,
          // endDrawer: const myDrawer(),
          drawer: const myDrawer(),
          drawerScrimColor: pcWhite,
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                snap: true,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 35.0,
                        // color: pcBlue,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
                // backgroundColor: Colors.white,
                title: Container(
                  height: 45,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 50.0, bottom: 50),
                  // padding: const EdgeInsets.only(top:3),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.only(right: 20, left: 5),
                        decoration: BoxDecoration(
                            color: pcGrey,
                            borderRadius: BorderRadius.circular(40.0)),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "بحث",
                              suffixIcon: Icon(Icons.search)),
                          onChanged: (text) {
                            print(text);

                            bookList!.clear();

                            i = 0;
                            getDataBook(0, text);
                            myProv.add_loading();
                          },
                        ),
                        // TextFormField(
                        //   decoration: const InputDecoration(
                        //     hintText: " بحث",
                        //     suffixIcon: Icon(
                        //       Icons.search,
                        //       color: pcGrey,
                        //     ),

                        //     // border: InputBorder.none,
                        //   ),
                        // ),
                      )),
                      // Container(
                      //   margin: const EdgeInsets.all(5.0),
                      //   padding: const EdgeInsets.all(5.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5.0),
                      //   ),
                      //   child: const Icon(
                      //     Icons.mic,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                //end title//

                bottom: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: pcBlack,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: pcGrey,
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            // color: pcGrey,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'جميع الكتب',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأعلى تقييماً',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأحدث',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأقدم',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأكثر تحميلا',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأنواع',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: <Widget>[
                BooksAll(),

                ///
                BooksEva(),
                ///////////////////////////////////////
                ///
                BooksNew(),
                //Text('Four'),
//book old
                BooksOld(),
                //end book old

                //Text('Five'),//start book download
                BooksDownloads(),
//end book download
                // Text('Six'),

                Categories(),
              ],
            ),
          ),
          // bottomNavigationBar: Directionality(
          //   textDirection: TextDirection.rtl,
          //   child: BottomNavigationBar(
          //     // onTap: (value) {
          //     //   if (value == 0) Navigator.of(context).push(Home());
          //     //   if (value == 1) Navigator.of(context).push(MyLibrary());
          //     //   // if (value == 2) Navigator.of(context).push(...);
          //     // },

          //     items: const <BottomNavigationBarItem>[
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.home),
          //         label: 'الصفحة الرئيسية',
          //         //backgroundColor: Colors.pink,
          //         //backgroundColor: PrimaryColorGrey,
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(
          //           Icons.book,
          //         ),
          //         label: 'مكتبتي',
          //         //backgroundColor: Colors.pink,
          //         //backgroundColor: PrimaryColorGrey,
          //       ),
          //       // BottomNavigationBarItem(
          //       //   icon: Icon(Icons.favorite),
          //       //   label: 'مفضلاتي',
          //       //   //backgroundColor: Colors.green,
          //       //   //backgroundColor:PrimaryColorGrey,
          //       // ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.notifications),
          //         label: 'الإشعارات',
          //         //backgroundColor: Colors.red,
          //         //backgroundColor: PrimaryColorGrey,
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.school),
          //         label: 'الجامعة',
          //       ),
          //     ],
          //     currentIndex: 0,
          //     selectedItemColor: pcBlue,
          //     unselectedItemColor: Colors.grey,
          //   ),
          // ),
        ),
      ),
    );
  }
}
