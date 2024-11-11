import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digital_books/pages/provider/loading.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../sqlflite_db.dart';
import '../book_details/pdf_viewer.dart';
import '../config.dart';
import 'package:flutter/cupertino.dart';

import '../home/home.dart';
import '../home/selected_screen.dart';

class myDownloads extends StatefulWidget {
  const myDownloads({Key? key}) : super(key: key);

  @override
  _myDownloadsState createState() => _myDownloadsState();
}

class _myDownloadsState extends State<myDownloads> {
  bool isLoading = true;
  sqlfliteDb sqlDb = sqlfliteDb();
  List downloads = [];
  Future<List<Map>> readData(text) async {
    if (text != "") {
      
      List<Map> response =
          await sqlDb.readData("select * from downloads where name like '%${text}%'");
      setState(() {});
      downloads.addAll(response);
      isLoading = false;

      if (this.mounted) {
        setState(() {});
      }
      return response;
    } else {
      List<Map> response = await sqlDb.readData("select * from downloads");
      downloads.addAll(response);
      isLoading = false;

      if (this.mounted) {
        setState(() {});
      }
      return response;
    }
  }

  @override
  void initState() {
    readData("");

    super.initState();
  }

  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text("التنزيلات");

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon = const Icon(Icons.close);
      _appBarTitle = TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          downloads.clear();
          readData(text);
          // bookList!.clear();
          // catNIList!.clear();
          // i = 0;
          // getDataBook(0, text);
          // getDataCatNI(0, text);
          myProv.add_loading();
        },
      );
    } else {
      _searchIcon = const Icon(Icons.search);
      _appBarTitle = const Text("التنزيلات");
    }
    myProv.add_loading();
  }

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
        // backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // SliverAppBar(
              //   floating: true,
              //   snap: true,
              //   // backgroundColor: Colors.white,
              //   title: Container(
              //       // color: Colors.white,
              //       child: TextFormField(
              //     decoration: const InputDecoration(
              //       labelText: " ابحث",
              //       //labelStyle: TextStyle(color: Colors.white),
              //       suffixIcon: Padding(
              //         padding: EdgeInsets.only(left: 20.0),
              //         child: Icon(
              //           Icons.search,
              //           color: Colors.blue,
              //         ),
              //       ),
              //       // border: InputBorder.none,
              //     ),
              //   )),
              // ),
            ],
            body: isLoading == true
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: <Widget>[
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: downloads.length,
                          itemBuilder: ((context, i) {
                            return MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PdfViewPageFile(
                                          
                                              url: files_path_in_app +
                                                  "${downloads[i]['file']}",
                                              name: "${downloads[i]['name']}",
                                            )));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: Icon(
                                        Icons.picture_as_pdf,
                                        size: 65,
                                        color: Color.fromARGB(255, 248, 152, 8),
                                      ),
                                      title: Text(
                                        "${downloads[i]['name']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2),
                                            ),
                                            Text(
                                                "${downloads[i]['size']}" +
                                                    "${downloads[i]['parasize']}    ",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 76, 151, 6),
                                                    fontSize: 15)),
                                            Text("${downloads[i]['dat']}",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 11, 170, 19),
                                                    fontSize: 15)),
                                          ]),
                                      trailing: PopupMenuButton(
                                          color: Colors.white,
                                          iconSize: 30,
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    value: 4,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: const <Widget>[
                                                        Text('تفاصيل'),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  16, 2, 2, 2),
                                                          child: Icon(
                                                            Icons.info,
                                                            color: Colors.brown,
                                                            size: 27,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                PopupMenuItem(
                                                    value: 3,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: const <Widget>[
                                                        Text('مشاركة'),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  8, 2, 2, 2),
                                                          child: Icon(
                                                            Icons.share,
                                                            color: Colors.blue,
                                                            size: 27,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                PopupMenuItem(
                                                    onTap: () async {
                                                      int response = await sqlDb
                                                          .deleteData(
                                                              "DELETE FROM downloads WHERE id = ${downloads[i]['id']}");
                                                      if (response > 0) {
                                                        print(downloads[i]
                                                            ['file']);
                                                        final file = io.File(
                                                            "$files_path_in_app/${downloads[i]['file']}");
                                                        file.delete();

                                                        downloads.removeWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                downloads[i]
                                                                    ['id']);
                                                        setState(() {});
                                                      }
                                                    },
                                                    value: 4,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: const <Widget>[
                                                        Text('حذف'),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  16, 2, 2, 2),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 27,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ])),
                                  Divider(
                                    color: Colors.grey[500],
                                  ),
                                ],
                              ),
                            );
                          })),
                    ],
                  ),
          ),
        ));
  }
}
