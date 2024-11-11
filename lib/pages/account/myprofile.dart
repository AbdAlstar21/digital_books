import 'package:digital_books/pages/config.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pcWhite,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text("تغيير الإعدادات الشخصية"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            // color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            Expanded(
              child: Form(
                child: ListView(children: <Widget>[
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: const Text("تغيير الإعدادات الشخصية",
                  //       style: TextStyle(
                  //           fontFamily: "Cairo",
                  //           color: pcBlue,
                  //           fontSize: 30.0,
                  //           fontWeight: FontWeight.bold)),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 30.0),
                  //   child: const Text("جديد",
                  //       style:
                  //           TextStyle(color: pcBlue, fontSize: 28.0)),
                  // ),

                  const Icon(
                    Icons.account_circle,
                    size: 170,
                    color: pcBlue,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: pcGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: "اسم المستخدم", border: InputBorder.none),
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
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "كلمة المرور", border: InputBorder.none),
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
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                                            color: pcGrey,

                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'رقم الهاتف', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم هاتف ';
                        }
                        if (value.length < 6) {
                          return ' الرجاء إدخال رقم هاتف صحيح';
                        }
                        return null;
                      },
                    ),
                  ),
                  MaterialButton(
                      onPressed: () {},
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "حفظ",
                          style: TextStyle(color: pcGrey, fontSize: 25.0),
                        ),
                        margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: pcBlue,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      )),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
