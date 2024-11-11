// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, use_key_in_widget_constructors

import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:footer/footer.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'package:digital_books/pages/book_details/pop_menu.dart';
import 'package:digital_books/pages/books/books_favorite.dart';
import 'package:digital_books/pages/config.dart';

import '../../sqlflite_db.dart';
import '../books/books_data.dart';
import '../books/single_fav.dart';
import '../components/progres.dart';
import '../function.dart';
import '../provider/loading.dart';
import 'pdf_viewer.dart';

List<Rep>? repList;
List<Eva>? evaList;

class Rep {
  String rep_id;
  String rep_note;
  Rep({
    required this.rep_id,
    required this.rep_note,
  });
}

class Eva {
  String eva_id;
  String eva_note;
  String eva_avg;
  Eva({
    required this.eva_id,
    required this.eva_note,
    required this.eva_avg,
  });
}

class BookDetails extends StatefulWidget {
  int? book_index;
  BooksData books;
  BookDetails({
    Key? key,
    this.book_index,
    required this.books,
  }) : super(key: key);
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
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

  //
  int size = 0;
  String strr = "";
  cByte(int bytes, String str) {
    if (bytes < 1024) {
      bytes = bytes;
      str = ' بايت';
    } else if (bytes < 1048576) {
      bytes = (bytes / 1024).floor();
      str = ' كيلوبايت';
    } else if (bytes < 1073741824) {
      bytes = (bytes / 1024).floor();
      str = ' ميغابايت';
    } else {
      bytes = (bytes / 1024).floor();
      str = ' جيغابايت';
    }

    size = bytes;
    strr = str;
  }

  //
//start updateDownload
  updateDownloadNum(context) async {
    Map arr = {
      "book_id": widget.books.book_id,
    };
    bool res = await updateDownload(arr, "books/update_download.php", context);
  }
//end updateDownload

  ///start alertDialog
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Icon(Icons.info, color: pcBlue),
          Text("معلومة",
              style: TextStyle(color: pcBlue, fontWeight: FontWeight.w500)),
        ],
      ),
      content: Text("الكتاب محمل بالفعل"),
      elevation: 10,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(textDirection: TextDirection.rtl, child: alert);
      },
    );
  }

  ///end alertDialog
//favorite

  void getDataBook(int count, String strSearch) async {
    setState(() {});
    List arr = await getData(count, "books/readbook_user.php", strSearch,
        "cat_id=${widget.books.cat_id}&user_id=${G_user_id_val}&");
    for (int i = 0; i < arr.length; i++) {
      bookList!.add(BooksData(
        book_id: arr[i]["book_id"], //
        cat_id: arr[i]["cat_id"],
        fav_id: arr[i]["fav_id"],
        rep_id: arr[i]["rep_id"],
        eva_id: arr[i]["eva_id"],

        book_name: arr[i]["book_name"], //
        book_author_name: arr[i]["book_author_name"],
        book_lang: arr[i]["book_lang"], //
        book_block: arr[i]["book_block"] == "1" ? true : false,
        book_date: arr[i]["book_date"],
        book_summary: arr[i]["book_summary"],
        book_thumbnail: arr[i]["book_thumbnail"],
        book_eva: 4.6,
        book_download: (arr[i]["book_download"]).toString(),
        book_Number_of_reviews: 0,
        book_size: arr[i]["book_size"],
        book_publisher: arr[i]["book_publisher"],
        book_file: arr[i]["book_file"], //
      ));
    }
    setState(() {});
  }

  bool isloadingFav = false;
  saveFavorite(String fav_id, String book_id, int book_index, context,
      LoadingControl load) async {
    if (widget.books.fav_id != null && widget.books.fav_id != "") {
      bool res = await deleteData("fav_id", fav_id, "favorite/delete_fav.php");
      isloadingFav = res;
      if (isloadingFav) {
        bookList![book_index].fav_id = "";
        load.add_loading();
      }
    } else {
      isloadingFav = true;
      load.add_loading();
      Map arr = {"user_id": G_user_id_val, "book_id": book_id};
      Map resArray =
          await SaveDataList(arr, "favorite/insert_fav.php", context, "insert");
      isloadingFav = resArray != null ? true : false;
      if (isloadingFav) {
        bookList![book_index].fav_id = resArray["fav_id"];
        load.add_loading();
      }
    }
  }

  ScrollController? myScroll;
