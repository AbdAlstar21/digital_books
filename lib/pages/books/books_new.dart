//changed//

import 'package:digital_books/pages/books/single_book_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:digital_books/pages/books/books_data.dart';
import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/function.dart';
import 'package:digital_books/pages/provider/loading.dart';

import '../book_details/book_details.dart';
import '../function.dart';
import 'add_book.dart';
import 'single_book.dart';
List<BooksData>? bookListNew;

class BooksNew extends StatefulWidget {
  @override
  _BooksNewState createState() => _BooksNewState();
}

class _BooksNewState extends State<BooksNew> {
  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;

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

  void getDataBook(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "books/readbook_user.php", strSearch,
        "user_id=${G_user_id_val}&");
    for (int i = 0; i < arr.length; i++) {
      bookListNew!.add(BooksData(
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
        book_eva: 0.0,
        book_download: (arr[i]["book_download"]).toString(),
        book_Number_of_reviews: 12,
        book_size: arr[i]["book_size"],

        book_publisher: arr[i]["book_publisher"],

        book_file: arr[i]["book_file"], //
      ));
      List avg = await getData(count, "evas/readeva_avg.php", strSearch,
          "book_id=${bookListNew![i].book_id}&");
      if (avg[0]["eva_avg"] != null) {
        bookListNew![i].book_eva = double.parse(avg[0]["eva_avg"]);
      }
      if (avg[0]["eva_count"] != null) {
        bookListNew![i].book_Number_of_reviews = int.parse(avg[0]["eva_count"]);
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
    bookListNew!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    bookListNew = <BooksData>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
 repList = <Rep>[];
    evaList = <Eva>[];
    getDataBook(0, "");
      getrepname(0, "");
    getevaname(0, "");


    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataBook(i, "");
        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text("إدارة الكتب");

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon = const Icon(Icons.close);
      _appBarTitle = TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          // ignore: avoid_print
          print(text);

          bookListNew!.clear();
          i = 0;
          getDataBook(0, text);
          myProv.add_loading();
        },
      );
    } else {
      _searchIcon = const Icon(Icons.search);
      _appBarTitle = const Text("إدارة الكتب");
    }
    myProv.add_loading();
  }

  bool isFabVisibleAdd = true;
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      backgroundColor: pcWhite,
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
        child: RefreshIndicator(
          onRefresh: () async {
            i = 0;
            bookListNew!.clear();
            getDataBook(0, "");
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
                    itemCount: bookListNew!.length,
                    itemBuilder: (context, index) {
                      final item = bookListNew![index];
                      return Dismissible(
                        key: Key(item.book_id),
                        direction: DismissDirection.startToEnd,
                        child: SingleBookAll(
                          book_index: index,
                          books: bookListNew![index],
                        ),
                        onDismissed: (direction) {
                          bookListNew!.remove(item);
                          // deleteData(
                          //     "book_id", item.book_id, "books/delete_book.php");
                          myProvider.add_loading();
                        },
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
    );
  }
}
