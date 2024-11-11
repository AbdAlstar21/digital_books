//changed//
import 'package:digital_books/pages/book_details/book_details.dart';
import 'package:digital_books/pages/books/single_fav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:digital_books/pages/books/books_data.dart';
import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/function.dart';
import 'package:digital_books/pages/provider/loading.dart';
import '../function.dart';
import '../home/home.dart';
import '../home/selected_screen.dart';

List<CatNI>? catNIList;

class CatNI {
  String cat_id;
  String cat_name;
  CatNI({
    required this.cat_id,
    required this.cat_name,
  });
}

class MyFavorite extends StatefulWidget {
  final String? cat_id;
  final String? cat_name;

  const MyFavorite({
    Key? key,
    this.cat_id,
    this.cat_name,
  }) : super(key: key);
  @override
  _MyFavoriteState createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {
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

  void getDataCatNI(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "categories/readcat.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      catNIList!.add(CatNI(
        cat_id: arr[i]["cat_id"],
        cat_name: arr[i]["cat_name"],
      ));
    }
    loadingList = false;
    setState(() {});
  }

  void getDataFav(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "favorite/readfav.php", strSearch,
        "cat_id=${widget.cat_id}&user_id=${G_user_id_val}&");
    for (int i = 0; i < arr.length; i++) {
      bookListFav!.add(BooksData(
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
          "book_id=${bookListFav![i].book_id}&");

      if (avg[0]["eva_avg"] != null) {
        bookListFav![i].book_eva = double.parse(avg[0]["eva_avg"]);
      }
      if (avg[0]["eva_count"] != null) {
        bookListFav![i].book_Number_of_reviews = int.parse(avg[0]["eva_count"]);
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
    bookListFav!.clear();
    bookList!.clear();
    catNIList!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    bookListFav = <BooksData>[];
    // bookList = <BooksData>[];
    // catNIList = <CatNI>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    repList = <Rep>[];
    evaList = <Eva>[];
    getrepname(0, "");
    getevaname(0, "");
    getDataFav(0, "");
    // getDataCatNI(0, "");
    
    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataFav(i, "");
        getDataCatNI(i, "");
        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text("المفضلة");

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

          bookListFav!.clear();

          catNIList!.clear();
          i = 0;
          getDataFav(0, text);
          getDataCatNI(0, text);
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
      appBar: AppBar(
        // backgroundColor: pcBlue,
        title: _appBarTitle,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectedScreen()));
            }),
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                _searchPressed(myProvider);
              },
              child: _searchIcon,
            ),
          )
        ],
      ),
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
            bookListFav!.clear();
            catNIList!.clear();
            getDataFav(0, "");
            getDataCatNI(0, "");
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
                    itemCount: bookListFav!.length,
                    itemBuilder: (context, index) {
                      final item = bookListFav![index];
                      return Dismissible(
                        key: Key(item.book_id),
                        direction: DismissDirection.startToEnd,
                        child: SingleFavorite(
                          book_index: index,
                          books: bookListFav![index],
                        ),
                        onDismissed: (direction) {
                          bookListFav!.remove(item);
                          deleteData(
                              "book_id", item.book_id, "books/delete_book.php");
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
      // bottomNavigationBar: Visibility(
      //   visible: isFabVisibleAdd,
      //   child: SizedBox(
      //     height: 50.0,
      //     child: Column(
      //       children: <Widget>[
      //         Container(
      //           alignment: Alignment.center,
      //           child: GestureDetector(
      //             onTap: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) => const AddBooks()));
      //             },
      //             child: const Text(
      //               "اضافة كتاب جديد",
      //               style: TextStyle(color: Colors.white, fontSize: 20),
      //             ),
      //           ),
      //           height: 40.0,
      //           decoration: BoxDecoration(
      //               color: Colors.blue,
      //               borderRadius: BorderRadius.circular(40)),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
