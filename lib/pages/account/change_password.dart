import 'package:digital_books/pages/home/home.dart';
import 'package:digital_books/pages/account/forgot.dart';
import 'package:digital_books/pages/config.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pcWhite,
      appBar: AppBar(
        title:  const Text("تغيير كلمة المرور"),
        // backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            // color: pcBlack,
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
                  //   child: const Text("تغيير كلمة المرور",
                  //       style: TextStyle(
                  //           fontFamily: "Cairo",
                  //           color: pcBlue,
                  //           fontSize: 30.0,
                  //           fontWeight: FontWeight.bold)),
                  // ),
                  const Icon(
                    Icons.policy,
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
                      decoration: const InputDecoration(
                          hintText: "كلمة المرور الحالية",
                          border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة مرور صحيحة';
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
                          hintText: "كلمة المرور الجديدة",
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
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: pcGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: "تأكيد كلمة المرور ",
                          border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة مرور صحيحة';
                        }
                        return null;
                      },
                    ),
                  ),
                  MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  const Home()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "حفظ",
                          style: TextStyle(
                              color: pcGrey, fontSize: 25.0),
                        ),
                        margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: pcBlue,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          ' نسيت كلمة المرور...؟  ',
                          style: TextStyle(color: pcBlack, fontSize: 18.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Forgot()));
                          },
                          child: const Text(
                            'أعد تعينها',
                            style: TextStyle(color: pcBlue, fontSize: 19.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
