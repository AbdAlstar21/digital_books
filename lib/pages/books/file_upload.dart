import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";

// // void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: CustomFilePicker() //set the class here
//         );
//   }
// }

// class CustomFilePicker extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _CustomFilePicker();
//   }
// }

// class _CustomFilePicker extends State<CustomFilePicker> {
//   File? _file;
//   Response? response;
//   String? progress;
//   Dio dio = Dio();

//   selectFile() async {
//     //  _file = await FilePicker.getFile(
//     //       type: FileType.custom,
//     //       allowedExtensions: ['doc', 'pdf', 'docx','ppt','pptx'],
//     //       //allowed extension to choose
//     //  );

//     //for file_pocker plugin version 2 or 2+

//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['doc', 'pdf', 'docx', 'ppt', 'pptx'],
//       //allowed extension to choose
//     );

//     if (result != null) {
//       //if there is selected file
//       _file = File(result.files.single.path!);
//     }

//     setState(() {
//       //   if (result != null) {
//       // //if there is selected file
//       // _file = File(result.files.single.path!);

//       // } else {
//       //   print('No file selected.');
//       // }
//     }); //update the UI so that file name is shown
//   }

//   uploadFile() async {
//     String uploadurl = "http://10.0.2.2:80/booksapp/lib/local_file_upload.php";
//     //dont use http://localhost , because emulator don't get that address
//     //insted use your local IP address or use live URL
//     //hit "ipconfig" in windows or "ip a" in linux to get you local IP

//     FormData formdata = FormData.fromMap({
//       "file": await MultipartFile.fromFile(_file!.path,
//           filename: basename(_file!.path)
//           //show only filename from path
//           ),
//     });

//     response = await dio.post(
//       uploadurl,
//       data: formdata,
//       onSendProgress: (int sent, int total) {
//         String percentage = (sent / total * 100).toStringAsFixed(2);
//         setState(() {
//           progress = "$sent" +
//               " Bytes of " "$total Bytes - " +
//               percentage +
//               " % uploaded";
//           //update the progress
//         });
//       },
//     );

//     if (response!.statusCode == 200) {
//       print(response.toString());
//       //print response from server
//     } else {
//       print("Error during connection to server.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Select File and Upload"),
//           backgroundColor: Colors.orangeAccent,
//         ), //set appbar
//         body: Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(40),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.all(10),
//                   //show file name here
//                   child: progress == null
//                       ? Text("Progress: 0%")
//                       : Text(
//                           basename("Progress: $progress"),
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 18),
//                         ),
//                   //show progress status here
//                 ),

//                 Container(
//                   margin: EdgeInsets.all(10),
//                   //show file name here
//                   child: _file == null
//                       ? Text("Choose File")
//                       : Text(basename(_file!.path)),
//                   //basename is from path package, to get filename from path
//                   //check if file is selected, if yes then show file name
//                 ),

//                 Container(
//                     child: RaisedButton.icon(
//                   onPressed: () {
//                     selectFile();
//                   },
//                   icon: Icon(Icons.folder_open),
//                   label: Text("CHOOSE FILE"),
//                   color: Colors.redAccent,
//                   colorBrightness: Brightness.dark,
//                 )),

//                 //if _file is null then show empty container
//                 //if file is selected then show upload button
//                 _file == null
//                     ? Container()
//                     : Container(
//                         child: RaisedButton.icon(
//                         onPressed: () {
//                           uploadFile();
//                         },
//                         icon: Icon(Icons.folder_open),
//                         label: Text("UPLOAD FILE"),
//                         color: Colors.redAccent,
//                         colorBrightness: Brightness.dark,
//                       ))
//               ],
//             )));
//   }
// }

class CustomFilePicker extends StatefulWidget {
  const CustomFilePicker({Key? key}) : super(key: key);

  @override
  _CustomFilePickerState createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  String? progress;
  var fileUrl;
  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
       type: FileType.custom,
       allowedExtensions: ['doc', 'pdf', 'docx', 'ppt', 'pptx'],
    );
     
    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {
        fileUrl = file.path;
      });
      print(fileUrl);
    } else {
      // User canceled the picker
    }
  }

  Future uploadFile() async {
    var uploadurl = "http://10.0.2.2:80/booksapp/lib/uploads.php";
    var url = Uri.parse(uploadurl);
    var request = http.MultipartRequest("POST", url);
    var uploadFile = await http.MultipartFile.fromPath("file", fileUrl);
    request.files.add(uploadFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      print(response.reasonPhrase);
      //print response from server
    } else {
      print("Error during connection to server.");
    }
  }

  // FormData formdata = FormData.fromMap({
  //   "file": await MultipartFile.fromFile(_file!.path,
  //       filename: basename(_file!.path)
  //       //show only filename from path
  //       ),
  // });

  // response = await dio.post(
  //   uploadurl,
  //   data: formdata,
  //   onSendProgress: (int sent, int total) {
  //     String percentage = (sent / total * 100).toStringAsFixed(2);
  //     setState(() {
  //       progress = "$sent" +
  //           " Bytes of " "$total Bytes - " +
  //           percentage +
  //           " % uploaded";
  //       //update the progress
  //     });
  //   },
  // );

  // if (response!.statusCode == 200) {
  //   print(response.toString());
  //   //print response from server
  // } else {
  //   print("Error during connection to server.");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select File and Upload"),
          backgroundColor: Colors.orangeAccent,
        ), //set appbar
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child: Column(
              children: <Widget>[
                // Container(
                //   margin: EdgeInsets.all(10),
                //   //show file name here
                //   child: progress == null
                //       ? Text("Progress: 0%")
                //       : Text(
                //           basename("Progress: $progress"),
                //           textAlign: TextAlign.center,
                //           style: TextStyle(fontSize: 18),
                //         ),
                //   //show progress status here
                // ),

                Container(
                  margin: EdgeInsets.all(10),
                  //show file name here
                  child: fileUrl == null ? Text("Choose File") : Text(fileUrl),
                  //basename is from path package, to get filename from path
                  //check if file is selected, if yes then show file name
                ),

                Container(
                    child: RaisedButton.icon(
                  onPressed: () {
                    selectFile();
                  },
                  icon: Icon(Icons.folder_open),
                  label: Text("CHOOSE FILE"),
                  color: Colors.redAccent,
                  colorBrightness: Brightness.dark,
                )),

                //if _file is null then show empty container
                //if file is selected then show upload button
                fileUrl == null
                    ? Container()
                    : Container(
                        child: RaisedButton.icon(
                        onPressed: () {
                          uploadFile();
                        },
                        icon: Icon(Icons.folder_open),
                        label: Text("UPLOAD FILE"),
                        color: Colors.redAccent,
                        colorBrightness: Brightness.dark,
                      ))
              ],
            )));
  }
}
