import 'dart:io';
import 'package:provider/provider.dart';

import '../components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../function.dart';
import '../provider/loading.dart';
import 'login.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  bool isloading = false;
  bool checkActive = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtuser_name = TextEditingController();
  TextEditingController txtuser_password = TextEditingController();
  TextEditingController txtuser_email = TextEditingController();
  // TextEditingController txt_user_gender = TextEditingController();
  // TextEditingController txt_user_image = TextEditingController();
  TextEditingController txtuser_note = TextEditingController();

  saveData(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (txtuser_email.text.isNotEmpty &&
        myvalid &&
        txtuser_name.text.isNotEmpty &&
        txtuser_email.text.contains('.') &&
        txtuser_email.text.contains('@') &&
        txtuser_password.text.isNotEmpty &&
        txtuser_password.text.length >= 6) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "user_name": txtuser_name.text,
        "user_email": txtuser_email.text,
        "user_password": txtuser_password.text,
        "user_active": checkActive ? "1" : "0",
        // "user_note": txtuser_note.text,
        "user_token": token
      };
      bool res = await uploadImageWithData(_image, arr, "users/insert_user.php",
          context, () => const Login(), "insert");

      isloading = res;
      load.add_loading();
    } else {
      Toast.show('not connected internet', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    txtuser_name.dispose();
    txtuser_password.dispose();
    txtuser_email.dispose();
    txtuser_note.dispose();
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

  Future getImageCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("كاميرا"),
                onTap: () {
                  getImageCamera();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pcWhite,
      appBar: AppBar(
        title: const Text("إنشاء حساب جديد"),
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            // color: pcBlue,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            Consumer<LoadingControl>(
              builder: (context, load, child) {
                return Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(children: <Widget>[
                      // const Text("إنشاء حساب",
                      //     style: TextStyle(
                      //         color: pcBlue,
                      //         fontSize: 28.0,
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: "Cairo")),
                      // Container(
                      //   margin: const EdgeInsets.only(bottom: 30.0),
                      //   child: const Text("جديد",
                      //       style: TextStyle(
                      //           color: pcBlue,
                      //           fontSize: 28.0,
                      //           fontWeight: FontWeight.bold,
                      //           fontFamily: "Cairo")),
                      // ),

                      const Icon(
                        Icons.app_registration,
                        size: 170,
                        color: pcBlue,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                          color: pcGrey,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextFormField(
                          controller: txtuser_name,
                          decoration: const InputDecoration(
                              hintText: "اسم المستخدم",
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم كاملاً';
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
                        child: TextFormField(
                          controller: txtuser_email,
                          decoration: const InputDecoration(
                              hintText: "البريد الإلكتروني",
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('.') ||
                                !value.contains('@')) {
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
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
                        child: TextFormField(
                          controller: txtuser_password,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "كلمة المرور",
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة مرور';
                            }
                            if (value.length <= 6) {
                              return 'يجب أن تكون أكبر من 6 محارف';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.image,
                              size: 60.0,
                              color: Colors.orange[400],
                            ),
                            onPressed: () {
                              showSheetGallery(context);
                            }),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        child: _image == null
                            ? const Text("الصورة غير محددة")
                            : Image.file(
                                _image!,
                                width: 150.0,
                                height: 150.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                      isloading
                          ? circularProgress()
                          : MaterialButton(
                              onPressed: () {
                                saveData(context, load);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: const Text(
                                  "تسجيل",
                                  style:
                                      TextStyle(color: pcGrey, fontSize: 25.0),
                                ),
                                margin: const EdgeInsets.only(
                                    bottom: 10.0, top: 20.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: pcBlue,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              )),
                      // Container(
                      //   margin: const EdgeInsets.all(20),
                      //   alignment: Alignment.center,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       const Text(
                      //         'عند الضغط على تسجيل فأنت توافق على شروط استخدام التطبيق',
                      //         style: TextStyle(color: Colors.black, fontSize: 18.0),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ]),
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 60.0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'لدي حساب... ',
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text(
                      'دخول',
                      style: TextStyle(color: pcBlue, fontSize: 19.0),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