//database
  sqlfliteDb sqlDb = sqlfliteDb();
  var baseStorage;

  Future downloadPdf(String url) async {
    var statusP = await Permission.storage.request();
    if (statusP.isDenied) {
      baseStorage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: baseStorage!.path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  ReceivePort _port = ReceivePort();
  DownloadTaskStatus? status;
  @override
  void initState() {
    // repList = <Rep>[];
    // // evaList = <Eva>[];
    getrepname(0, "");
    getevaname(0, "");
    // getrepname(0, "");
    int bytes = int.parse(widget.books.book_size);
    cByte(bytes, "");
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      String id = data[0];
      status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        print("Download complete");
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
    FlutterDownloader.remove(taskId: id, shouldDeleteContent: true);
  }

  Widget BookImage() {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Colors.blue[100],
          boxShadow: const [
            BoxShadow(
              color: Colors.blue,
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, 8),
            ),
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(180),
          )),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(top: 5, bottom: 0, left: 15, right: 15),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 38,
                    color: Colors.blue,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Expanded(child: Text("")),
                MyPopMenu(books: widget.books, book_index: widget.book_index),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20,

                  child:
                      //////
                      Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.blue[300],
                            ),
                            child: widget.books.book_thumbnail == "" ||
                                    widget.books.book_thumbnail == null
                                ? ImageNetwork(
                                    image: imageBook + "def.png",

                                    width:
                                        (MediaQuery.of(context).size.width / 3),
                                    height:
                                        (MediaQuery.of(context).size.height /
                                            4),
                                    // width: 110,
                                    // height: 140,
                                    onLoading: const CircularProgressIndicator(
                                      color: Colors.indigoAccent,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  )
                                : ImageNetwork(
                                    image:
                                        imageBook + widget.books.book_thumbnail,
                                    // width: 110,
                                    // height: 140,
                                    onLoading: CircularProgressIndicator(
                                      color: Colors.indigoAccent,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),

                                    width:
                                        (MediaQuery.of(context).size.width / 3),
                                    height:
                                        (MediaQuery.of(context).size.height /
                                            4),
                                    // fit: BoxFit.fill,
                                  ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                widget.books.book_name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cairo",
                                    fontSize: 20),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.download,
                                          color: Colors.purple,
                                        ),
                                        Text(
                                          widget.books.book_download.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Cairo",
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          widget.books.book_eva.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Cairo",
                                              fontSize: 20),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(right: 15)),
                                        Text(
                                          "(" +
                                              widget
                                                  .books.book_Number_of_reviews
                                                  .toString() +
                                              "مراجعة)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Cairo",
                                              fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     const Icon(
                                    //       Icons.language,
                                    //       color: Colors.green,
                                    //     ),
                                    //     Text(widget.books.book_lang),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          color: Colors.blueAccent,
                                        ),
                                        Text(
                                          widget.books.book_date,
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 8, 0, 83),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17),
                                        ),
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  //////

                  //  Column(
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.only(
                  //           right: 5, top: 5, left: 5, bottom: 5),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Container(
                  //             padding: const EdgeInsets.all(5.0),
                  //             margin: const EdgeInsets.all(10.0),
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(5.0),
                  //               color: Colors.blue[300],
                  //             ),
                  //             child: widget.books.book_thumbnail == "" ||
                  //                     widget.books.book_thumbnail == null
                  //                 ? ImageNetwork(
                  //                     image: imageBook + "def.png",

                  //                     width:
                  //                         (MediaQuery.of(context).size.width /
                  //                             3),
                  //                     height:
                  //                         (MediaQuery.of(context).size.height /
                  //                             4),
                  //                     // width: 110,
                  //                     // height: 140,
                  //                     onLoading:
                  //                         const CircularProgressIndicator(
                  //                       color: Colors.indigoAccent,
                  //                     ),
                  //                     onError: const Icon(
                  //                       Icons.error,
                  //                       color: Colors.red,
                  //                     ),
                  //                   )
                  //                 : ImageNetwork(
                  //                     image: imageBook +
                  //                         widget.books.book_thumbnail,
                  //                     // width: 110,
                  //                     // height: 140,
                  //                     onLoading: CircularProgressIndicator(
                  //                       color: Colors.indigoAccent,
                  //                     ),
                  //                     onError: const Icon(
                  //                       Icons.error,
                  //                       color: Colors.red,
                  //                     ),

                  //                     width:
                  //                         (MediaQuery.of(context).size.width /
                  //                             3),
                  //                     height:
                  //                         (MediaQuery.of(context).size.height /
                  //                             4),
                  //                     // fit: BoxFit.fill,
                  //                   ),
                  //           ),
                  //           Column(
                  //             // crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 widget.books.book_name,
                  //                 style: const TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontFamily: "Cairo",
                  //                     fontSize: 20),
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   const Padding(
                  //                       padding: EdgeInsets.only(right: 30)),
                  //                   Text(
                  //                     widget.books.book_eva.toString(),
                  //                     style: const TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontFamily: "Cairo",
                  //                         fontSize: 20),
                  //                   ),
                  //                   // Padding(padding: EdgeInsets.all(10)),
                  //                   const Icon(
                  //                     Icons.star,
                  //                     color: Colors.amber,
                  //                   ),
                  //                   const Padding(
                  //                       padding:
                  //                           EdgeInsets.only(left: 5, right: 5)),

                  //                   Text(
                  //                     widget.books.book_Number_of_reviews
                  //                             .toString() +
                  //                         "(مراجعة)",
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontFamily: "Cairo",
                  //                         fontSize: 17),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   const Padding(
                  //                       padding: EdgeInsets.only(right: 30)),
                  //                   Text(
                  //                     widget.books.book_download.toString(),
                  //                     style: const TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontFamily: "Cairo",
                  //                         fontSize: 20),
                  //                   ),
                  //                   const Icon(
                  //                     Icons.download,
                  //                     color: Colors.purple,
                  //                   )

                  //                   // const Text(
                  //                   //   r" $ ",
                  //                   //   style: TextStyle(
                  //                   //       fontWeight: FontWeight.bold,
                  //                   //       fontFamily: "Cairo",
                  //                   //       fontSize: 20,
                  //                   //       color: Colors.green),
                  //                   // ),
                  //                 ],
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   const Padding(
                  //                       padding: EdgeInsets.only(right: 30)),
                  //                   Text(
                  //                     widget.books.book_size.toString(),
                  //                     style: const TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontFamily: "Cairo",
                  //                         fontSize: 20),
                  //                   ),
                  //                   const Text(
                  //                     r" $ ",
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontFamily: "Cairo",
                  //                         fontSize: 20,
                  //                         color: Colors.green),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  //   // final item = bookList![index];
                  // BookDetailsHeader(
                  //     book_index: widget.book_index,
                  //     books: bookList![index],
                  //   )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          //start header
          BookImage(),
//end header
          //start body
          Container(
              //color: Colors.amber,
              height: MediaQuery.of(context).size.height / 1.89,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   alignment: Alignment.topCenter,
                      //   color: Colors.red,
                      //   padding:
                      //       const EdgeInsets.only(right: 5, top: 5, left: 5, bottom: 5),
                      //   child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.books.book_name,
                              style: const TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 180, 1, 159),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  // color: Colors.amber,
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "الناشر: ",
                                          style: TextStyle(
                                              fontFamily: "Cairo",
                                              fontSize: pfontt,
                                              color: Color.fromARGB(
                                                  255, 0, 52, 94),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.books.book_publisher,
                                          style: const TextStyle(
                                              fontFamily: "Cairo",
                                              fontSize: pfontb,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding:
                                        EdgeInsets.only(right: 2, left: 2)),

                                //Padding(padding: EdgeInsets.only(right: 17, left: 17)),
                                const Text(
                                  "لغة الكتاب: ",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: pfontt,
                                      color: Color.fromARGB(255, 0, 52, 94),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.books.book_lang,
                                  style: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: pfontb,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  // color: Colors.amber,
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "المؤلف: ",
                                          style: TextStyle(
                                              fontFamily: "Cairo",
                                              fontSize: pfontt,
                                              color: Color.fromARGB(
                                                  255, 0, 52, 94),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.books.book_author_name,
                                          style: const TextStyle(
                                              fontFamily: "Cairo",
                                              fontSize: pfontb,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Padding(
                                    padding:
                                        EdgeInsets.only(right: 2, left: 2)),

                                //Padding(padding: EdgeInsets.only(right: 17, left: 17)),
                                const Text(
                                  "حجم الكتاب: ",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: pfontt,
                                      color: Color.fromARGB(255, 0, 52, 94),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  size.toString(),
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: pfontb,
                                      color: Color.fromARGB(255, 69, 145, 180),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  strr,
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 69, 145, 180),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "الملخص:",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: pfontt,
                                color: Color.fromARGB(255, 0, 52, 94),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.books.book_summary,
                            style: const TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      // ),
                    ],
                  ),
                ),
              )),
          //end body

          //start footer
          Footer(
            backgroundColor: Colors.white,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue[100],
                    border: Border.all(color: Colors.blue, width: 5),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                List downloadsTest = [];

                                List<Map> response = await sqlDb
                                    .readData("select file from downloads");
                                downloadsTest.addAll(response);

                                // // print((downloadsTest));
                                bool test = false;
                                for (var i = 0; i < downloadsTest.length; i++) {
                                  // print((downloadsTest[i].toString()));
                                  // print((widget.books.book_file.toString()));
                                  if (downloadsTest[i].toString() ==
                                      "{file: ${widget.books.book_file.toString()}}") {
                                    test = true;
                                  }
                                }

                                
                                if (test == true ||
                                    status == DownloadTaskStatus.failed) {
                                  showAlertDialog(context);
                                  print("الكتاب محمل بالفعل");
                                } else {
                                  int response = await sqlDb.insertData(
                                      'INSERT INTO downloads(name, lang, file, nump, size, parasize, dat) VALUES("${widget.books.book_name}", "${widget.books.book_lang}", "${widget.books.book_file}", ${widget.books.book_page_number}, ${size}, "${strr}", "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}")');
                                  print(response);
                                  // if (response > 0) {}

                                  downloadPdf(
                                    "http://www-di.inf.puc-rio.br/~laber/HuffmanCodes.pdf"
                                      // files_path + widget.books.book_file
                                      );
                                  updateDownloadNum(context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.green, width: 3),
                                    borderRadius: BorderRadius.circular(180)),
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      " تحميل",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontFamily: "Cairo",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.download,
                                      color: Colors.green,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfViewPage(
                                      url: files_path + widget.books.book_file,
                                      name: widget.books.book_name,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.orange, width: 3),
                                    borderRadius: BorderRadius.circular(180)),
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      " قراءة",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20,
                                          fontFamily: "Cairo",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.book,
                                      color: Colors.orange,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.purple, width: 3),
                            borderRadius: BorderRadius.circular(180)),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Consumer<LoadingControl>(
                            builder: (context, load, child) {
                          return GestureDetector(
                            child: Icon(
                              (widget.books.fav_id == null ||
                                      widget.books.fav_id == ""
                                  ? Icons.favorite_border
                                  : Icons.favorite),
                              color: (widget.books.fav_id == null ||
                                      widget.books.fav_id == ""
                                  ? Colors.grey
                                  : Colors.purple),
                              size: 35,
                            ),
                            onTap: () async {
                              // await sqlDb.mydeleteDatabase();

                              saveFavorite(
                                  widget.books.fav_id,
                                  widget.books.book_id,
                                  widget.book_index!,
                                  context,
                                  load);
                                 
                              // setState(() {});
                            },
                          );
                        }),

                        //=========================end favorite
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )

          //end footer
        ],
      ),
      // persistentFooterButtons: [],
    );
  }
}
