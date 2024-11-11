// ignore_for_file: camel_case_types

import 'package:digital_books/pages/account/change_password.dart';
import 'package:digital_books/pages/account/myprofile.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/my_library/my_library.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../account/login.dart';
import '../books/file_upload.dart';

class myDrawer extends StatefulWidget {
  const myDrawer({Key? key}) : super(key: key);

  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  logout(context) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.remove(G_user_id);
    sh.remove(G_user_name);
    sh.remove(G_user_thumbnail);
    sh.remove(G_user_email);
    sh.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  ///start alertDialog
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info, color: pcBlue),
          const Text("معلومة",
              style:
                  const TextStyle(color: pcBlue, fontWeight: FontWeight.w500)),
        ],
      ),
      content: const Text("بواسطة: عبد الستار الشيخ أحمد"),
      elevation: 10,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(textDirection: TextDirection.rtl, child: alert);
      },
    );
  }

  ///end alertDialog
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              color: pcGrey,
              // padding: const EdgeInsets.only(right:50 , left: 40),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ProfilePicture(
                    name: G_user_name_val,
                    radius: 37,
                    fontsize: 21,
                    random: true,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    G_user_name_val,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(G_user_email_val,
                      style: const TextStyle(
                        color: Colors.black87,
                      )),
                  const Padding(padding: EdgeInsets.only(bottom: 5)),
                  //     UserAccountsDrawerHeader(
                  // currentAccountPictureSize:Size.square(7.0),
                  //       // margin: const EdgeInsets.all(5),
                  //       accountName: Text(
                  //         G_user_name_val,
                  //         style: const TextStyle(
                  //             color: Colors.black, fontSize: 17, fontFamily: "Cairo"),
                  //       ),
                  //       accountEmail: Text(G_user_email_val,
                  //           style: TextStyle(
                  //             color: Colors.black87,
                  //           )),
                  //       // currentAccountPicture:
                  //       //  ProfilePicture(
                  //       //     name: G_user_name_val,
                  //       //     radius: 31,
                  //       //     fontsize: 21,
                  //       //     random: true,
                  //       //   ),
                  //       // : ProfilePicture(
                  //       //     name: G_user_name_val,
                  //       //     // role: 'ADMINISTRATOR',
                  //       //     radius: 31,
                  //       //     fontsize: 21,
                  //       //     tooltip: true,
                  //       //     img: imageUsers + G_user_thumbnail_val,
                  //       //   ),
                  //       // decoration: const BoxDecoration(color: pcGrey),
                  //     ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const ListTile(
                    title: Text("الصفحة الرئيسية",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.home,
                      color: pcBlue,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyLibrary()));
                  },
                  child: const ListTile(
                    title: Text("مكتبتي",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.library_books,
                      color: pcBlue,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text("حسابي",
                  style: TextStyle(
                      fontFamily: "Cairo", fontSize: 20, color: Colors.black)),
              children: [
                ///child star account
                Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyProfile()));
                        },
                        child: const ListTile(
                          title: Text("تغيير الإعدادات الشخصية",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 17,
                                  color: Colors.black)),
                          leading: Icon(
                            Icons.person,
                            color: pcBlue,
                          ),
                          // trailing: Icon(Icons.arrow_back_ios_new,
                          //     color: Colors.black),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[500],
                      )
                    ],
                  ),
                ),

                ///child end account
                ///child star account
                Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePassword()));
                        },
                        child: const ListTile(
                          title: Text("تغيير كلمة المرور",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 17,
                                  color: Colors.black)),
                          leading: Icon(
                            Icons.lock_open,
                            color: pcBlue,
                          ),
                          // trailing: Icon(Icons.arrow_back_ios_new,
                          //     color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),

                ///child end account
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          // Container(
          //   padding: EdgeInsets.only(right: 10, left: 10),
          //   child: Column(
          //     children: [
          //       InkWell(
          //         onTap: () {},
          //         child: ListTile(
          //           title: Text("مفضلاتي",
          //               style: TextStyle(
          //                   fontFamily: "Cairo",
          //                   fontSize: 15,
          //                   color: Colors.black)),
          //           leading: Icon(
          //             Icons.favorite,
          //             color: pcBlue,
          //           ),
          //           trailing:
          //               Icon(Icons.arrow_back_ios_new, color: Colors.black),
          //         ),
          //       ),
          //       Divider(
          //         color: Colors.grey[500],
          //       )
          //     ],
          //   ),
          // ),

          // Container(
          //   padding: const EdgeInsets.only(right: 10, left: 10),
          //   child: Column(
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => CustomFilePicker()));
          //         },
          //         child: const ListTile(
          //           title: Text("الإشعارات",
          //               style: TextStyle(
          //                   fontFamily: "Cairo",
          //                   fontSize: 20,
          //                   color: Colors.black)),
          //           leading: Icon(
          //             Icons.notifications,
          //             color: pcBlue,
          //           ),
          //           trailing:
          //               Icon(Icons.arrow_back_ios_new, color: Colors.black),
          //         ),
          //       ),
          //       Divider(
          //         color: Colors.grey[500],
          //       )
          //     ],
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    title: Text("الإعدادات",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.settings,
                      color: pcBlue,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: const ListTile(
                    title: Text("حول التطبيق",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.help,
                      color: pcBlue,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    title: Text("مشاركة التطبيق",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.share,
                      color: pcBlue,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    logout(context);
                  },
                  child: const ListTile(
                    title: Text("تسجيل الخروج",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.logout,
                      color: pcBlue,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
