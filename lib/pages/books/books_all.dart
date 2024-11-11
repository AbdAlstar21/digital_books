//changed//

import 'package:digital_books/pages/books/single_book_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:digital_books/pages/books/books_data.dart';
import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/function.dart';
import 'package:digital_books/pages/provider/loading.dart';
import 'package:digital_books/pages/books/widget_text.dart';

import '../book_details/book_details.dart';
import '../function.dart';
import '../home/home.dart';
import 'add_book.dart';
import 'books.dart';
import 'single_book.dart';

List<CatNI>? catNIListAll;
List<BooksData>? bookList;
// List<BooksData>? bookList;

class BooksAll extends StatefulWidget {
  @override
  _BooksAllState createState() => _BooksAllState();
}

class _BooksAllState extends State<BooksAll> {
  
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
    List arr = await getData(count, "evas/readeva.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      evaList!.add(Eva(
        eva_id: arr[i]["eva_id"],
        eva_note: arr[i]["eva_note"],
        eva_avg: arr[i]["eva_avg"],
      ));
    }
    setState(() {});
  }

  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;
  bool loadingListCatNI = false;
  void getDataCatNI(int count, String strSearch) async {
    loadingListCatNI = true;
    setState(() {});
    List arr = await getData(count, "categories/readcat.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      catNIListAll!.add(CatNI(
        cat_id: arr[i]["cat_id"],
        cat_name: arr[i]["cat_name"],
      ));
    }
    loadingListCatNI = false;
    setState(() {});
  }

  void getDataBook(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "books/readbook_user.php", strSearch,
        "user_id=${G_user_id_val}&");
    for (int i = 0; i < arr.length; i++) {
      bookList!.add(BooksData(
        eva_id: arr[i]["eva_id"],
        rep_id: arr[i]["rep_id"],
        book_publisher: arr[i]["book_publisher"], //
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
        book_eva: 0.0,
        book_download: (arr[i]["book_download"]).toString(),
        book_Number_of_reviews: 0,
        book_size: arr[i]["book_size"],

        book_file: arr[i]["book_file"], //
      ));
      List avg = await getData(count, "evas/readeva_avg.php", strSearch,
          "book_id=${bookList![i].book_id}&");
      if (avg[0]["eva_avg"] != null) {
        bookList![i].book_eva = double.parse(avg[0]["eva_avg"]);
      }
      if (avg[0]["eva_count"] != null && avg[0]["eva_count"]!=0 ) {
        bookList![i].book_Number_of_reviews = int.parse(avg[0]["eva_count"]);
      }
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
    bookList!.clear();
    catNIListAll!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    bookList = <BooksData>[];
    catNIListAll = <CatNI>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    repList = <Rep>[];
    evaList = <Eva>[];

    getDataCatNI(0, "");
    getDataBook(0, "");
    getrepname(0, "");
    getevaname(0, "");
    

    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataBook(i, "");
        getDataCatNI(i, "");
        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  bool isFabVisible = true;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: pcWhite,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                isFabVisible = true;
              });
            } else if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                isFabVisible = false;
              });
            }
            return true;
          },
          child:loadingListCatNI || loadingList? circularProgress():RefreshIndicator(
            onRefresh: () async {
              i = 0;
              bookList!.clear();
              catNIListAll!.clear();
              getDataCatNI(0, "");
              getDataBook(0, "");
            },
            key: refreshKey,
            child:Container(
                    height: height * 0.9,
                    // color: Colors.green,
                    width: width,
                    child: Builder(builder: (context) {
                      List<int> indexs = [];
                      final item;
                      int counter = 0;

                      // print(catNIListAll!.length);
                      // print(bookList!.length);

                      for (var ci = 0; ci < catNIListAll!.length; ci++) {
                        counter = 0;
                        for (var bi = 0; bi < bookList!.length; bi++) {
                          if (bookList![bi].cat_id ==
                              catNIListAll![ci].cat_id) {
                            counter++;
                          }
                        }
                        if (counter == 0) {
                          indexs.add(ci);
                        }
                      }
                      int li = indexs.length;
                      for (var i = 0; i < li; i++) {
                        print(catNIListAll![indexs[i]].cat_name);
                        catNIListAll!.removeAt(indexs[i]);
                        for (var j = i + 1; j < li; j++) {
                          indexs[j] = indexs[j] - 1;
                        }
                      }

                      // print(catNIListAll!.length);
                      // print(bookList!.length);

                      return ListView.builder(
                          itemCount: catNIListAll!.length,
                          itemBuilder: (cxt, j) {
                            return Column(
                              children: [
                                Container(
                                  width: width,
                                  height: height * 0.048,
                                  // color: Colors.red,
                                  child: Text(
                                    catNIListAll![j].cat_name,
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                    width: width,
                                    height: height * 0.34,
                                    // color: Colors.amber,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: bookList!.length,
                                        // controller: myScroll,
                                        itemBuilder: (context, i) {
                                          if (bookList![i].cat_id ==
                                              catNIListAll![j].cat_id) {
                                            return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BookDetails(
                                                                  books:
                                                                      bookList![
                                                                          i],
                                                                  book_index:
                                                                      i)));
                                                },
                                                child: Container(
                                                    // color: Colors.amber,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2, right: 2),
                                                    // height: 250,
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            // Material(
                                                            //     elevation: 0.0,
                                                            //     child: Container(
                                                            //       height: height * 0.34,
                                                            //       width: width * 0.32,
                                                            //       decoration: BoxDecoration(
                                                            //         color: Colors.white,
                                                            //         borderRadius:
                                                            //             BorderRadius.circular(
                                                            //                 0.0),
                                                            //         boxShadow: [
                                                            //           BoxShadow(
                                                            //               color: Colors.grey
                                                            //                   .withOpacity(0.3),
                                                            //               offset:
                                                            //                   Offset(0.0, 0.0),
                                                            //               blurRadius: 20.0,
                                                            //               spreadRadius: 4.0)
                                                            //         ],
                                                            //       ),
                                                            //       // child: Text("This is where your content goes")
                                                            //     )),
                                                            Card(
                                                                elevation: 5.0,
                                                                shadowColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            4,
                                                                            205,
                                                                            255)
                                                                    .withOpacity(
                                                                        0.5),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: width *
                                                                          0.28,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      margin: const EdgeInsets
                                                                              .all(
                                                                          7.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                        color: Colors
                                                                            .blue[300],
                                                                      ),
                                                                      child: bookList![i].book_thumbnail == "" ||
                                                                              bookList![i].book_thumbnail == null
                                                                          ? ImageNetwork(
                                                                              curve: Curves.easeInCubic,
                                                                              onPointer: true,
                                                                              debugPrint: true,
                                                                              fullScreen: true,
                                                                              fitAndroidIos: BoxFit.fill,
                                                                              fitWeb: BoxFitWeb.fill,
                                                                              image: imageBook + "def.png",
                                                                              width: 110,
                                                                              height: 140,
                                                                              onLoading: CircularProgressIndicator(
                                                                                color: Colors.indigoAccent,
                                                                              ),
                                                                              onError: const Icon(
                                                                                Icons.error,
                                                                                color: Colors.red,
                                                                              ),
                                                                            )
                                                                          : ImageNetwork(
                                                                              curve: Curves.easeInCubic,
                                                                              onPointer: true,
                                                                              debugPrint: true,
                                                                              fullScreen: true,
                                                                              fitAndroidIos: BoxFit.fill,
                                                                              fitWeb: BoxFitWeb.fill,
                                                                              image: imageBook + bookList![i].book_thumbnail,
                                                                              width: 110,
                                                                              height: 140,
                                                                              onLoading: CircularProgressIndicator(
                                                                                color: Colors.indigoAccent,
                                                                              ),
                                                                              onError: const Icon(
                                                                                Icons.error,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          height *
                                                                              0.14,
                                                                      width: width *
                                                                          0.25,
                                                                      // color: Colors.amber,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            TextWidget(
                                                                              text: bookList![i].book_name,
                                                                              fontSize: 17,
                                                                              color: Color.fromARGB(255, 90, 68, 68),
                                                                              isUnderLine: false,
                                                                            ),
                                                                            Divider(color: Colors.black),
                                                                            SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.star,
                                                                                      color: Colors.amber,
                                                                                    ),
                                                                                    Text(
                                                                                      bookList![i].book_eva.toString(),
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Cairo", fontSize: 17),
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.only(right: 10)),
                                                                                    Row(
                                                                                      children: [
                                                                                        const Icon(
                                                                                          Icons.download,
                                                                                          color: Colors.purple,
                                                                                        ),
                                                                                        Text(
                                                                                          bookList![i].book_download.toString(),
                                                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Cairo", fontSize: 17),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                            Divider(color: Colors.black),
                                                                            SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.date_range,
                                                                                      color: Colors.blueAccent,
                                                                                    ),
                                                                                    Text(
                                                                                      bookList![i].book_date,
                                                                                      style: TextStyle(color: Color.fromARGB(255, 8, 0, 83), fontWeight: FontWeight.w600, fontSize: 16),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    )));
                                          } else {
                                            return Container();
                                          }
                                        })),

                                //     ],

                                //           ),
                                // ),
                              ],
                            );
                          });
                    })),
          ),
        ));
  }
}
