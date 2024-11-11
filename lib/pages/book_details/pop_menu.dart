import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';

import 'package:digital_books/pages/book_details/rating.dart';
import 'package:digital_books/pages/books/my_Download.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/provider/loading.dart';

import '../books/books_data.dart';
import '../components/progres.dart';
import '../function.dart';
import 'book_details.dart';

class MyPopMenu extends StatefulWidget {
  int? book_index;
  BooksData books;
  MyPopMenu({
    Key? key,
    this.book_index,
    required this.books,
  }) : super(key: key);

  @override
  _MyPopMenuState createState() => _MyPopMenuState();
}

class _MyPopMenuState extends State<MyPopMenu> {
  //
  updateEva(context) async {
    Map arr = {
      "book_id": widget.books.book_id,
      "eva_avg": rating,
    };
    bool res = await updateDownload(arr, "books/update_eva.php", context);
  }

//
  updateEvaEdit(context) async {
    Map arr = {
      "book_id": widget.books.book_id,
      "eva_avg": rating,
    };
    bool res = await updateDownload(arr, "books/update_eva.php", context);
  }

//
  TextEditingController txteva_note = TextEditingController();
  TextEditingController txtrep_note = TextEditingController();

  var eva_note;
  var eva_avg;

  var eva_id_list = evaList!.map((e) {
    return e.eva_id;
  }).toList();

  var eva_note_list = evaList!.map((e) {
    return e.eva_note;
  }).toList();

  var eva_avg_list = evaList!.map((e) {
    return e.eva_avg;
  }).toList();

  void getNIEva() {
    for (int i = 0; i < evaList!.length; i++) {
      if (eva_id_list[i] == widget.books.eva_id) {
        // print(rep_id_list[i]);
        eva_note = eva_note_list[i];
        eva_avg = eva_avg_list[i];
      }
    }
  }

  bool isloadingEva = false;

