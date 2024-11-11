// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:io';
import 'package:digital_books/pages/my_library/my_library.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_network/image_network.dart';
import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/provider/loading.dart';
import 'package:digital_books/pages/books/books_data.dart';
import 'package:flutter/material.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';

import 'books.dart';
import 'package:digital_books/pages/books/books.dart';

class EditBooks extends StatefulWidget {
  int book_index;
  BooksData books;

  EditBooks({Key? key, required this.book_index, required this.books})
      : super(key: key);
  @override
  _EditBooksState createState() => _EditBooksState();
}

class _EditBooksState extends State<EditBooks> {
  String? initialValue;
  String? initialValue_cat;
  String? initialValue_cat_id;

  String selected = "اختر لغة الكتاب";
  String selected_cat = "اختر قسم الكتاب";
  var itemList = ["العربية", "الإنجليزية", "التركية", "الفرنسية", "غير ذلك"];

  var cat_id_list = catNIList!.map((e) {
    return e.cat_id;
  }).toList();
  var cat_id;

  var cat_nameList = catNIList!.map((e) {
    return e.cat_name;
  });

  var cat_name_list = catNIList!.map((e) {
    return e.cat_name;
  }).toList();
  void getNI() {
    for (int i = 0; i < catNIList!.length; i++) {
      if (cat_name_list[i] == initialValue_cat) {
        cat_id = cat_id_list[i];
      }
    }
  }

  bool isloading = false;
  bool checkActive = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtbook_name = TextEditingController();
  TextEditingController txtbook_author_name = TextEditingController();
  TextEditingController txtbook_lang = TextEditingController();
  TextEditingController txtbook_summary = TextEditingController();

