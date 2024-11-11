// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:digital_books/pages/books/books.dart';
import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/provider/loading.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';
import '../function.dart';
import '../my_library/my_library.dart';
import 'books_cat.dart';

class AddBooks extends StatefulWidget {
  AddBooks({
    Key? key,
  }) : super(key: key);

  @override
  _AddBooksState createState() => _AddBooksState();
}

// ignore: duplicate_ignore
class _AddBooksState extends State<AddBooks> {
  String? initialValue_lang;
  String? initialValue_cat;

  String selected_lang = "اختر لغة الكتاب";
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

  // ignore: non_constant_identifier_names
  TextEditingController txtbook_name = TextEditingController();
  TextEditingController txtbook_author_name = TextEditingController();
  TextEditingController txtbook_lang = TextEditingController();
  TextEditingController txtbook_summary = TextEditingController();
  // saveMybook(String book_id, context) async {
  //   Map arr = {"user_id": G_user_id_val, "book_id": book_id};
  //   Map resArray =
  //       await SaveDataList(arr, "mybooks/insert_.php", context, "insert");
  // }

  saveBook(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("المعلومات غير صحيحة", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (txtbook_name.text.isNotEmpty &&
            initialValue_lang != null &&
            initialValue_lang != "غير ذلك" &&
            txtbook_author_name.text.isNotEmpty &&
            fileUrl != null &&
            fileUrl != "" &&
            myvalid ||
        txtbook_name.text.isNotEmpty && txtbook_lang.text.isNotEmpty) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "cat_id": cat_id,
        "book_name": txtbook_name.text,
        "book_lang": initialValue_lang == "غير ذلك"
            ? txtbook_lang.text
            : initialValue_lang,
        "book_author_name": txtbook_author_name.text,
        "book_block": checkActive ? "1" : "0",
        "book_summary": txtbook_summary.text,
        "book_token": token,
        "book_publisher": G_user_name_val,
        "book_size":fileSize.toString(),
      };

      bool res = await uploadFileWithData(fileUrl, _image, arr,
          "books/insert_book.php", context, () => MyLibrary(), "insert");
      isloading = res;
      load.add_loading();
    } else {
      Toast.show('المعلومات غير صحيحة', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getNI();
    setState(() {
      
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pcWhite,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: pcBlue,
        elevation: 0.0,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'إضافة كتاب جديد',
            style: TextStyle(
              fontSize: 30, fontFamily: "Cairo",
              // color: Colors.tealAccent
            ),
          ),
        ),
        // centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     size: 30,
        //     color: Colors.tealAccent,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            Consumer<LoadingControl>(builder: (context, load, child) {
              return Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        controller: txtbook_name,
                        decoration: const InputDecoration(
                            hintText: "اسم الكتاب", border: InputBorder.none),
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton(
                        hint:
                            Text(selected_lang, style: TextStyle(fontSize: 18)),
                        isExpanded: true,

                        //iconEnabledColor: Colors.white,
                        // style: TextStyle(color: Colors.black, fontSize: 16),
                        // dropdownColor: Colors.green,
                        // focusColor: Colors.black,
                        value: initialValue_lang,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: itemList.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selected_lang = "";
                            initialValue_lang = newValue!;
                          });
                        },
                      ),
                    ),
                    initialValue_lang == "غير ذلك"
                        ? Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
//////////////////////////begin

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton(
                        hint:
                            Text(selected_cat, style: TextStyle(fontSize: 18)),
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

/////////
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        controller: txtbook_author_name,
                        decoration: const InputDecoration(
                            hintText: "اسم المؤلف", border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الاسم بشكل صحيح';
                          }

                          return null;
                        },
                      ),
                    ),

                    // CheckboxListTile(
                    //   title: const Text('الكتاب مجاني'),
                    //   value: checkActive,
                    //   onChanged: (value) => setState(() => {
                    //         checkActive = value!,
                    //         if (value == true)
                    //           {visible_enable = true, visible_text_price = false}
                    //         else
                    //           {visible_enable = false, visible_text_price = true}
                    //       }),
                    // ),
                    // Visibility(
                    //   visible: visible_text_price,
                    //   child: Container(
                    //     margin: const EdgeInsets.all(10.0),
                    //     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    //     decoration: BoxDecoration(
                    //       color: pcGrey,
                    //       borderRadius: BorderRadius.circular(20.0),
                    //     ),
                    //     child: TextFormField(
                    //       readOnly: visible_enable,
                    //       keyboardType: TextInputType.number,
                    //       decoration: const InputDecoration(
                    //           hintText: "سعر الكتاب (بالدولار)",
                    //           border: InputBorder.none),
                    //       validator: (value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'الرجاء إدخال سعر الكتاب';
                    //         }
                    //         if (value.length >= 6) {
                    //           return 'لا يمكن أن يكون بهذا السعر';
                    //         }
                    //         return null;
                    //       },
                    //     ),
                    //   ),
                    // ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                  ? Text("الصورة غير محددة")
                                  : Image.file(
                                      _image!,
                                      width: 150.0,
                                      height: 150.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            _image == null
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
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          selectFile();
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: fileUrl == null
                                    ? Text("الكتاب غير محمل")
                                    : Text(fileUrl)),
                            fileUrl == null
                                ? Icon(
                                    Icons.upload_file,
                                    size: 35.0,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.upload_file,
                                    size: 35.0,
                                    color: Colors.green,
                                  )
                          ],
                        ),
                      ),
                    ),

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
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        controller: txtbook_summary,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                            hintText: 'ملخص الكتاب', border: InputBorder.none),
                      ),
                    ),

                    isloading
                        ? circularProgress()
                        : MaterialButton(
                            onPressed: () {
                              saveBook(context, load);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "إضافة الكتاب",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.0),
                              ),
                              margin: const EdgeInsets.only(
                                  bottom: 10.0, top: 10.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: pcBlue,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            )),
                  ]),

                  //f
                ),
              );
            })
          ]),
        ),
      ),
    );
  }
}
