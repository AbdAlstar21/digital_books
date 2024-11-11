import 'package:digital_books/pages/config.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color:pcBlue,
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
            Expanded(
              child: Form(
                child: ListView(children: <Widget>[
                  const Text("إعادة تعيين كلمة المرور",
                      style: TextStyle(
                          color:pcBlue,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Cairo")),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30.0),
                    child: const Text(
                        "من فضلك أدخل عنوان البريد الإلكتروني الخاص بك ليتم إرسال رابط يمكنك من خلاله إعادة تعيين كلمة المرور",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w100,
                            fontFamily: "Cairo")),
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
                  MaterialButton(
                      onPressed: () {},
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "ارسال",
                          style: TextStyle(
                              color: pcGrey, fontSize: 25.0),
                        ),
                        margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color:pcBlue,
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