  updateBook(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (txtbook_name.text.isNotEmpty &&
            initialValue != null &&
            initialValue != "غير ذلك" &&
            txtbook_author_name.text.isNotEmpty &&
            myvalid ||
        txtbook_name.text.isNotEmpty && txtbook_lang.text.isNotEmpty) {
      getNI();
      isloading = true;
      load.add_loading();
      Map arr = {
        "book_id": widget.books.book_id,
        "cat_id": cat_id,
        "book_name": txtbook_name.text,
        "book_lang":
            initialValue != "غير ذلك" ? initialValue : txtbook_lang.text,
        "book_author_name": txtbook_author_name.text,
        "book_block": checkActive ? "1" : "0",
        "book_summary": txtbook_summary.text,
        // "book_size": fileSize.toString(),
      };
      bool res = await uploadImageWithData(_image, arr, "books/update_book.php",
          context, () => Books(), "update");
      bookList![widget.book_index].book_name = txtbook_name.text;
      bookList![widget.book_index].book_lang = txtbook_lang.text;

      bookList![widget.book_index].book_lang = initialValue!;
      bookList![widget.book_index].book_author_name = txtbook_author_name.text;
      bookList![widget.book_index].book_summary = txtbook_summary.text;
      bookList![widget.book_index].cat_id = cat_id;

      // bookList![widget.book_index].book_block = checkActive;

      isloading = res;
      load.add_loading();
    } else {
      Toast.show("Please fill data", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    txtbook_name.dispose();
    txtbook_author_name.dispose();
    txtbook_lang.dispose();
    txtbook_summary.dispose();
  }

  String imageEdit = "";
  // String fileEdit = "";
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    // checkActive = widget.books.book_block;

    txtbook_name.text = widget.books.book_name;
    txtbook_summary.text = widget.books.book_summary;
    txtbook_author_name.text = widget.books.book_author_name;
    initialValue = widget.books.book_lang;
    // initialValue_cat = widget.books.cat_id;
    for (int i = 0; i < catNIList!.length; i++) {
      if (cat_id_list[i] == widget.books.cat_id) {
        initialValue_cat = cat_name_list[i];
      }
    }
    bool test = false;
    for (int i = 0; i < itemList.length; i++) {
      if (itemList[i] == initialValue) {
        test = true;
      }
    }
    
    if (test == false) {
      initialValue = "غير ذلك";
      txtbook_lang.text = widget.books.book_lang;
    }

    imageEdit = widget.books.book_thumbnail == ""
        ? ""
        : images_path + "books/" + widget.books.book_thumbnail;
    // fileEdit = widget.books.book_file == ""
    //     ? ""
    //     : files_path_in_app + widget.books.book_file;
  }

  File? _image;
  final picker = ImagePicker();
  Future getImageGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Future getImageCamera() async {
  //   var image = await picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (image != null) {
  //       _image = File(image.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  void showSheetGallery(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("معرض الصور"),
                onTap: () {
                  getImageGallery();
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.camera),
              //   title: const Text("كاميرا"),
              //   onTap: () {
              //     getImageCamera();
              //   },
              // ),
            ],
          );
        });
  }

  var fileUrl;
  var fileSize;
  Future selectFile() async {
    getNI();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
        //,'doc' , 'docx', 'ppt', 'pptx'
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      setState(() {
        fileUrl = file.path;
        fileSize = file.size;
      });
      print(fileUrl);
      print(fileSize);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pcWhite,
        appBar: AppBar(
          // backgroundColor: pcBlue,
          title: const Text("تعديل بيانات كتاب"),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Consumer<LoadingControl>(builder: (context, load, child) {
                  return Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: txtbook_name,
                              decoration: const InputDecoration(
                                  hintText: "اسم الكتاب",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الاسم بشكل صحيح';
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: DropdownButton(
                              hint: Text(selected,
                                  style: TextStyle(fontSize: 18)),
                              isExpanded: true,

                              //iconEnabledColor: Colors.white,
                              // style: TextStyle(color: Colors.black, fontSize: 16),
                              // dropdownColor: Colors.green,
                              // focusColor: Colors.black,
                              value: initialValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: itemList.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selected = "";
                                  initialValue = newValue!;
                                });
                              },
                            ),
                          ),
                          initialValue == "غير ذلك"
                              ? Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  decoration: BoxDecoration(
                                    color: pcGrey,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: TextFormField(
                                    controller: txtbook_lang,
                                    decoration: const InputDecoration(
                                        hintText: "ادخل لغة الكتاب",
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال اللغة بشكل صحيح';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              : Container(),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: DropdownButton(
                              hint: Text(selected_cat,
                                  style: TextStyle(fontSize: 18)),
                              isExpanded: true,

                              //iconEnabledColor: Colors.white,
                              // style: TextStyle(color: Colors.black, fontSize: 16),
                              // dropdownColor: Colors.green,
                              // focusColor: Colors.black,
                              value: initialValue_cat,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: cat_nameList.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selected_cat = "";
                                  initialValue_cat = newValue!;
                                });
                              },
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: txtbook_author_name,
                              decoration: const InputDecoration(
                                  hintText: "اسم المؤلف",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الاسم بشكل صحيح';
                                }

                                return null;
                              },
                            ),
                          ),

                          // Container(
                          //   margin: const EdgeInsets.only(bottom: 10.0),
                          //   padding:
                          //       const EdgeInsets.only(left: 20.0, right: 20.0),
                          //   child: IconButton(
                          //       icon: Icon(
                          //         Icons.image,
                          //         size: 60.0,
                          //         color: Colors.orange[400],
                          //       ),
                          //       onPressed: () {
                          //         showSheetGallery(context);
                          //       }),
                          // ),
                          // Container(
                          //   padding: const EdgeInsets.all(15.0),
                          //   child: _image == null
                          //       ? (imageEdit == ""
                          //           ? const Text("الصورة غير محددة")
                          //           : ImageNetwork(
                          //               image: imageEdit,
                          //               height: 150,
                          //               width: 150,
                          //               onLoading: CircularProgressIndicator(
                          //                 color: Colors.indigoAccent,
                          //               ),
                          //               onError: const Icon(
                          //                 Icons.error,
                          //                 color: Colors.red,
                          //               ),
                          //             ))
                          //       : Image.file(
                          //           _image!,
                          //           width: 150.0,
                          //           height: 150.0,
                          //           fit: BoxFit.cover,
                          //         ),
                          // ),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                showSheetGallery(context);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _image == null
                                        ? (imageEdit == ""
                                            ? Text("الصورة غير محددة")
                                            : ImageNetwork(
                                                image: imageEdit,
                                                height: 150,
                                                width: 150,
                                                onLoading:
                                                    CircularProgressIndicator(
                                                  color: Colors.indigoAccent,
                                                ),
                                                onError: const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              ))
                                        : Image.file(
                                            _image!,
                                            width: 150.0,
                                            height: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  _image == null && imageEdit == ""
                                      ? Icon(
                                          Icons.image,
                                          size: 35.0,
                                          color: Colors.red[400],
                                        )
                                      : Icon(
                                          Icons.image,
                                          size: 35.0,
                                          color: Colors.orange[400],
                                        ),
                                ],
                              ),
                            ),
                          ),

                          // Container(
                          //   margin: const EdgeInsets.all(10.0),
                          //   padding:
                          //       const EdgeInsets.only(left: 20.0, right: 20.0),
                          //   decoration: BoxDecoration(
                          //     color: pcGrey,
                          //     borderRadius: BorderRadius.circular(20.0),
                          //   ),
                          //   child: MaterialButton(
                          //     onPressed: () {
                          //       selectFile();
                          //     },
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //             child: fileUrl == null
                          //                 ? (fileEdit == ""
                          //                     ? Text("الكتاب غير محمل")
                          //                     : Text(fileEdit))
                          //                 : Text(fileUrl)),
                          //         fileUrl == null && fileEdit == ""
                          //             ? Icon(
                          //                 Icons.upload_file,
                          //                 size: 35.0,
                          //                 color: Colors.red,
                          //               )
                          //             : Icon(
                          //                 Icons.upload_file,
                          //                 size: 35.0,
                          //                 color: Colors.green,
                          //               )
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          // CheckboxListTile(
                          //   title: const Text('free'),
                          //   value: checkActive,
                          //   onChanged: (newvalue) => setState(() => {
                          //         checkActive = newvalue!,
                          //         // if (value == true)
                          //         //   {
                          //         //     visible_enable = true,
                          //         //     visible_text_price = false
                          //         //   }
                          //         // else
                          //         //   {
                          //         //     visible_enable = false,
                          //         //     visible_text_price = true
                          //         //   }
                          //       }),
                          // ),

                          Container(
                            height: MediaQuery.of(context).size.width / 2.7,
                            margin: const EdgeInsets.all(15.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: txtbook_summary,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  hintText: 'ملخص الكتاب',
                                  border: InputBorder.none),
                            ),
                          ),

                          isloading
                              ? circularProgress()
                              : MaterialButton(
                                  onPressed: () {
                                    updateBook(context, load);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "حفظ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30.0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        bottom: 10.0, top: 10.0),
                                    padding: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                  )),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
