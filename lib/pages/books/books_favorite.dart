// //changed//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:provider/provider.dart';
// import 'package:digital_books/pages/books/books_data.dart';
// import 'package:digital_books/pages/components/progres.dart';
// import 'package:digital_books/pages/config.dart';
// import 'package:digital_books/pages/function.dart';
// import 'package:digital_books/pages/provider/loading.dart';

// import '../function.dart';
// import 'add_book.dart';
// import 'single_book.dart';

// List<CatNI>? catNIList;

// class CatNI {
//   String cat_id;
//   String cat_name;
//   CatNI({
//     required this.cat_id,
//     required this.cat_name,
//   });
// }

// class Books extends StatefulWidget {
//   @override
//   _BooksState createState() => _BooksState();
// }

// class _BooksState extends State<Books> {
//   ScrollController? myScroll;
//   GlobalKey<RefreshIndicatorState>? refreshKey;
//   int i = 0;
//   bool loadingList = false;

//   // void getDataCatNI(int count, String strSearch) async {
//   //   loadingList = true;
//   //   setState(() {});
//   //   List arr = await getData(count, "categories/readcat.php", strSearch, "");
//   //   for (int i = 0; i < arr.length; i++) {
//   //     catNIList!.add(CatNI(
//   //       cat_id: arr[i]["cat_id"],
//   //       cat_name: arr[i]["cat_name"],
//   //     ));
//   //   }
//   //   loadingList = false;
//   //   setState(() {});
//   // }

//   void getDataBook(int count, String strSearch) async {
//     loadingList = true;
//     setState(() {});
//     List arr = await getData(count, "favorite/readfav.php", strSearch, "user_id=${G_user_id_val}&");
//     for (int i = 0; i < arr.length; i++) {
//       bookListFav!.add(BooksData(
//         book_id: arr[i]["book_id"], //
//         cat_id: arr[i]["cat_id"],
//         fav_id: arr[i]["fav_id"],
//         book_name: arr[i]["book_name"], //
//         book_author_name: arr[i]["book_author_name"],
//         book_lang: arr[i]["book_lang"], //
//         book_block: arr[i]["book_block"] == "1" ? true : false,
//         book_date: arr[i]["book_date"],
//         book_summary: arr[i]["book_summary"],
//         book_thumbnail: arr[i]["book_thumbnail"],
//         book_eva: 4.6,
//         book_download: 45,
//         book_Number_of_reviews: 12,
//         book_size: 20, //
//         book_publisher: "عبد الستار أبو عبيدة",
//         book_file: arr[i]["book_file"], //
//       ));
//     }
//     loadingList = false;
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     // ignore: todo
//     // TODO: implement dispose
//     super.dispose();
//     myScroll!.dispose();
//     bookListFav!.clear();
//     catNIList!.clear();
//   }

//   @override
//   void initState() {
//     // ignore: todo
//     // TODO: implement initState
//     super.initState();
//     bookListFav = <BooksData>[];
//     catNIList = <CatNI>[];
//     myScroll = ScrollController();
//     refreshKey = GlobalKey<RefreshIndicatorState>();
//     getDataBook(0, "");
//     // getDataCatNI(0, "");

//     myScroll?.addListener(() {
//       if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
//         i += 10;
//         getDataBook(i, "");
//         // getDataCatNI(i, "");
//         // ignore: avoid_print
//         print("scroll");
//       }
//     });
//   }

//   Icon _searchIcon = const Icon(Icons.search);
//   Widget _appBarTitle = const Text("كتبي");

//   void _searchPressed(LoadingControl myProv) {
//     if (_searchIcon.icon == Icons.search) {
//       _searchIcon = const Icon(Icons.close);
//       _appBarTitle = TextField(
//         style: const TextStyle(color: Colors.white),
//         decoration: const InputDecoration(
//             prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
//         onChanged: (text) {
//           // ignore: avoid_print
//           print(text);

//           bookListFav!.clear();
//           catNIList!.clear();
//           i = 0;
//           getDataBook(0, text);
//           // getDataCatNI(0, text);
//           myProv.add_loading();
//         },
//       );
//     } else {
//       _searchIcon = const Icon(Icons.search);
//       _appBarTitle = const Text("إدارة الكتب");
//     }
//     myProv.add_loading();
//   }

//   bool isFabVisibleAdd = true;
//   @override
//   Widget build(BuildContext context) {
//     var myProvider = Provider.of<LoadingControl>(context);
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//       floatingActionButton: Visibility(
//         visible: isFabVisibleAdd,
//         child: FloatingActionButton(
//             onPressed: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => AddBooks()));
//             },
//             backgroundColor: pcBlue,
//             child: const Icon(
//               Icons.add,
//               color: Color.fromARGB(255, 231, 219, 182),
//               size: 30,
//             )),
//       ),
//       appBar: AppBar(
//         // backgroundColor: pcBlue,
//         title: _appBarTitle,
//         centerTitle: true,
//         actions: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             child: GestureDetector(
//               onTap: () {
//                 _searchPressed(myProvider);
//               },
//               child: _searchIcon,
//             ),
//           )
//         ],
//       ),
//       backgroundColor: pcWhite,
//       body: NotificationListener<UserScrollNotification>(
//         onNotification: (notification) {
//           if (notification.direction == ScrollDirection.forward) {
//             setState(() {
//               isFabVisibleAdd = true;
//             });
//           } else if (notification.direction == ScrollDirection.reverse) {
//             setState(() {
//               isFabVisibleAdd = false;
//             });
//           }
//           return true;
//         },
//         child: RefreshIndicator(
//           onRefresh: () async {
//             i = 0;
//             bookListFav!.clear();
//             catNIList!.clear();
//             getDataBook(0, "");
//             // getDataCatNI(0, "");
//           },
//           key: refreshKey,
//           child: Directionality(
//             textDirection: TextDirection.rtl,
//             child: Stack(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 0),
//                   child: ListView.builder(
//                     controller: myScroll,
//                     itemCount: bookListFav!.length,
//                     itemBuilder: (context, index) {
//                       final item = bookListFav![index];
//                       return Dismissible(
//                         key: Key(item.book_id),
//                         direction: DismissDirection.startToEnd,
//                         child: SingleBook(
//                           book_index: index,
//                           books: bookListFav![index],
//                         ),
//                         onDismissed: (direction) {
//                           bookListFav!.remove(item);
//                           deleteData(
//                               "book_id", item.book_id, "books/delete_book.php");
//                           myProvider.add_loading();
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned(
//                     child: loadingList ? circularProgress() : const Text(""),
//                     bottom: 0,
//                     left: MediaQuery.of(context).size.width / 2)
//               ],
//             ),
//           ),
//         ),
//       ),
//       // bottomNavigationBar: Visibility(
//       //   visible: isFabVisibleAdd,
//       //   child: SizedBox(
//       //     height: 50.0,
//       //     child: Column(
//       //       children: <Widget>[
//       //         Container(
//       //           alignment: Alignment.center,
//       //           child: GestureDetector(
//       //             onTap: () {
//       //               Navigator.push(context,
//       //                   MaterialPageRoute(builder: (context) => const AddBooks()));
//       //             },
//       //             child: const Text(
//       //               "اضافة كتاب جديد",
//       //               style: TextStyle(color: Colors.white, fontSize: 20),
//       //             ),
//       //           ),
//       //           height: 40.0,
//       //           decoration: BoxDecoration(
//       //               color: Colors.blue,
//       //               borderRadius: BorderRadius.circular(40)),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
