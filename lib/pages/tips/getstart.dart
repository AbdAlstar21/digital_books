import 'tips.dart';
import '../config.dart';
import 'package:flutter/material.dart';

class GetStart extends StatefulWidget {
  const GetStart({Key? key}) : super(key: key);

  @override
  _GetStartState createState() => _GetStartState();
}

class _GetStartState extends State<GetStart> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            alignment:Alignment.bottomRight,
            height: myHeight * 1.75,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                   decoration: const BoxDecoration(
              color: pcBlue,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 170, 225, 250),
                  spreadRadius: 6,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.only(topLeft:Radius.circular(90),
               
              ),
            ),
                  child: const Text(
                    "  عالم ",
                    style: TextStyle(
                        fontSize: 65,
                        color: Color.fromARGB(255, 255, 155, 24),
                     ),
                  ),
                ),Container(
                   decoration: const BoxDecoration(
              color: pcBlue,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 170, 225, 250),
                  spreadRadius: 6,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.only(topLeft:Radius.circular(90),
               
              ),
            ),
                  child: const Text("    الكتب ",
                    style: TextStyle(
                        fontSize: 65,
                        color: Colors.redAccent,
                        )),
                ),
                Container(
                   decoration: const BoxDecoration(
              color: pcBlue,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 170, 225, 250),
                  spreadRadius: 6,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.only(topLeft:Radius.circular(90),
               
              ),
            ),
                  child: 
                const Text("     الرقمية ",
                    style: TextStyle(
                        fontSize: 65,
                        color: Color.fromARGB(255, 255, 200, 0),
                       )),
                ),
              
              ],
            ),
          ),
          Container(
            height: myHeight * 1.25,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: pcBlue,
             boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 170, 225, 250),
                  spreadRadius: 6,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(145),
              ),
            ),
            child: ListView(
              children: <Widget>[
                Column(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "عالم الكتب الرقمية",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color.fromARGB(255, 185, 139, 0),
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                        " تطبيق تستطيع من خلاله تحميل أو رفع الكتب والمجلات والمقالات والأبحاث العلمية بصيغتها الرقمية ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: "Cairo",
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20.0,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Tips();
                          }));
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, bottom: 10.0, top: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const Text(
                            "  أبدأ من هنا  ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontFamily: "Cairo",
                                color: Color.fromARGB(255, 185, 139, 0),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