  saveEva(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    load.add_loading();
    if (txteva_note.text.isNotEmpty) {
      isloadingEva = true;
      load.add_loading();
      Map arr = {
        "user_id": G_user_id_val,
        "book_id": widget.books.book_id,
        "eva_note": txteva_note.text,
        "eva_avg": rating.toString(),
      };
      Map res = await SaveDataListRepEva(
          arr,
          "evas/insert_eva.php",
          () => BookDetails(books: widget.books, book_index: widget.book_index),
          context,
          "insert");

      isloadingEva = res != null ? true : false;
      if (isloadingEva) {
        bookList![widget.book_index!].eva_id = res["eva_id"];
        load.add_loading();
      }

      load.add_loading();
    } else {
      Toast.show("لا يمكن أن يكون الحقل فارغا", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

//edit
  editEva(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    load.add_loading();
    if (txteva_note.text.isNotEmpty) {
      isloadingEva = true;
      load.add_loading();
      Map arr = {
        "eva_id": widget.books.eva_id,
        "eva_note": txteva_note.text,
        "eva_avg": rating.toString(),
      };
      Map res = await SaveDataListRepEva(
          arr,
          "evas/update_eva.php",
          () => BookDetails(books: widget.books, book_index: widget.book_index),
          context,
          "insert");

      isloadingEva = res != null ? true : false;
      if (isloadingEva) {
        bookList![widget.book_index!].eva_id = res["eva_id"];
        load.add_loading();
      }

      load.add_loading();
    } else {
      Toast.show("لا يمكن أن يكون الحقل فارغا", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

//
  String txtbtneva = "";
  double rating = 0.0;
  _displayDialogEva(BuildContext context, LoadingControl load) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.star, color: pcBlue),
                  Text("أدخل تقيمك للكتاب",
                      style: TextStyle(
                          color: pcBlue, fontWeight: FontWeight.w500)),
                ],
              ),
              content: Container(
                height: 150,
                // color: Colors.amber,
                child: Column(
                  children: [
                    SmoothStarRating(
                        allowHalfRating: true,
                        halfFilledIconData: Icons.star_half,
                        onRated: (v) {
                          this.rating = v;
                          setState(() {});
                          print(rating);
                        },
                        starCount: 5,
                        rating: rating,
                        size: 60.0,
                        filledIconData: Icons.star,
                        color: Colors.orange,
                        borderColor: Colors.grey,
                        spacing: 0.0),
                    TextField(
                      controller: txteva_note,
                      decoration: InputDecoration(hintText: "أدخل النص هنا"),
                    ),
                  ],
                ),
              ),
              actions: [
                widget.books.eva_id != null
                    ? MaterialButton(
                        child: Container(
                            child: Text("حذف التقييم",
                                style: TextStyle(
                                  color: pcBlue,
                                  fontSize: 20,
                                ))),
                        onPressed: () {
                          deleteData("eva_id", widget.books.eva_id,
                              "evas/delete_eva.php");
        bookList![widget.book_index!].eva_id = "";

                        //  updateEva(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookDetails(
                                  books: widget.books,
                                  book_index: widget.book_index)

                                  ));
                          setState(() {});
                        },
                      )
                    : Container(),
                MaterialButton(
                  child: Container(
                      child: Text(txtbtneva,
                          style: TextStyle(
                            color: pcBlue,
                            fontSize: 20,
                          ))),
                  onPressed: () {
                    // saveEva(context, load);
                    if (widget.books.eva_id != null &&
                        widget.books.eva_id != "") {
                      editEva(context, load);
                      if (txteva_note.text.isNotEmpty) {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookDetails(
                                  books: widget.books,
                                  book_index: widget.book_index)

                                  ));
                      }
                    } else {
                      saveEva(context, load);
                      txtbtn = "تعديل التقييم";
                      // updateEva(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => BookDetails(
                      //             books: widget.books,
                      //             book_index: widget.book_index)

                      //             ));
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  ///
//start insert report

  var rep_note;

  var rep_id_list = repList!.map((e) {
    return e.rep_id;
  }).toList();

  var rep_note_list = repList!.map((e) {
    return e.rep_note;
  }).toList();
  void getNI() {
    for (int i = 0; i < repList!.length; i++) {
      if (rep_id_list[i] == widget.books.rep_id) {
        // print(rep_id_list[i]);
        rep_note = rep_note_list[i];
      }
    }
  }

  bool isloading = false;

  saveRep(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    load.add_loading();
    if (txtrep_note.text.isNotEmpty) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "user_id": G_user_id_val,
        "book_id": widget.books.book_id,
        "rep_note": txtrep_note.text,
      };
      Map res = await SaveDataListRepEva(
          arr,
          "reports/insert_rep.php",
          () => BookDetails(books: widget.books, book_index: widget.book_index),
          context,
          "insert");

      isloading = res != null ? true : false;
      if (isloading) {
        bookList![widget.book_index!].rep_id = res["rep_id"];
        load.add_loading();
      }

      load.add_loading();
    } else {
      Toast.show("لا يمكن أن يكون الحقل فارغا", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

//edit
  editRep(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    load.add_loading();
    if (txtrep_note.text.isNotEmpty) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "rep_id": widget.books.rep_id,
        "rep_note": txtrep_note.text,
      };
      Map res = await SaveDataListRepEva(
          arr,
          "reports/update_rep.php",
          () => BookDetails(books: widget.books, book_index: widget.book_index),
          context,
          "insert");

      isloading = res != null ? true : false;
      if (isloading) {
        bookList![widget.book_index!].rep_id = res["rep_id"];
        load.add_loading();
      }

      load.add_loading();
    } else {
      Toast.show("لا يمكن أن يكون الحقل فارغا", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

//
  String txtbtn = "";

  _displayDialog(BuildContext context, LoadingControl load) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.info, color: pcBlue),
                  Text("أكتب ملاحظتك عن الكتاب",
                      style: TextStyle(
                          color: pcBlue, fontWeight: FontWeight.w500)),
                ],
              ),
              content: TextField(
                controller: txtrep_note,
                decoration: InputDecoration(hintText: "أدخل النص هنا"),
              ),
              actions: [
                widget.books.rep_id != null
                    ? MaterialButton(
                        child: Container(
                            child: Text("حذف الإبلاغ",
                                style: TextStyle(
                                  color: pcBlue,
                                  fontSize: 20,
                                ))),
                        onPressed: () {
                          // repList!.removeAt(widget.book_index!);
                          deleteData("rep_id", widget.books.rep_id,
                              "reports/delete_rep.php");
                               bookList![widget.book_index!].rep_id = "";
                          updateEva(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookDetails(
                                  books: widget.books,
                                  book_index: widget.book_index)

                                  ));
                          // setState(() {});
                        },
                      )
                    : Container(),
                MaterialButton(
                  child: Container(
                      child: Text(txtbtn,
                          style: TextStyle(
                            color: pcBlue,
                            fontSize: 20,
                          ))),
                  onPressed: () {
                    if (widget.books.rep_id != null &&
                        widget.books.rep_id != "") {
                      editRep(context, load);
                      if (txtrep_note.text.isNotEmpty) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      saveRep(context, load);
                      txtbtn = "تعديل الإبلاغ";
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    print(eva_note);
    print(eva_avg);
    print(eva_note_list);

    // ignore: todo
    // TODO: implement initState
    super.initState();

    if (widget.books.rep_id != null && widget.books.rep_id != "") {
      txtbtn = "تعديل الإبلاغ";
      getNI();
      txtrep_note.text = rep_note;
    } else {
      txtbtn = "إبلاغ";
    }
    if (widget.books.eva_id != null && widget.books.eva_id != "") {
      txtbtneva = "تعديل التقييم";
      getNIEva();
      txteva_note.text = eva_note;
      rating = double.parse(eva_avg);
    } else {
      txtbtneva = "تقييم";
      
    }
    
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();

    // txtrep_note.dispose();
  }

//end insert report
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingControl>(builder: (context, load, child) {
      return PopupMenuButton(
          onSelected: ((value) {
            if (value == 4) {
              _displayDialog(context, load);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddReport(
              //             books: widget.books, book_index: widget.book_index)));
            }
            if (value == 2) {
              _displayDialogEva(context, load);
            }
          }),
          color: Colors.white,
          iconSize: 30,
          itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const <Widget>[
                        Text('التقييمات'),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 2, 2, 2),
                          child: Icon(
                            Icons.star,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )),
                PopupMenuItem(
                    // onTap: () {},
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const <Widget>[
                        Text('تقييم'),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 2, 2, 2),
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    )),
                // PopupMenuItem(
                //     value: 3,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: const <Widget>[
                //         Text('مشاركة'),
                //         Padding(
                //           padding: EdgeInsets.fromLTRB(8, 2, 2, 2),
                //           child: Icon(
                //             Icons.share,
                //             color: Colors.blue,
                //           ),
                //         ),
                //       ],
                //     )),
                PopupMenuItem(
                    value: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const <Widget>[
                        Text('إبلاغ'),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 2, 2, 2),
                          child: Icon(
                            Icons.report,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    )),

                // PopupMenuItem(
                // value: 4,
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: const <Widget>[
                //     Text('تفاصيل'),
                //     Padding(
                //       padding: EdgeInsets.fromLTRB(16, 2, 2, 2),
                //       child: Icon(Icons.info),
                //     ),
                //   ],
                // )),
              ]);
    });
  }
}
