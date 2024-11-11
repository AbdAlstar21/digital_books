// @dart=2.9
// import 'package:digital_books/pages/tips/getstart.dart';
import 'package:digital_books/pages/home/selected_screen.dart';
import 'package:digital_books/pages/tips/tips.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/provider/loading.dart';
// import 'package:digital_books/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:digital_books/pages/provider/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
//for api

  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  G_user_id_val = prefs.getString(G_user_id);
  G_user_name_val = prefs.getString(G_user_name);
  G_user_email_val = prefs.getString(G_user_email);
  G_user_thumbnail_val = prefs.getString(G_user_thumbnail);


//
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.leanBack,
  // );

//for downloader
  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true // optional: set to false to disable printing logs to console (default: true)
      );

///////

  runApp(const Splash());
}

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoadingControl>(
            create: (context) => LoadingControl(),
          )
        ],
        child: MaterialApp(
            // theme: ThemeData.dark(),

            theme: ThemeData(
                fontFamily: "Cairo",
                primaryColor: pcBlue,
                backgroundColor: pcWhite,
                appBarTheme: const AppBarTheme(

                    // toolbarTextStyle: TextStyle(color: Colors.black),
                    backgroundColor: pcBlue,
                    // This will be applied to the "back" icon
                    iconTheme: IconThemeData(
                        color: Color.fromARGB(255, 231, 219, 182), size: 30),

                    // This will be applied to the action icon buttons that locates on the right side
                    // actionsIconTheme: IconThemeData(color: Colors.amber),
                    centerTitle: false,
                    // elevation: 15,
                    titleTextStyle: TextStyle(
                      color: Color.fromARGB(255, 231, 219, 182),
                      fontSize: 30,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.w600,
                      // fontWeight: FontWeight.bold,
                    ))),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(
              seconds: 6,
              navigateAfterSeconds:
                  G_user_id_val == null ?  const Tips() : const SelectedScreen(),

              title: const Text(
                'مرحباً',
                style: TextStyle(
                    // fontWeight: FontWeight.,
                    fontSize: 35.0,
                    fontFamily: "Cairo",
                    color: pcBlue),
              ),
              // title: const Text(
              //   'مرحباً',
              //   style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 20.0,
              //       //color:PrimaryColorGrey
              //       ),
              // ),

              image: Image.asset("images/logo.jpg"),
              //backgroundColor: PrimaryColorBlue,
              styleTextUnderTheLoader: const TextStyle(),
              photoSize: 150.0,
              loaderColor: pcBlue,
            )));
  }
}





// Delete all the contents of below directories.

// 1- C:\Users\USER_NAME.android\build-cache

// 2- C:\Users\USER_NAME.android\cache

// 3- C:\Users\USER_NAME.gradle\caches (optional if it doesn't works)


//rm -rf ~/.gradle/caches/
