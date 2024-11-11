import 'package:digital_books/pages/account/forgot.dart';
import 'package:digital_books/pages/account/register.dart';
import 'package:digital_books/pages/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../components/progres.dart';
import '../provider/loading.dart';
import 'login_data.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  TextEditingController txtuser_password = TextEditingController();
  TextEditingController txtuser_email = TextEditingController();
  void login(context, load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    if (txtuser_email.text.isNotEmpty &&
        txtuser_email.text.contains('.') &&
        txtuser_email.text.contains('@') &&
        txtuser_password.text.isNotEmpty &&
        txtuser_password.text.length >= 8) {
      isloading = true;
      load.add_loading();

      bool res =
          await loginUsers(txtuser_email.text, txtuser_password.text, context);

      isloading = res;
      load.add_loading();
    } else {
      Toast.show("المعلومات غير صحيحة", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pcWhite,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: pcBlue,
      //       size: 35,
      //     ),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      //  backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("واجهة تسجيل الدخول",
            style: TextStyle(
                // color: pcBlue,
                // fontSize: 28.0,
                // fontWeight: FontWeight.bold,
                )),
        // backgroundColor: Colors.transparent,
        // elevation: 0.0,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: pcBlue,
        //     size: 35,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          // margin: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(children: <Widget>[
                  const Center(
                    child: Text(
                      "عالم الكتب الرقمية",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: pcBlue,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "واجهة تسجيل الدخول",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color.fromARGB(255, 248, 225, 142),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "ادخل البريد الإلكتروني وكلمة المرور الخاصة بك\n                        للدخول إلى التطبيق ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color.fromARGB(255, 231, 219, 182),
                        // color: pcBlue,
                        fontSize: 20.0,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  const Icon(
                    Icons.account_circle,
                    size: 170,
                    color: pcBlue,
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
                          hintText: "كلمة المرور", border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة مرور';
                        }
                        if (value.length <= 8) {
                          return 'يجب أن تكون أكبر من 6 محارف';
                        }
                        return null;
                      },
                    ),
                  ),
                  Consumer<LoadingControl>(builder: (context, load, child) {
                    return isloading
                        ? circularProgress()
                        : MaterialButton(
                            onPressed: () {
                              login(context, load);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "دخول",
                                style: TextStyle(color: pcGrey, fontSize: 30.0),
                              ),
                              margin: const EdgeInsets.only(
                                  bottom: 10.0, top: 10.0),
                              // padding: const EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                color: pcBlue,
                                borderRadius: BorderRadius.circular(45.0),
                              ),
                            ));
                  }),
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          ' نسيت كلمة المرور...؟  ',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
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
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          ' ليس لدي حساب...؟  ',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: const Text(
                            'أنشئ حساب',
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
