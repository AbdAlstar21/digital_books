// ignore_for_file: use_key_in_widget_constructors

import 'package:digital_books/pages/account/login.dart';
import 'package:digital_books/pages/account/register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_indicator/page_indicator.dart';
import '../config.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Tips extends StatefulWidget {
  const Tips({Key? key}) : super(key: key);

  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  // var myarr = [
  //   {
  //     "title": "الواجهة الرئيسية",
  //     "info": "تضم جميع الكتب  الموجودة في التطبيق ويوجد ضمنها بعض الفلاتر ",
  //     "image":
  //         "https://www.esyria.sy/old/sites/images/damascus/misc/138358_2012_02_20_23_20_53.jpg"
  //   },
  //   {
  //     "title": "واجهة كتبي",
  //     "info": "الواجهة التي يتمكن المستخدم من خلالها بإضافة وتعديل وحذف الكتب الخاصة به",
  //     "image":
  //         "https://www.esyria.sy/old/sites/images/damascus/misc/138358_2012_02_20_23_20_53.jpg"
  //   },
  //   {
  //     "title": "واجهة المفضلة",
  //     "info": "تحوي هذه الواجهة على الكتب التي تم تفضيلها من قبل المستخدم",
  //     "image":
  //         "https://www.esyria.sy/old/sites/images/damascus/misc/138358_2012_02_20_23_20_53.jpg"
  //   },
  //   {
  //     "title": "واجهة التنزيلات",
  //     "info": "تحوي هذه الواجهة على الكتب التي تم تحميلها من قبل المستخدم",
  //     "image":
  //         "https://www.esyria.sy/old/sites/images/damascus/misc/138358_2012_02_20_23_20_53.jpg"
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height / 6;
    return Scaffold(
      backgroundColor: pcWhite,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(top: 30.0, right: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text(
                  "دخول",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    color: pcBlue,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(20),
            //   child: SizedBox(
            //     height: myHeight * 4,
            //     child: PageIndicatorContainer(
            //       shape: IndicatorShape.circle(),
            //       length: myarr.length,
            //       align: IndicatorAlign.bottom,
            //       indicatorColor: Colors.grey,
            //       indicatorSelectorColor: Colors.blue,
            //       child: PageView.builder(
            //         physics: const AlwaysScrollableScrollPhysics(),
            //         scrollDirection: Axis.horizontal,
            //         itemCount: myarr.length,
            //         itemBuilder: (BuildContext context, i) {
            //           return SingleTips(
            //               title: myarr[i]["title"]!,
            //               info: myarr[i]["info"]!,
            //               image: myarr[i]["image"]!);
            //         },
            //       ),
            //     ),
            //   ),
            // ),
////
            SizedBox(
      width: 315.0,
  child: DefaultTextStyle(
    style: const TextStyle(
      fontSize: 30.0,
      fontFamily: 'Agne',
      color:Colors.indigo,
      fontWeight: FontWeight.bold
    ),
    child: AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText('World'),
        TypewriterAnimatedText('World of'),
        TypewriterAnimatedText('World of Digital'),
        TypewriterAnimatedText('World of Digital Books'),
      ],
      onTap: () {
        print("Tap Event");
      },
    ),
  ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  height: myHeight * 1,
                  child: Lottie.asset("lotties/9.json")),
            ),
 Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  height: myHeight * 1.8,
                  child: Lottie.asset("lotties/7.json")),
            ),
            Expanded(
              child: Container(
                height: myHeight,
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    Column(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: pcBlue,
                            ),
                            child: const Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Colors.black,
                                  fontSize: 25.0),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: const Color.fromARGB(255, 110, 120, 255),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "متابعة باستخدام الفيس بوك   ",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      color: Colors.black,
                                      fontSize: 25.0),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.facebookF,
                                  size: 27.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.redAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "متابعة باستخدام جوجل             ",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      color: Colors.black,
                                      fontSize: 25.0),
                                ),
                                Text( "G",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      color: Color.fromARGB(255, 82, 2, 2),
                                       fontWeight: FontWeight.bold,
                                      fontSize: 26.0),)
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class SingleTips extends StatelessWidget {
//   final String title;
//   final String info;
//   final String image;
//   const SingleTips({
//     required this.title,
//     required this.info,
//     required this.image,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//             child: Container(
//           alignment: Alignment.center,
//           child: Image.network(
//             image,
//             fit: BoxFit.fill,
//           ),
//         )),
//         Padding(
//           padding: const EdgeInsets.all(5),
//           child: Text(
//             title,
//             style: const TextStyle(
//                 fontFamily: "Cairo",
//                 color: Colors.brown,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 40.0),
//           child: Text(
//             info,
//             style: const TextStyle(
//                 fontFamily: "Cairo",
//                 color: Colors.blue,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
